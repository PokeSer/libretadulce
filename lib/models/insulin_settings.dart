import '../models/meal_type.dart';

class InsulinSettings {
  final double ratioBase;
  final double? ratioDesayuno;
  final double? ratioMediaManana;
  final double? ratioAlmuerzo;
  final double? ratioMerienda;
  final double? ratioCena;
  final double? ratioSnack;
  final double factorCorreccion;
  final double glucosaObjetivo;
  final bool supportsHalfUnits;
  final bool roundBolusDown;
  final bool usesMmolL;

  /// mg/dL per mmol/L. Single source of truth for glucose unit conversion.
  static const double mmolConversionFactor = 18.018;

  const InsulinSettings({
    required this.ratioBase,
    this.ratioDesayuno,
    this.ratioMediaManana,
    this.ratioAlmuerzo,
    this.ratioMerienda,
    this.ratioCena,
    this.ratioSnack,
    required this.factorCorreccion,
    required this.glucosaObjetivo,
    this.supportsHalfUnits = true,
    this.roundBolusDown = false,
    this.usesMmolL = false,
  });

  double getMealRatio(MealType? mealType) {
    switch (mealType) {
      case MealType.desayuno:
        return ratioDesayuno ?? ratioBase;
      case MealType.mediaManana:
        return ratioMediaManana ?? ratioBase;
      case MealType.almuerzo:
        return ratioAlmuerzo ?? ratioBase;
      case MealType.merienda:
        return ratioMerienda ?? ratioBase;
      case MealType.cena:
        return ratioCena ?? ratioBase;
      case MealType.snack:
        return ratioSnack ?? ratioBase;
      default:
        return ratioBase;
    }
  }

  double calculateMealBolus(double carbs, {MealType? mealType}) {
    final raciones = carbs / 10;
    return raciones * getMealRatio(mealType);
  }

  double calculateCorrection(double glucosaActual) {
    if (glucosaActual <= glucosaObjetivo) return 0;
    return (glucosaActual - glucosaObjetivo) / factorCorreccion;
  }

  /// Converts a glucose [value] expressed in mg/dL to the user's display unit
  /// (mg/dL → mmol/L when [usesMmolL] is true; identity otherwise).
  double toMmol(double value) => usesMmolL ? value / mmolConversionFactor : value;

  /// Converts a glucose [value] expressed in the user's display unit to mg/dL
  /// (mmol/L → mg/dL when [usesMmolL] is true; identity otherwise).
  double toMgdl(double value) => usesMmolL ? value * mmolConversionFactor : value;

  /// Converts a glucose value entered by the user (in their display unit) into
  /// the canonical unit persisted in Firestore, which is **always mg/dL**.
  ///
  /// This is the inverse of [fromStoredGlucoseUnit].
  double toStoredGlucoseUnit(double displayValue) => toMgdl(displayValue);

  /// Converts a glucose value read from Firestore (canonical **mg/dL**) back
  /// into the user's display unit for presentation and editing.
  ///
  /// This is the inverse of [toStoredGlucoseUnit].
  double fromStoredGlucoseUnit(double storedMgdl) => toMmol(storedMgdl);

  String glucoseLabel() => usesMmolL ? 'mmol/L' : 'mg/dL';

  String formatGlucose(double value) {
    return usesMmolL ? value.toStringAsFixed(1) : value.toStringAsFixed(0);
  }

  double roundBolus(double units) {
    if (roundBolusDown) {
      if (supportsHalfUnits) {
        return (units * 2).floorToDouble() / 2;
      }
      return units.floorToDouble();
    }
    if (supportsHalfUnits) {
      return (units * 2).roundToDouble() / 2;
    }
    return units.roundToDouble();
  }

  String formatBolus(double units) {
    final rounded = roundBolus(units);
    return rounded.toStringAsFixed(supportsHalfUnits ? 1 : 0);
  }

  factory InsulinSettings.fromFirestore(Map<String, dynamic> data) {
    return InsulinSettings(
      ratioBase: (data['ratioBase'] as num?)?.toDouble() ?? 10.0,
      ratioDesayuno: (data['ratioDesayuno'] as num?)?.toDouble(),
      ratioMediaManana: (data['ratioMediaManana'] as num?)?.toDouble(),
      ratioAlmuerzo: (data['ratioAlmuerzo'] as num?)?.toDouble(),
      ratioMerienda: (data['ratioMerienda'] as num?)?.toDouble(),
      ratioCena: (data['ratioCena'] as num?)?.toDouble(),
      ratioSnack: (data['ratioSnack'] as num?)?.toDouble(),
      factorCorreccion: (data['factorCorreccion'] as num?)?.toDouble() ?? 50.0,
      glucosaObjetivo: (data['glucosaObjetivo'] as num?)?.toDouble() ?? 100.0,
      supportsHalfUnits: data['supportsHalfUnits'] ?? true,
      roundBolusDown: data['roundBolusDown'] ?? false,
      usesMmolL: data['usesMmolL'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ratioBase': ratioBase,
      if (ratioDesayuno != null) 'ratioDesayuno': ratioDesayuno,
      if (ratioMediaManana != null) 'ratioMediaManana': ratioMediaManana,
      if (ratioAlmuerzo != null) 'ratioAlmuerzo': ratioAlmuerzo,
      if (ratioMerienda != null) 'ratioMerienda': ratioMerienda,
      if (ratioCena != null) 'ratioCena': ratioCena,
      if (ratioSnack != null) 'ratioSnack': ratioSnack,
      'factorCorreccion': factorCorreccion,
      'glucosaObjetivo': glucosaObjetivo,
      'supportsHalfUnits': supportsHalfUnits,
      'roundBolusDown': roundBolusDown,
      'usesMmolL': usesMmolL,
    };
  }

  InsulinSettings copyWith({
    double? ratioBase,
    double? ratioDesayuno,
    bool clearRatioDesayuno = false,
    double? ratioMediaManana,
    bool clearRatioMediaManana = false,
    double? ratioAlmuerzo,
    bool clearRatioAlmuerzo = false,
    double? ratioMerienda,
    bool clearRatioMerienda = false,
    double? ratioCena,
    bool clearRatioCena = false,
    double? ratioSnack,
    bool clearRatioSnack = false,
    double? factorCorreccion,
    double? glucosaObjetivo,
    bool? supportsHalfUnits,
    bool? roundBolusDown,
    bool? usesMmolL,
  }) {
    return InsulinSettings(
      ratioBase: ratioBase ?? this.ratioBase,
      ratioDesayuno:
          clearRatioDesayuno ? null : (ratioDesayuno ?? this.ratioDesayuno),
      ratioMediaManana: clearRatioMediaManana
          ? null
          : (ratioMediaManana ?? this.ratioMediaManana),
      ratioAlmuerzo:
          clearRatioAlmuerzo ? null : (ratioAlmuerzo ?? this.ratioAlmuerzo),
      ratioMerienda:
          clearRatioMerienda ? null : (ratioMerienda ?? this.ratioMerienda),
      ratioCena: clearRatioCena ? null : (ratioCena ?? this.ratioCena),
      ratioSnack: clearRatioSnack ? null : (ratioSnack ?? this.ratioSnack),
      factorCorreccion: factorCorreccion ?? this.factorCorreccion,
      glucosaObjetivo: glucosaObjetivo ?? this.glucosaObjetivo,
      supportsHalfUnits: supportsHalfUnits ?? this.supportsHalfUnits,
      roundBolusDown: roundBolusDown ?? this.roundBolusDown,
      usesMmolL: usesMmolL ?? this.usesMmolL,
    );
  }
}
