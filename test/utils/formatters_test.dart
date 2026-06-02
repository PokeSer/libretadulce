import 'package:flutter_test/flutter_test.dart';
import 'package:libretadulce/core/utils/formatters.dart';

void main() {
  group('parseSpanishDecimal', () {
    test('should parse integer string', () {
      expect(parseSpanishDecimal('10'), 10.0);
    });

    test('should parse decimal with dot', () {
      expect(parseSpanishDecimal('10.5'), 10.5);
    });

    test('should parse decimal with comma', () {
      expect(parseSpanishDecimal('10,5'), 10.5);
    });

    test('should return null for empty string', () {
      expect(parseSpanishDecimal(''), isNull);
    });

    test('should return null for non-numeric string', () {
      expect(parseSpanishDecimal('abc'), isNull);
    });

    test('should handle zero', () {
      expect(parseSpanishDecimal('0'), 0.0);
    });

    test('should handle negative numbers', () {
      expect(parseSpanishDecimal('-5.5'), -5.5);
    });

    test('should handle multiple commas by replacing all with dots', () {
      // '1,2,3' -> '1.2.3' -> double.tryParse returns null
      expect(parseSpanishDecimal('1,2,3'), isNull);
    });
  });
}
