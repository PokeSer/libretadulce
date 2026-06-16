import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../models/food.dart';

/// Horizontal scrollable row of favorite food filter chips for the calculator.
class CalculatorFavoritesRow extends StatelessWidget {
  final List<Food> favorites;
  final String? selectedFoodName;
  final ValueChanged<Food> onFoodSelected;

  const CalculatorFavoritesRow({
    super.key,
    required this.favorites,
    this.selectedFoodName,
    required this.onFoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (favorites.isEmpty) {
      return const ExcludeSemantics(child: SizedBox.shrink());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.calcFavoritesTitle,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary(context),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final food = favorites[index];
              final isSelected = selectedFoodName == food.displayName;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Semantics(
                  checked: isSelected,
                  label: food.displayName,
                  child: FilterChip(
                    label: Text(
                      food.displayName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    visualDensity: VisualDensity.standard,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    onSelected: (_) => onFoodSelected(food),
                    backgroundColor: AppColors.surfaceAlt(context),
                    selectedColor: Colors.teal.withValues(alpha: 0.25),
                    checkmarkColor: Colors.teal,
                    side: BorderSide(
                      color: isSelected ? Colors.teal : Colors.transparent,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
