import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../l10n/app_localizations.dart';

/// Displays the currently selected food with its name and carbs/100g info.
class CalculatorSelectedFoodInfo extends StatelessWidget {
  final String foodName;
  final double carbsPer100g;

  const CalculatorSelectedFoodInfo({
    super.key,
    required this.foodName,
    required this.carbsPer100g,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary(context).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: AppColors.primary(context).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeading(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.calcCarbsPer100g(carbsPer100g.toString()),
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
