import '../../models/meal_type.dart';

String mealTypeLocalizedLabel(MealType mealType, dynamic l10n) {
  switch (mealType) {
    case MealType.desayuno:
      return l10n.mealTypeBreakfast;
    case MealType.mediaManana:
      return l10n.mealTypeMidMorning;
    case MealType.almuerzo:
      return l10n.mealTypeLunch;
    case MealType.merienda:
      return l10n.mealTypeAfternoonSnack;
    case MealType.cena:
      return l10n.mealTypeDinner;
    case MealType.snack:
      return l10n.mealTypeSnack;
  }
}
