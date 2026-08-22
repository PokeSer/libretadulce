import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../models/food.dart';
import '../l10n/app_localizations.dart';
import 'food_photo_thumbnail.dart';

class FoodListItem extends StatelessWidget {
  final Food food;
  final String uid;
  final VoidCallback? onTap;
  final Widget? trailing;

  const FoodListItem({
    super.key,
    required this.food,
    required this.uid,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: AppDimens.cardMargin,
      shape: RoundedRectangleBorder(
        side: food.isFavorite
            ? BorderSide(
                color: AppColors.accentFavorite(context).withValues(alpha: 0.6),
                width: 1.5)
            : BorderSide(color: AppColors.hairline(context)),
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        leading: FoodPhotoThumbnail(
          foodId: food.id,
          uid: uid,
          size: 52,
          fallbackIcon: food.isFavorite ? Icons.star : Icons.restaurant,
          fallbackIconColor: food.isFavorite
              ? AppColors.accentFavorite(context)
              : AppColors.primary(context),
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
