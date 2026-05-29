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

      downloadUrl ??= data['html_url'] as String?;
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
