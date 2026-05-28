import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

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
      );

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final latestTag = (data['tag_name'] as String?)?.replaceFirst('v', '');

      if (latestTag == null) return null;
      if (latestTag == currentVersion) return null;

      final isNewer = _compareVersions(latestTag, currentVersion) > 0;
      if (!isNewer) return null;

      final assets = data['assets'] as List<dynamic>? ?? [];
      String? downloadUrl;

      for (final asset in assets) {
        final name = asset['name'] as String? ?? '';
        if (name.contains('arm64-v8a-release') || name.contains('arm64-v8a')) {
          downloadUrl = asset['browser_download_url'] as String?;
          break;
        }
      }

      downloadUrl = data['html_url'] as String?;
      if (downloadUrl == null || downloadUrl.isEmpty) return null;
      return UpdateInfo(
        version: latestTag,
        downloadUrl: downloadUrl,
        releaseNotes: data['body'] as String? ?? '',
      );
    } catch (e) {
      debugPrint('Update check failed: $e');
      return null;
    }
  }

  static int _compareVersions(String a, String b) {
    final aParts = a.split(RegExp(r'[.-]'));
    final bParts = b.split(RegExp(r'[.-]'));

    for (int i = 0; i < aParts.length && i < bParts.length; i++) {
      final aNum = int.tryParse(aParts[i]) ?? 0;
      final bNum = int.tryParse(bParts[i]) ?? 0;
      final cmp = aNum.compareTo(bNum);
      if (cmp != 0) return cmp;

      final aStr = aParts[i].toLowerCase();
      final bStr = bParts[i].toLowerCase();
      if (aStr != bStr) {
        if (aStr.isEmpty && bStr.isNotEmpty) return 1;
        if (bStr.isEmpty && aStr.isNotEmpty) return -1;
        return aStr.compareTo(bStr);
      }
    }

    return aParts.length.compareTo(bParts.length);
  }

  static Future<bool> downloadAndInstall(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/libretadulce_update.apk');

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return false;

      await file.writeAsBytes(response.bodyBytes);

      final result = await OpenFilex.open(file.path,
          type: 'application/vnd.android.package-archive');
      return result.type == ResultType.done;
    } catch (e) {
      debugPrint('Download/install failed: $e');
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
