import 'package:flutter/material.dart';

enum MealType {
  desayuno('Desayuno', 'Desayuno', Icons.free_breakfast),
  mediaManana('Media Manana', 'Media Manana', Icons.local_cafe),
  almuerzo('Almuerzo', 'Almuerzo', Icons.lunch_dining),
  merienda('Merienda', 'Merienda', Icons.local_cafe),
  cena('Cena', 'Cena', Icons.nightlight_round),
  snack('Snack / Otro', 'Snack / Otro', Icons.restaurant);

  const MealType(this.label, this.rawValue, this.icon);
  final String label;
  final String rawValue;
  final IconData icon;

  static MealType fromString(String value) {
    final normalized = value.toLowerCase().trim();
    for (final type in MealType.values) {
      if (type.rawValue.toLowerCase() == normalized ||
          type.label.toLowerCase() == normalized) {
        return type;
      }
    }
    return MealType.snack;
  }

  static List<MealType> get mealList =>
      [desayuno, mediaManana, almuerzo, merienda, cena, snack];
}
