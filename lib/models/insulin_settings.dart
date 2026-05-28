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
      ratioBase: (data['ratioBase'] as num).toDouble(),
      ratioDesayuno: data['ratioDesayuno'] != null
          ? (data['ratioDesayuno'] as num).toDouble()
          : null,
      ratioMediaManana: data['ratioMediaManana'] != null
          ? (data['ratioMediaManana'] as num).toDouble()
          : null,
      ratioAlmuerzo: data['ratioAlmuerzo'] != null
          ? (data['ratioAlmuerzo'] as num).toDouble()
          : null,
      ratioMerienda: data['ratioMerienda'] != null
          ? (data['ratioMerienda'] as num).toDouble()
          : null,
      ratioCena: data['ratioCena'] != null
          ? (data['ratioCena'] as num).toDouble()
          : null,
      ratioSnack: data['ratioSnack'] != null
          ? (data['ratioSnack'] as num).toDouble()
          : null,
      factorCorreccion: (data['factorCorreccion'] as num).toDouble(),
      glucosaObjetivo: (data['glucosaObjetivo'] as num).toDouble(),
      supportsHalfUnits: data['supportsHalfUnits'] ?? true,
      roundBolusDown: data['roundBolusDown'] ?? false,
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
    );
  }
}
