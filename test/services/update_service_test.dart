import 'package:flutter_test/flutter_test.dart';

// Extracted version comparison logic for testing
int compareVersions(String a, String b) {
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

int _parseLeadingInt(String s) {
  if (s.isEmpty) return 0;
  final match = RegExp(r'^(\d+)').firstMatch(s);
  if (match == null) return 0;
  return int.parse(match.group(0)!);
}

void main() {
  group('compareVersions', () {
    test('should return 0 for equal versions', () {
      expect(compareVersions('1.0.0', '1.0.0'), 0);
    });

    test('should detect newer major version', () {
      expect(compareVersions('2.0.0', '1.0.0'), greaterThan(0));
      expect(compareVersions('1.0.0', '2.0.0'), lessThan(0));
    });

    test('should detect newer minor version', () {
      expect(compareVersions('1.2.0', '1.1.0'), greaterThan(0));
    });

    test('should detect newer patch version', () {
      expect(compareVersions('1.0.2', '1.0.1'), greaterThan(0));
    });

    test('should handle versions with different lengths', () {
      expect(compareVersions('1.0', '1.0.0'), 0);
      expect(compareVersions('1.0.1', '1.0'), greaterThan(0));
    });

    test('should handle versions with dashes', () {
      expect(compareVersions('1.0.0-beta', '1.0.0'), 0);
    });

    test('should compare current app version correctly', () {
      expect(compareVersions('1.1.1', '1.1.0'), greaterThan(0));
      expect(compareVersions('1.1.1', '1.1.2'), lessThan(0));
      expect(compareVersions('1.1.1', '1.1.1'), 0);
    });
  });
}
