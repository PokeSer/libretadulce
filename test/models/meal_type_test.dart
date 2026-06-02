import 'package:flutter_test/flutter_test.dart';
import 'package:libretadulce/models/meal_type.dart';

void main() {
  group('MealType.fromString', () {
    test('should parse exact rawValues', () {
      expect(MealType.fromString('Desayuno'), MealType.desayuno);
      expect(MealType.fromString('Almuerzo'), MealType.almuerzo);
      expect(MealType.fromString('Cena'), MealType.cena);
      expect(MealType.fromString('Snack / Otro'), MealType.snack);
    });

    test('should be case insensitive', () {
      expect(MealType.fromString('desayuno'), MealType.desayuno);
      expect(MealType.fromString('DESAYUNO'), MealType.desayuno);
      expect(MealType.fromString('Almuerzo'), MealType.almuerzo);
    });

    test('should trim whitespace', () {
      expect(MealType.fromString('  Desayuno  '), MealType.desayuno);
      expect(MealType.fromString(' Cena '), MealType.cena);
    });

    test('should default to snack for unknown values', () {
      expect(MealType.fromString('unknown'), MealType.snack);
      expect(MealType.fromString(''), MealType.snack);
    });
  });

  group('MealType.mealList', () {
    test('should contain all 6 meal types', () {
      expect(MealType.mealList.length, 6);
    });

    test('should contain all expected types', () {
      final list = MealType.mealList;
      expect(list, contains(MealType.desayuno));
      expect(list, contains(MealType.mediaManana));
      expect(list, contains(MealType.almuerzo));
      expect(list, contains(MealType.merienda));
      expect(list, contains(MealType.cena));
      expect(list, contains(MealType.snack));
    });
  });
}
