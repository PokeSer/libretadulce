import 'package:flutter/material.dart';
import '../core/extensions/context_extensions.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import '../l10n/app_localizations.dart';
import '../models/food.dart';

/// List tile used exclusively in the global foods section.
/// Different from the personal food tile in [FoodListItem].
class GlobalFoodListTile extends StatelessWidget {
  final Food food;
  final VoidCallback onCopyToPersonal;

  const GlobalFoodListTile({
    super.key,
    required this.food,
    required this.onCopyToPersonal,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: AppDimens.cardMargin,
      shape: RoundedRectangleBorder(
        side: context.isDarkMode
            ? BorderSide(color: AppColors.borderSecondary(context))
            : BorderSide.none,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary(context),
          child: Icon(
            Icons.public,
            color: AppColors.onPrimary(context),
            semanticLabel: l10n.globalGlobalFood,
          ),
        ),
        title: Text(food.displayName, style: AppTextStyles.appBarTitle),
        subtitle: Text(l10n.calcCarbsPer100g('${food.carbsPer100g}')),
        trailing: IconButton(
          icon: Icon(Icons.add_circle, color: AppColors.primary(context)),
          tooltip: l10n.globalCopyToMyFoods,
          onPressed: onCopyToPersonal,
        ),
      ),
    );
  }
}
