import 'package:flutter_test/flutter_test.dart';
import 'package:libretadulce/services/calculation_service.dart';
import 'package:libretadulce/models/insulin_settings.dart';
import 'package:libretadulce/models/meal_type.dart';

void main() {
  group('CalculationService', () {
    // ── carbsFromGrams ──
    group('carbsFromGrams', () {
      test('standard case', () {
        // carbs = (carbsPer100g / 100) × grams
        // (50 / 100) × 200 = 100
        expect(CalculationService.carbsFromGrams(50, 200), 100.0);
      });

      test('zero grams returns zero', () {
        expect(CalculationService.carbsFromGrams(50, 0), 0.0);
      });

      test('zero carbsPer100g returns zero', () {
        expect(CalculationService.carbsFromGrams(0, 200), 0.0);
      });
    });

    // ── rationsFromCarbs ──
    group('rationsFromCarbs', () {
      test('standard case', () {
        // rations = carbs / 10
        expect(CalculationService.rationsFromCarbs(100), 10.0);
      });

      test('zero carbs returns zero', () {
        expect(CalculationService.rationsFromCarbs(0), 0.0);
      });
    });

    // ── carbsFromRations ──
    group('carbsFromRations', () {
      test('round-trip inverse of rationsFromCarbs', () {
        const originalCarbs = 75.0;
        final rations = CalculationService.rationsFromCarbs(originalCarbs);
        final backToCarbs = CalculationService.carbsFromRations(rations);
        expect(backToCarbs, originalCarbs);
      });

      test('standard case', () {
        // carbs = rations × 10
        expect(CalculationService.carbsFromRations(3.5), 35.0);
      });
    });

    // ── gramsFromCarbs ──
    group('gramsFromCarbs', () {
      test('standard case', () {
        // grams = (targetCarbs × 100) / carbsPer100g
        // (50 × 100) / 25 = 200
        expect(CalculationService.gramsFromCarbs(50, 25), 200.0);
      });

      test('guard when carbsPer100g == 0 returns 0', () {
        expect(CalculationService.gramsFromCarbs(50, 0), 0.0);
      });

      test('guard when carbsPer100g < 0 returns 0', () {
        expect(CalculationService.gramsFromCarbs(50, -5), 0.0);
      });
    });

    // ── macroFromGrams ──
    group('macroFromGrams', () {
      test('standard case', () {
        // total = (per100g / 100) × grams
        // (10 / 100) × 300 = 30
        expect(CalculationService.macroFromGrams(10, 300), 30.0);
      });
    });

    // ── calculateTotalBolus ──
    group('calculateTotalBolus', () {
      final settings = const InsulinSettings(
        ratioBase: 10,
        factorCorreccion: 50,
        glucosaObjetivo: 100,
        supportsHalfUnits: true,
      );

      test('with glucose correction', () {
        // mealBolus: (carbs / 10) × ratio
        //   rations = 60 / 10 = 6
        //   mealBolus = 6 × 10 = 60
        // correction: (180 - 100) / 50 = 1.6
        // total = 60 + 1.6 = 61.6
        // rounded (half unit) = 61.5
        final result = CalculationService.calculateTotalBolus(
          settings: settings,
          totalCarbs: 60,
          mealType: MealType.almuerzo,
          glucose: 180,
        );
        expect(result, 61.5);
      });

      test('without glucose correction', () {
        // mealBolus: (60 / 10) × 10 = 60, rounded = 60
        final result = CalculationService.calculateTotalBolus(
          settings: settings,
          totalCarbs: 60,
          mealType: MealType.almuerzo,
          glucose: 0,
        );
        expect(result, 60.0);
      });

      test('returns null when totalCarbs <= 0', () {
        final result = CalculationService.calculateTotalBolus(
          settings: settings,
          totalCarbs: 0,
          mealType: MealType.almuerzo,
        );
        expect(result, isNull);
      });

      test('returns null when totalCarbs is negative', () {
        final result = CalculationService.calculateTotalBolus(
          settings: settings,
          totalCarbs: -10,
          mealType: MealType.almuerzo,
        );
        expect(result, isNull);
      });
    });

    // ── sumMealItems ──
    group('sumMealItems', () {
      test('sums a numeric field across items', () {
        final items = [
          {'carbs': 25.0, 'name': 'Rice'},
          {'carbs': 15.0, 'name': 'Chicken'},
          {'carbs': 10.0, 'name': 'Salad'},
        ];
        expect(CalculationService.sumMealItems(items, 'carbs'), 50.0);
      });

      test('handles missing fields as 0', () {
        final items = [
          {'name': 'Rice'},
          {'carbs': 15.0},
        ];
        expect(CalculationService.sumMealItems(items, 'carbs'), 15.0);
      });
    });
  });
}
