import 'package:flutter/material.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(
        side: food.isFavorite
            ? BorderSide(color: Colors.amber.shade400, width: 2)
            : (isDark
                ? BorderSide(color: Colors.grey.shade800)
                : BorderSide.none),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                ? (isDark ? Colors.amber.shade200 : Colors.brown.shade800)
                : (isDark ? Colors.white : Colors.teal.shade900),
          ),
        ),
        subtitle: Text(
          l10n.calcCarbsPer100g('${food.carbsPer100g}'),
          style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
