import 'package:flutter/material.dart';
import '../core/extensions/context_extensions.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../models/food.dart';
import '../l10n/app_localizations.dart';

class FoodListItem extends StatelessWidget {
  final Food food;
  final VoidCallback? onTap;
  final Widget? trailing;

  const FoodListItem({
    super.key,
    required this.food,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDarkMode;

    return Card(
      margin: AppDimens.cardMargin,
      elevation: 1,
      shape: RoundedRectangleBorder(
        side: food.isFavorite
            ? BorderSide(color: Colors.amber.shade400, width: 2)
            : (isDark
                ? BorderSide(color: Colors.grey.shade800)
                : BorderSide.none),
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      child: ListTile(
        contentPadding: AppDimens.listTileContent,
        leading: CircleAvatar(
          backgroundColor: food.isFavorite
              ? Colors.amber.withValues(alpha: 0.2)
              : Colors.teal.withValues(alpha: 0.1),
          child: Icon(
            food.isFavorite ? Icons.star : Icons.restaurant,
            semanticLabel: food.isFavorite
                ? l10n.foodsFavoriteAccessibility
                : l10n.foodsFoodAccessibility,
            color: food.isFavorite
                ? Colors.amber.shade600
                : Colors.teal.shade600,
          ),
        ),
        title: Text(
          food.displayName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: food.isFavorite
                ? AppColors.accentFavorite(context)
                : AppColors.textHeading(context),
          ),
        ),
        subtitle: Text(
          l10n.calcCarbsPer100g('${food.carbsPer100g}'),
          style: TextStyle(color: AppColors.textMuted(context)),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
