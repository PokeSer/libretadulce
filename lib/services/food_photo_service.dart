import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Food photos: local-first, cloud-bootstrap.
///
/// The full photo lives only on the device that took it
/// (`food_photos/{foodId}.jpg`) and never touches Firestore. A tiny JPEG
/// thumbnail (~10-20KB as base64) is mirrored to a subcollection of the food
/// document (`foods/{foodId}/photos/thumb`), which inherits the user's
/// security rules and keeps the food list documents lean. Any other device
/// fetches the thumbnail once, caches it locally, and never reads it again.
class FoodPhotoService {
  FoodPhotoService._();

  static const _dirName = 'food_photos';
  static const _ext = '.jpg';
  static const _thumbSuffix = '_thumb';

  /// Thumbnail encoding budget: 256px @ q55 lands around 8-15KB, so the
  /// base64 payload stays far below any meaningful quota concern.
  static const thumbWidth = 256;
  static const thumbQuality = 55;

  /// Pick configuration keeps photos small at capture time: the picker
  /// downscales and re-encodes before the file ever reaches app storage.
  static ImagePicker get picker => _picker;
  static final ImagePicker _picker = ImagePicker();

  static const pickImageQuality = 72;
  static const pickMaxDimension = 1024.0;

  /// Ids checked this session whose remote thumbnail does not exist, so a
  /// photo-less food costs zero extra reads on list rebuilds.
  static final _missingRemoteThumbs = <String>{};
  /// In-flight remote fetches, deduplicated across widget rebuilds.
  static final _inFlightFetches = <String, Future<Uint8List?>>{};
  /// Uids whose photo library already went through [syncMissingThumbs] this
  /// session, so stream emissions can trigger it repeatedly for free.
  static final _thumbSyncDone = <String>{};

  static Future<Directory> _photosDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/$_dirName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  // ── Full local photo ────────────────────────────────────────────

  /// Returns the full-resolution local photo for [foodId], or null.
  static Future<File?> getPhoto(String foodId) async {
    if (foodId.isEmpty) return null;
    try {
      final dir = await _photosDir();
      final file = File('${dir.path}/$foodId$_ext');
      return await file.exists() ? file : null;
    } catch (e) {
      debugPrint('[FoodPhotoService.getPhoto] Error: $e');
      return null;
    }
  }

  /// Persists a picked image locally under [foodId] as bounded JPEG.
  static Future<File?> savePhoto(String foodId, XFile picked) async {
    if (foodId.isEmpty) return null;
    try {
      final dir = await _photosDir();
      final target = File('${dir.path}/$foodId$_ext');
      await picked.saveTo(target.path);
      return target;
    } catch (e) {
      debugPrint('[FoodPhotoService.savePhoto] Error: $e');
      return null;
    }
  }

  // ── Thumbnail generation & local cache ──────────────────────────

  /// Encodes [source] down to the shared thumbnail size/quality.
  /// Returns null when compression is unavailable on this device.
  static Future<Uint8List?> generateThumbBytes(File source) async {
    try {
      return await FlutterImageCompress.compressWithFile(
        source.path,
        minWidth: thumbWidth,
        minHeight: thumbWidth,
        quality: thumbQuality,
        format: CompressFormat.jpeg,
      );
    } catch (e) {
      debugPrint('[FoodPhotoService.generateThumbBytes] Error: $e');
      return null;
    }
  }

  /// Writes [bytes] into the local thumbnail cache for [foodId].
  static Future<void> saveLocalThumb(String foodId, Uint8List bytes) async {
    if (foodId.isEmpty) return;
    try {
      final dir = await _photosDir();
      await File('${dir.path}/$foodId$_thumbSuffix$_ext').writeAsBytes(bytes,
          flush: true);
    } catch (e) {
      debugPrint('[FoodPhotoService.saveLocalThumb] Error: $e');
    }
  }

  /// Reads the locally cached thumbnail for [foodId], if any.
  static Future<Uint8List?> getLocalThumb(String foodId) async {
    if (foodId.isEmpty) return null;
    try {
      final dir = await _photosDir();
      final file = File('${dir.path}/$foodId$_thumbSuffix$_ext');
      return await file.exists() ? await file.readAsBytes() : null;
    } catch (e) {
      debugPrint('[FoodPhotoService.getLocalThumb] Error: $e');
      return null;
    }
  }

  // ── Cloud thumbnail mirror ──────────────────────────────────────

  static DocumentReference<Map<String, dynamic>> _thumbDoc(
    String uid,
    String foodId,
  ) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('foods')
          .doc(foodId)
          .collection('photos')
          .doc('thumb');

