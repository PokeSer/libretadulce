import 'package:flutter_test/flutter_test.dart';
import 'package:libretadulce/models/insulin_settings.dart';
import 'package:libretadulce/models/meal_type.dart';

void main() {
  group('InsulinSettings', () {
    // ── getMealRatio ──
    group('getMealRatio', () {
      const settings = InsulinSettings(
        ratioBase: 10,
        ratioDesayuno: 8,
        ratioCena: 12,
        factorCorreccion: 50,
        glucosaObjetivo: 100,
      );

      test('returns per-meal override when set', () {
        expect(settings.getMealRatio(MealType.desayuno), 8.0);
        expect(settings.getMealRatio(MealType.cena), 12.0);
      });

      test('falls back to ratioBase when override is null', () {
        expect(settings.getMealRatio(MealType.almuerzo), 10.0);
        expect(settings.getMealRatio(MealType.merienda), 10.0);
        expect(settings.getMealRatio(MealType.mediaManana), 10.0);
        expect(settings.getMealRatio(MealType.snack), 10.0);
      });

      test('falls back to ratioBase when mealType is null', () {
        expect(settings.getMealRatio(null), 10.0);
      });
    });

    // ── calculateMealBolus ──
    group('calculateMealBolus', () {
      const settings = InsulinSettings(
        ratioBase: 10,
        factorCorreccion: 50,
        glucosaObjetivo: 100,
      );

      test('verifies formula (carbs / 10) × ratio', () {
        // rations = 45 / 10 = 4.5
        // bolus = 4.5 × 10 = 45
        expect(settings.calculateMealBolus(45), 45.0);
      });

      test('uses meal-specific ratio', () {
        const settingsWithOverride = InsulinSettings(
          ratioBase: 10,
          ratioDesayuno: 8,
          factorCorreccion: 50,
          glucosaObjetivo: 100,
        );
        // rations = 30 / 10 = 3
        // bolus = 3 × 8 = 24
        expect(
          settingsWithOverride.calculateMealBolus(30, mealType: MealType.desayuno),
          24.0,
        );
      });

      test('zero carbs returns zero', () {
        expect(settings.calculateMealBolus(0), 0.0);
      });
    });

    // ── calculateCorrection ──
    group('calculateCorrection', () {
      const settings = InsulinSettings(
        ratioBase: 10,
        factorCorreccion: 50,
        glucosaObjetivo: 100,
      );

      test('returns 0 when glucose <= target', () {
        expect(settings.calculateCorrection(100), 0.0);
        expect(settings.calculateCorrection(80), 0.0);
        expect(settings.calculateCorrection(0), 0.0);
      });

      test('positive when glucose > target', () {
        // (150 - 100) / 50 = 1.0
        expect(settings.calculateCorrection(150), 1.0);
        // (200 - 100) / 50 = 2.0
        expect(settings.calculateCorrection(200), 2.0);
      });
    });

    // ── roundBolus ──
    group('roundBolus', () {
      test('half-unit rounding', () {
        const settings = InsulinSettings(
          ratioBase: 10,
          factorCorreccion: 50,
          glucosaObjetivo: 100,
          supportsHalfUnits: true,
        );
        expect(settings.roundBolus(1.2), 1.0);
        expect(settings.roundBolus(1.3), 1.5);
        expect(settings.roundBolus(1.7), 1.5);
        expect(settings.roundBolus(1.8), 2.0);
        expect(settings.roundBolus(1.25), 1.5);
        expect(settings.roundBolus(1.75), 2.0);
      });

      test('full-unit rounding', () {
        const settings = InsulinSettings(
          ratioBase: 10,
          factorCorreccion: 50,
          glucosaObjetivo: 100,
          supportsHalfUnits: false,
        );
        expect(settings.roundBolus(1.2), 1.0);
        expect(settings.roundBolus(1.6), 2.0);
        expect(settings.roundBolus(1.5), 2.0); // round halves up
      });

      test('roundBolusDown = true with half units', () {
        const settings = InsulinSettings(
          ratioBase: 10,
          factorCorreccion: 50,
          glucosaObjetivo: 100,
          supportsHalfUnits: true,
          roundBolusDown: true,
        );
        expect(settings.roundBolus(1.9), 1.5);
        expect(settings.roundBolus(1.1), 1.0);
        expect(settings.roundBolus(1.5), 1.5);
      });

      test('roundBolusDown = true with full units', () {
        const settings = InsulinSettings(
          ratioBase: 10,
          factorCorreccion: 50,
          glucosaObjetivo: 100,
          supportsHalfUnits: false,
          roundBolusDown: true,
        );
        expect(settings.roundBolus(1.9), 1.0);
        expect(settings.roundBolus(2.0), 2.0);
      });
    });

    // ── mmol/L conversion ──
    group('mmol/L conversion', () {
      test('toMgdl(toMmol(x)) round-trips within 0.01 margin', () {
        const settings = InsulinSettings(
          ratioBase: 10,
          factorCorreccion: 50,
          glucosaObjetivo: 100,
          usesMmolL: true,
        );

        // Test several values
        final testValues = [90.0, 120.0, 180.0, 250.0, 54.0];
        for (final mgdl in testValues) {
          final mmol = settings.toMmol(mgdl);
          final backToMgdl = settings.toMgdl(mmol);
          expect((backToMgdl - mgdl).abs(), lessThan(0.01),
              reason: 'Round-trip failed for $mgdl mg/dL');
        }
      });

      test('toMmol converts correctly', () {
        const settings = InsulinSettings(
          ratioBase: 10,
          factorCorreccion: 50,
          glucosaObjetivo: 100,
          usesMmolL: true,
        );
        // 180 mg/dL / 18.018 ≈ 9.99 mmol/L
        final mmol = settings.toMmol(180);
        expect(mmol, closeTo(9.99, 0.02));
      });

      test('toMgdl converts correctly', () {
        const settings = InsulinSettings(
          ratioBase: 10,
          factorCorreccion: 50,
          glucosaObjetivo: 100,
          usesMmolL: true,
        );
        // 5.5 mmol/L × 18.018 ≈ 99.1 mg/dL
        final mgdl = settings.toMgdl(5.5);
        expect(mgdl, closeTo(99.1, 0.1));
      });

      test('conversion is identity when usesMmolL is false', () {
        const settings = InsulinSettings(
          ratioBase: 10,
          factorCorreccion: 50,
          glucosaObjetivo: 100,
          usesMmolL: false,
        );
        expect(settings.toMmol(180), 180);
        expect(settings.toMgdl(180), 180);
      });
    });

    // ── formatBolus ──
    group('formatBolus', () {
      test('half-unit formatting', () {
        const settings = InsulinSettings(
          ratioBase: 10,
          factorCorreccion: 50,
          glucosaObjetivo: 100,
          supportsHalfUnits: true,
        );
        expect(settings.formatBolus(1.5), '1.5');
        expect(settings.formatBolus(2.0), '2.0');
      });

      test('full-unit formatting', () {
        const settings = InsulinSettings(
          ratioBase: 10,
          factorCorreccion: 50,
          glucosaObjetivo: 100,
          supportsHalfUnits: false,
        );
        expect(settings.formatBolus(1.5), '2');
        expect(settings.formatBolus(2.0), '2');
      });
    });

    // ── fromFirestore / toFirestore roundtrip ──
    group('Firestore serialization', () {
      test('round-trips through fromFirestore and toFirestore', () {
        const original = InsulinSettings(
          ratioBase: 12,
          ratioDesayuno: 8,
          ratioCena: 14,
          factorCorreccion: 40,
          glucosaObjetivo: 110,
          supportsHalfUnits: false,
          roundBolusDown: true,
          usesMmolL: true,
        );

        final data = original.toFirestore();
        final restored = InsulinSettings.fromFirestore(data);

        expect(restored.ratioBase, original.ratioBase);
        expect(restored.ratioDesayuno, original.ratioDesayuno);
        expect(restored.ratioCena, original.ratioCena);
        expect(restored.factorCorreccion, original.factorCorreccion);
        expect(restored.glucosaObjetivo, original.glucosaObjetivo);
        expect(restored.supportsHalfUnits, original.supportsHalfUnits);
        expect(restored.roundBolusDown, original.roundBolusDown);
        expect(restored.usesMmolL, original.usesMmolL);
        // null overrides should remain null
        expect(restored.ratioAlmuerzo, isNull);
        expect(restored.ratioMerienda, isNull);
      });
    });
  });
}
