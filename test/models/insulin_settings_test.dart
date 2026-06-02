import 'package:flutter_test/flutter_test.dart';
import 'package:libretadulce/models/insulin_settings.dart';
import 'package:libretadulce/models/meal_type.dart';

void main() {
  group('InsulinSettings.calculateMealBolus', () {
    test('should calculate bolus using base ratio', () {
      const settings = InsulinSettings(
        ratioBase: 1.0,
        factorCorreccion: 50.0,
        glucosaObjetivo: 100.0,
      );

      // 50g carbs = 5 raciones, ratio 1.0 -> 5.0 bolus
      final bolus = settings.calculateMealBolus(50.0);

      expect(bolus, 5.0);
    });

    test('should use meal-specific ratio when provided', () {
      const settings = InsulinSettings(
        ratioBase: 1.0,
        ratioDesayuno: 1.5,
        factorCorreccion: 50.0,
        glucosaObjetivo: 100.0,
      );

      final bolusBase = settings.calculateMealBolus(50.0);
      final bolusDesayuno = settings.calculateMealBolus(
        50.0,
        mealType: MealType.desayuno,
      );

      expect(bolusBase, 5.0);
      expect(bolusDesayuno, 7.5);
    });

    test('should fall back to base ratio when meal ratio is null', () {
      const settings = InsulinSettings(
        ratioBase: 1.0,
        factorCorreccion: 50.0,
        glucosaObjetivo: 100.0,
      );

      final bolus = settings.calculateMealBolus(
        50.0,
        mealType: MealType.cena,
      );

      expect(bolus, 5.0);
    });

    test('should return 0 for 0 carbs', () {
      const settings = InsulinSettings(
        ratioBase: 1.0,
        factorCorreccion: 50.0,
        glucosaObjetivo: 100.0,
      );

      expect(settings.calculateMealBolus(0.0), 0.0);
    });
  });

  group('InsulinSettings.calculateCorrection', () {
    const settings = InsulinSettings(
      ratioBase: 1.0,
      factorCorreccion: 50.0,
      glucosaObjetivo: 100.0,
    );

    test('should return 0 when glucose is at target', () {
      expect(settings.calculateCorrection(100.0), 0.0);
    });

    test('should return 0 when glucose is below target', () {
      expect(settings.calculateCorrection(80.0), 0.0);
    });

    test('should calculate correction when above target', () {
      // (150 - 100) / 50 = 1.0
      expect(settings.calculateCorrection(150.0), 1.0);
    });

    test('should handle fractional corrections', () {
      // (130 - 100) / 50 = 0.6
      expect(settings.calculateCorrection(130.0), closeTo(0.6, 0.001));
    });
  });

  group('InsulinSettings.roundBolus', () {
    test('should round to nearest integer when no half units', () {
      const settings = InsulinSettings(
        ratioBase: 1.0,
        factorCorreccion: 50.0,
        glucosaObjetivo: 100.0,
        supportsHalfUnits: false,
      );

      expect(settings.roundBolus(4.3), 4.0);
      expect(settings.roundBolus(4.7), 5.0);
      expect(settings.roundBolus(4.5), 5.0);
    });

    test('should round to nearest 0.5 when half units supported', () {
      const settings = InsulinSettings(
        ratioBase: 1.0,
        factorCorreccion: 50.0,
        glucosaObjetivo: 100.0,
        supportsHalfUnits: true,
      );

      expect(settings.roundBolus(4.3), 4.5);
      expect(settings.roundBolus(4.7), 4.5);
      expect(settings.roundBolus(4.8), 5.0);
    });

    test('should round down when roundBolusDown is true', () {
      const settings = InsulinSettings(
        ratioBase: 1.0,
        factorCorreccion: 50.0,
        glucosaObjetivo: 100.0,
        supportsHalfUnits: true,
        roundBolusDown: true,
      );

      expect(settings.roundBolus(4.7), 4.5);
      expect(settings.roundBolus(4.3), 4.0);
    });

    test('should round down to integer when no half units and roundDown', () {
      const settings = InsulinSettings(
        ratioBase: 1.0,
        factorCorreccion: 50.0,
        glucosaObjetivo: 100.0,
        supportsHalfUnits: false,
        roundBolusDown: true,
      );

      expect(settings.roundBolus(4.7), 4.0);
      expect(settings.roundBolus(4.3), 4.0);
    });
  });

  group('InsulinSettings glucose unit conversion', () {
    test('should convert mg/dL to mmol/L when usesMmolL is true', () {
      const settings = InsulinSettings(
        ratioBase: 1.0,
        factorCorreccion: 50.0,
        glucosaObjetivo: 100.0,
        usesMmolL: true,
      );

      // 180 mg/dL / 18.018 = ~9.99 mmol/L
      final mmol = settings.toStoredGlucoseUnit(180.0);
      expect(mmol, closeTo(9.99, 0.01));
    });

    test('should not convert when usesMmolL is false', () {
      const settings = InsulinSettings(
        ratioBase: 1.0,
        factorCorreccion: 50.0,
        glucosaObjetivo: 100.0,
        usesMmolL: false,
      );

      expect(settings.toStoredGlucoseUnit(180.0), 180.0);
    });

    test('should convert stored value back to display', () {
      const settings = InsulinSettings(
        ratioBase: 1.0,
        factorCorreccion: 50.0,
        glucosaObjetivo: 100.0,
        usesMmolL: true,
      );

      final stored = settings.toStoredGlucoseUnit(180.0);
      final display = settings.fromStoredGlucoseUnit(stored);

      expect(display, closeTo(180.0, 0.1));
    });
  });

  group('InsulinSettings.fromFirestore', () {
    test('should parse all fields', () {
      final data = {
        'ratioBase': 1.5,
        'ratioDesayuno': 2.0,
        'factorCorreccion': 40.0,
        'glucosaObjetivo': 110.0,
        'supportsHalfUnits': false,
        'roundBolusDown': true,
        'usesMmolL': true,
      };

      final settings = InsulinSettings.fromFirestore(data);

      expect(settings.ratioBase, 1.5);
      expect(settings.ratioDesayuno, 2.0);
      expect(settings.factorCorreccion, 40.0);
      expect(settings.glucosaObjetivo, 110.0);
      expect(settings.supportsHalfUnits, false);
      expect(settings.roundBolusDown, true);
      expect(settings.usesMmolL, true);
    });

    test('should handle missing optional fields', () {
      final data = {
        'ratioBase': 1.0,
        'factorCorreccion': 50.0,
        'glucosaObjetivo': 100.0,
      };

      final settings = InsulinSettings.fromFirestore(data);

      expect(settings.ratioDesayuno, isNull);
      expect(settings.ratioMediaManana, isNull);
      expect(settings.supportsHalfUnits, true);
      expect(settings.roundBolusDown, false);
      expect(settings.usesMmolL, false);
    });
  });

  group('InsulinSettings.copyWith', () {
    const settings = InsulinSettings(
      ratioBase: 1.0,
      ratioDesayuno: 1.5,
      factorCorreccion: 50.0,
      glucosaObjetivo: 100.0,
    );

    test('should keep values when no changes', () {
      final copy = settings.copyWith();

      expect(copy.ratioBase, settings.ratioBase);
      expect(copy.ratioDesayuno, settings.ratioDesayuno);
    });

    test('should clear meal ratio when clearFlag is true', () {
      final copy = settings.copyWith(clearRatioDesayuno: true);

      expect(copy.ratioDesayuno, isNull);
      expect(copy.ratioBase, settings.ratioBase);
    });
  });
}