  /// Mirrors the encoded thumbnail to Firestore under the food document.
  /// Returns false when the write was rejected (e.g. rules not deployed):
  /// callers keep the local copy either way.
  static Future<bool> uploadThumb(
    String uid,
    String foodId,
    Uint8List bytes,
  ) async {
    if (uid.isEmpty || foodId.isEmpty || bytes.isEmpty) return false;
    try {
      await _thumbDoc(uid, foodId).set({
        'data': base64Encode(bytes),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint('[FoodPhotoService.uploadThumb] Error: $e');
      return false;
    }
  }

  /// Marks [foodId]'s thumbnail as mirrored so session syncs skip it.
  static Future<void> markSynced(String foodId) async {
    if (foodId.isEmpty) return;
    try {
      final dir = await _photosDir();
      await File('${dir.path}/$foodId.synced').writeAsString('');
    } catch (e) {
      debugPrint('[FoodPhotoService.markSynced] Error: $e');
    }
  }

  /// One-shot per session: re-mirrors thumbnails for foods that have a local
  /// full photo but whose thumbnail never reached Firestore (saves made
  /// before the rules existed, failed mirrors, reinstalls). Runs from the
  /// first list emission, costs zero reads for fully synced libraries.
  static Future<void> syncMissingThumbs(
    String uid,
    Iterable<String> foodIds,
  ) async {
    if (uid.isEmpty || _thumbSyncDone.contains(uid)) return;
    _thumbSyncDone.add(uid);
    try {
      final dir = await _photosDir();
      for (final foodId in foodIds) {
        if (foodId.isEmpty) continue;
        final marker = File('${dir.path}/$foodId.synced');
        if (await marker.exists()) continue;
        final full = File('${dir.path}/$foodId$_ext');
        if (!await full.exists()) continue;

        final bytes = await generateThumbBytes(full);
        if (bytes == null) continue;
        await saveLocalThumb(foodId, bytes);
        final ok = await uploadThumb(uid, foodId, bytes);
        if (ok) await marker.writeAsString('');
        debugPrint(
          '[FoodPhotoService.syncMissingThumbs] $foodId: '
          '${ok ? 'mirrored' : 'upload rejected'}',
        );
      }
    } catch (e) {
      debugPrint('[FoodPhotoService.syncMissingThumbs] Error: $e');
      // Allow a retry on the next emission when the pass itself broke.
      _thumbSyncDone.remove(uid);
    }
  }

  /// Fetches the mirrored thumbnail once per session, caching it locally so
  /// subsequent sessions read from disk only. Returns null when absent.
  static Future<Uint8List?> resolveThumb(String uid, String foodId) async {
    if (uid.isEmpty || foodId.isEmpty) return null;
    final key = '$uid/$foodId';

    final local = await getLocalThumb(foodId);
    if (local != null) return local;

    if (_missingRemoteThumbs.contains(key)) return null;
    if (_inFlightFetches.containsKey(key)) return _inFlightFetches[key];

    final future = _fetchAndCacheThumb(uid, foodId, key);
    _inFlightFetches[key] = future;
    try {
      return await future;
    } finally {
      _inFlightFetches.remove(key);
    }
  }

  static Future<Uint8List?> _fetchAndCacheThumb(
    String uid,
    String foodId,
    String key,
  ) async {
    try {
      final snap = await _thumbDoc(uid, foodId).get();
      final data = snap.data()?['data'];
      if (data is! String || data.isEmpty) {
        _missingRemoteThumbs.add(key);
        return null;
      }
      final bytes = base64Decode(data);
      await saveLocalThumb(foodId, bytes);
      return bytes;
    } catch (e) {
      debugPrint('[FoodPhotoService.resolveThumb] Error: $e');
      return null;
    }
  }

  // ── Deletion ────────────────────────────────────────────────────

  /// Removes every trace of a food's photos: full local file, local thumb
  /// cache, sync marker, and the mirrored thumbnail document. Never throws.
  static Future<void> deleteAll(String uid, String foodId) async {
    if (foodId.isEmpty) return;
    try {
      final dir = await _photosDir();
      for (final name in [
        '$foodId$_ext',
        '$foodId$_thumbSuffix$_ext',
        '$foodId.synced',
      ]) {
        final file = File('${dir.path}/$name');
        if (await file.exists()) await file.delete();
      }
    } catch (e) {
      debugPrint('[FoodPhotoService.deleteAll files] Error: $e');
    }
    if (uid.isNotEmpty) {
      try {
        await _thumbDoc(uid, foodId).delete();
      } catch (e) {
        debugPrint('[FoodPhotoService.deleteAll doc] Error: $e');
      }
    }
    _missingRemoteThumbs.remove('$uid/$foodId');
  }

  /// Clears cached resolution state when a photo is replaced.
  static void forget(String uid, String foodId) =>
      _missingRemoteThumbs.remove('$uid/$foodId');
}
