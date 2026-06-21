import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/meal_type_localizer.dart';
import '../l10n/app_localizations.dart';
import '../models/meal_type.dart';

/// Selector de tipo de comida con ChoiceChips.
/// Reutilizado en calculator_page y history_page (edit dialog).
class MealTypeChipSelector extends StatelessWidget {
  final MealType? selected;
  final ValueChanged<MealType> onChanged;
  final AppLocalizations l10n;

  const MealTypeChipSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.calcMealTypeLabel,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary(context),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: MealType.mealList.map((type) {
            final isSelected = selected == type;
            return Semantics(
              checked: isSelected,
              label: mealTypeLocalizedLabel(type, l10n),
              child: ChoiceChip(
                label: Text(mealTypeLocalizedLabel(type, l10n),
                    style: const TextStyle(fontSize: 12)),
                selected: isSelected,
                selectedColor: AppColors.primary(context).withValues(alpha: 0.3),
                checkmarkColor: AppColors.primary(context),
                visualDensity: VisualDensity.standard,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                onSelected: (_) => onChanged(type),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
