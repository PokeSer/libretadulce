import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libretadulce/models/food.dart';
import 'package:libretadulce/models/insulin_settings.dart';

/// Builds the raw Firestore map for a meal entry with a given stored glucose.
Map<String, dynamic> _rawEntry(double? glucose) => {
      'timestamp': Timestamp.fromDate(DateTime(2026, 1, 1, 12)),
      'mealType': 'almuerzo',
      'totalCarbs': 60.0,
      'totalRations': 6.0,
      'items': const [],
      'glucose': ?glucose,
    };

void main() {
  group('MealEntry glucose storage coherence', () {
    const factor = InsulinSettings.mmolConversionFactor; // 18.018

    test('preserves a plausible mg/dL glucose value untouched', () {
      final entry = MealEntry.fromFirestore('id', _rawEntry(120.0));
      expect(entry.glucose, 120.0);
    });

    test('leaves a null glucose as null', () {
      final entry = MealEntry.fromFirestore('id', _rawEntry(null));
      expect(entry.glucose, isNull);
    });

    test('repairs a legacy-corrupted glucose (stored as mmol ÷ factor)', () {
      // A user on mmol/L entered 6.0; the old bug stored 6.0 / 18.018 ≈ 0.333.
      final corrupted = 6.0 / factor;
      final entry = MealEntry.fromFirestore('id', _rawEntry(corrupted));

      // The repaired value must be the correct mg/dL magnitude: 6.0 × 18.018.
      expect(entry.glucose, closeTo(6.0 * factor, 0.001));
    });

    test('does not touch the lowest clinically plausible mg/dL readings', () {
      // Severe hypoglycemia (~40 mg/dL) must never be mistaken for corruption.
      final entry = MealEntry.fromFirestore('id', _rawEntry(40.0));
      expect(entry.glucose, 40.0);
    });
  });

  group('InsulinSettings glucose storage round-trip', () {
    test('mmol/L input persists as mg/dL and reads back as mmol/L', () {
      const settings = InsulinSettings(
        ratioBase: 10,
        factorCorreccion: 50,
        glucosaObjetivo: 100,
        usesMmolL: true,
      );

      const displayMmol = 7.2;
      final stored = settings.toStoredGlucoseUnit(displayMmol);

      // Stored value is canonical mg/dL (7.2 × 18.018 ≈ 129.7).
      expect(stored, closeTo(7.2 * InsulinSettings.mmolConversionFactor, 0.001));
      // And reading it back yields the original mmol/L display value.
      expect(settings.fromStoredGlucoseUnit(stored), closeTo(displayMmol, 0.001));
    });

    test('mg/dL user stores and reads identical values', () {
      const settings = InsulinSettings(
        ratioBase: 10,
        factorCorreccion: 50,
        glucosaObjetivo: 100,
        usesMmolL: false,
      );

      expect(settings.toStoredGlucoseUnit(130.0), 130.0);
      expect(settings.fromStoredGlucoseUnit(130.0), 130.0);
    });
  });
}
