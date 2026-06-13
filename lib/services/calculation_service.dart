import '../models/insulin_settings.dart';
import '../models/meal_type.dart';

/// Pure calculation functions for carbohydrate counting and insulin dosing.
/// ALL formulas here are medical logic and must not be changed.
///
/// Extracted from calculator_page.dart and insulin_settings.dart
/// to centralize calculation logic in one place.
class CalculationService {
  CalculationService._();

  // ── Food macro calculations ──────────────────────────────────────

  /// Calculate total carbs from grams of a food.
  /// Formula: carbs = (carbsPer100g / 100) × grams
  static double carbsFromGrams(double carbsPer100g, double grams) {
    return (carbsPer100g / 100) * grams;
  }

  /// Calculate rations from total carbs.
  /// Formula: rations = carbs / 10
  static double rationsFromCarbs(double carbs) {
    return carbs / 10;
  }

  /// Calculate carbs from rations.
  /// Formula: carbs = rations × 10
  static double carbsFromRations(double rations) {
    return rations * 10;
  }

  /// Calculate grams needed to reach a target carb amount.
  /// Formula: grams = (targetCarbs × 100) / carbsPer100g
  static double gramsFromCarbs(double targetCarbs, double carbsPer100g) {
    if (carbsPer100g <= 0) return 0;
    return (targetCarbs * 100) / carbsPer100g;
  }

  /// Calculate total macro (fat/protein) from grams of a food.
  /// Formula: total = (per100g / 100) × grams
  static double macroFromGrams(double per100g, double grams) {
    return (per100g / 100) * grams;
  }

  // ── Meal totals ──────────────────────────────────────────────────

  /// Sum a numeric field across all meal items.
  static double sumMealItems(
    List<Map<String, dynamic>> items,
    String field,
  ) {
    return items.fold(
      0.0,
      (sum, item) => sum + (item[field] as double? ?? 0.0),
    );
  }

  // ── Bolus calculations (delegates to InsulinSettings) ────────────

  /// Calculate total insulin bolus = meal bolus + correction, then rounded.
  /// Returns null if settings are missing.
  static double? calculateTotalBolus({
    required InsulinSettings settings,
    required double totalCarbs,
    required MealType? mealType,
    double glucose = 0,
  }) {
    if (totalCarbs <= 0) return null;

    final mealBolus = settings.calculateMealBolus(
      totalCarbs,
      mealType: mealType,
    );

    double correction = 0;
    if (glucose > 0) {
      correction = settings.calculateCorrection(glucose);
    }

    return settings.roundBolus(mealBolus + correction);
  }
}
