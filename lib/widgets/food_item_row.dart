import 'package:flutter/material.dart';
import '../core/extensions/context_extensions.dart';
import '../core/theme/app_dimens.dart';
import '../l10n/app_localizations.dart';
import 'confirm_delete_dialog.dart';

/// A dismissible list tile that shows one food item in the calculator plate.
class FoodItemRow extends StatelessWidget {
  final String itemId;
  final String foodName;
  final double grams;
  final double carbs;
  final double rations;
  final double? fats;
  final double? proteins;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const FoodItemRow({
    super.key,
    required this.itemId,
    required this.foodName,
    required this.grams,
    required this.carbs,
    required this.rations,
    this.fats,
    this.proteins,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDarkMode;

    return Dismissible(
      key: ValueKey(itemId),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {
        DismissDirection.endToStart: 0.2,
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const ExcludeSemantics(
          child: Icon(Icons.delete, color: Colors.white, size: 28),
        ),
      ),
      confirmDismiss: (direction) => showConfirmDeleteDialog(
        context,
        title: l10n.calcDeleteFromPlate,
        content: l10n.historyDeleteConfirm,
      ),
      onDismissed: (direction) => onDelete(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 4, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: name + rations + delete
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        foodName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.calcRacShort(rations.toStringAsFixed(1)),
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                      tooltip: l10n.calcDeleteFromPlate,
                      visualDensity: VisualDensity.compact,
                      onPressed: onDelete,
                    ),
                  ],
                ),
                // Row 2: grams
                Padding(
                  padding: const EdgeInsets.only(left: 28, top: 2),
                  child: Text(
                    l10n.calcGramsConsumed(grams.toStringAsFixed(0)),
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Row 3: macro chips
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _macroPill(
                        l10n.calcHC(carbs.toStringAsFixed(1)),
                        Colors.teal,
                        isDark,
                      ),
                      if (fats != null && fats! > 0)
                        _macroPill(
                          l10n.calcFats(fats!.toStringAsFixed(1)),
                          Colors.orange,
                          isDark,
                        ),
                      if (proteins != null && proteins! > 0)
                        _macroPill(
                          l10n.calcProteins(proteins!.toStringAsFixed(1)),
                          Colors.blue,
                          isDark,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _macroPill(String text, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }
}
