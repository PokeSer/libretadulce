import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

typedef ProgressCallback = void Function(double progress);

class UpdateService {
  static const _owner = 'PokeSer';
  static const _repo = 'libretadulce';
  static const _apiUrl =
      'https://api.github.com/repos/$_owner/$_repo/releases/latest';

  static Future<UpdateInfo?> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await http.get(
        Uri.parse(_apiUrl),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final latestTag = (data['tag_name'] as String?)?.replaceFirst('v', '');

      if (latestTag == null) return null;
      if (latestTag == currentVersion) return null;

      final isNewer = _compareVersions(latestTag, currentVersion) > 0;
      if (!isNewer) return null;

      final assets = data['assets'] as List<dynamic>? ?? [];
      final downloadUrl = await _selectBestApkUrl(assets) ??
          data['html_url'] as String?;

      if (downloadUrl == null || downloadUrl.isEmpty) return null;

      final cleanNotes = _cleanReleaseNotes(data['body'] as String? ?? '');
      return UpdateInfo(
        version: latestTag,
        downloadUrl: downloadUrl,
        releaseNotes: cleanNotes,
      );
    } catch (e) {
      debugPrint('Update check failed: $e');
      return null;
    }
  }

  static Future<String?> _selectBestApkUrl(List<dynamic> assets) async {
    final abi = await _getDeviceAbi();
    debugPrint('Device ABI: $abi');

    // Build a map of asset name -> download URL
    final apkUrls = <String, String>{};
    for (final asset in assets) {
      final name = asset['name'] as String? ?? '';
      final url = asset['browser_download_url'] as String?;
      if (name.endsWith('.apk') && url != null) {
        apkUrls[name] = url;
      }
    }

    if (apkUrls.isEmpty) return null;

    // Priority 1: specific ABI match
    if (abi != null) {
      for (final entry in apkUrls.entries) {
        if (entry.key.contains(abi)) {
          debugPrint('Selected APK: ${entry.key} (ABI match: $abi)');
          return entry.value;
        }
      }
    }

    // Priority 2: universal APK fallback
    for (final entry in apkUrls.entries) {
      if (entry.key.contains('universal')) {
        debugPrint('Selected APK: ${entry.key} (universal fallback)');
        return entry.value;
      }
    }

    // Priority 3: any APK (last resort)
    final first = apkUrls.entries.first;
    debugPrint('Selected APK: ${first.key} (first available)');
    return first.value;
  }

  static Future<String?> _getDeviceAbi() async {
    if (kIsWeb || !Platform.isAndroid) return null;
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.supportedAbis.isNotEmpty
          ? androidInfo.supportedAbis.first
          : null;
    } catch (e) {
      debugPrint('Failed to get device ABI: $e');
      return null;
    }
  }

  static int _compareVersions(String a, String b) {
    final aParts = a.split(RegExp(r'[.-]'));
    final bParts = b.split(RegExp(r'[.-]'));

    final maxLen = aParts.length > bParts.length ? aParts.length : bParts.length;
    for (int i = 0; i < maxLen; i++) {
      final aNum = _parseLeadingInt(i < aParts.length ? aParts[i] : '');
      final bNum = _parseLeadingInt(i < bParts.length ? bParts[i] : '');
      final cmp = aNum.compareTo(bNum);
      if (cmp != 0) return cmp;
    }
    return 0;
  }

  static int _parseLeadingInt(String s) {
    if (s.isEmpty) return 0;
    final match = RegExp(r'^(\d+)').firstMatch(s);
    if (match == null) return 0;
    return int.parse(match.group(0)!);
  }

  static String _cleanReleaseNotes(String raw) {
    var text = raw;
    text = text.replaceAll(RegExp(r'\[([^\]]*)\]\([^)]*\)'), r'$1');
    text = text.replaceAll(RegExp(r'^#{1,6}\s*', multiLine: true), '');
    text = text.replaceAll(RegExp(r'\*{1,3}([^*]+)\*{1,3}'), r'$1');
    text = text.replaceAll(RegExp(r'`([^`]+)`'), r'$1');
    return text.trim();
  }

  static Future<bool> downloadAndInstall(
    String url, {
    ProgressCallback? onProgress,
  }) async {
    if (!kIsWeb && Platform.isIOS) return false;
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/libretadulce_update.apk');

      final client = http.Client();
      try {
        final request = http.Request('GET', Uri.parse(url));
        final response = await client.send(request).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException('Connection timeout'),
        );

        if (response.statusCode != 200) {
          debugPrint('Download failed: HTTP ${response.statusCode}');
          return false;
        }

        final contentLength = response.contentLength ?? 0;
        final sink = file.openWrite();
        int downloaded = 0;

        await for (final chunk in response.stream) {
          sink.add(chunk);
          downloaded += chunk.length;
          if (contentLength > 0 && onProgress != null) {
            onProgress(downloaded / contentLength);
          }
        }

        await sink.flush();
        await sink.close();
      } finally {
        client.close();
      }

      if (!await file.exists()) {
        debugPrint('APK file not found after download');
        return false;
      }

      final fileSize = await file.length();
      if (fileSize < 1000) {
        debugPrint('APK file too small ($fileSize bytes), likely not a valid APK');
        return false;
      }

      debugPrint('APK downloaded: ${file.path} ($fileSize bytes)');

      final result = await OpenFilex.open(
        file.path,
        type: 'application/vnd.android.package-archive',
      );

      debugPrint('OpenFilex result: ${result.type} - ${result.message}');
      return result.type == ResultType.done;
    } on TimeoutException {
      debugPrint('Download timed out');
      return false;
    } catch (e, stack) {
      debugPrint('Download/install failed: $e');
      debugPrint('Stack: $stack');
      return false;
    }
  }
}

class UpdateInfo {
  final String version;
  final String downloadUrl;
  final String releaseNotes;

  const UpdateInfo({
    required this.version,
    required this.downloadUrl,
    required this.releaseNotes,
  });
}
