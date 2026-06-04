import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_paths.dart';
import '../core/exceptions/app_exception.dart';
import '../models/insulin_settings.dart';

class InsulinSettingsService {
  static DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      FirestorePaths.userInsulinSettings(uid);

  static Future<InsulinSettings?> getSettings(String uid) async {
    return wrapServiceCall('InsulinSettingsService.getSettings', () async {
      final doc = await _doc(uid).get();
      if (!doc.exists || doc.data() == null) return null;
      return InsulinSettings.fromFirestore(doc.data()!);
    });
  }

  static Future<void> saveSettings(String uid, InsulinSettings settings) async {
    await wrapServiceCall('InsulinSettingsService.saveSettings', () async {
      await _doc(uid).set(settings.toFirestore());
    });
  }
}
