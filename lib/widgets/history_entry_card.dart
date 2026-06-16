import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/extensions/context_extensions.dart';
import '../core/theme/app_dimens.dart';
import '../core/utils/meal_type_localizer.dart';
import '../l10n/app_localizations.dart';
import '../models/food.dart';

/// Card for a single MealEntry in the history list.
/// Renders: meal type chip, timestamp, items list, totals row,
/// bolus badge, glucose badge (both optional).
class HistoryEntryCard extends StatelessWidget {
  final MealEntry entry;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const HistoryEntryCard({
    super.key,
    required this.entry,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDarkMode;
    final date = entry.timestamp;
    final items = entry.items;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusDialog),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: meal type + time + actions ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ExcludeSemantics(
                        child: Icon(entry.mealType.icon, color: Colors.teal),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          mealTypeLocalizedLabel(entry.mealType, l10n)
                              .toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.teal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      DateFormat('HH:mm').format(date),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    if (onEdit != null) ...[
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.teal,
                          size: 20,
                        ),
                        tooltip: l10n.historyEditButton,
                        onPressed: onEdit,
                      ),
                    ],
                    if (onDelete != null) ...[
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        tooltip: l10n.historyDeleteTooltip(
                          mealTypeLocalizedLabel(entry.mealType, l10n),
                        ),
                        onPressed: onDelete,
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const Divider(),

            // ── Items list ──
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.historyGramsFood(
                          item.grams.toStringAsFixed(0),
                          item.name,
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Text(
                      l10n.historyRacShort(item.raciones.toStringAsFixed(1)),
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ── Totals row ──
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.teal.withValues(alpha: 0.1)
                    : Colors.teal.shade50,
                borderRadius: BorderRadius.circular(AppDimens.radiusInput),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      l10n.historySubtotal,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.historyRationsCarbs(
                      entry.totalRations.toStringAsFixed(1),
                      entry.totalCarbs.toStringAsFixed(0),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),

            // ── Fats (optional) ──
            if (entry.totalFats != null && entry.totalFats! > 0) ...[
              const SizedBox(height: 8),
              _macroBadge(
                context,
                icon: Icons.opacity,
                color: Colors.orange,
                label: l10n.historyTotalFats,
                value: '${entry.totalFats!.toStringAsFixed(1)}g',
              ),
            ],

            // ── Proteins (optional) ──
            if (entry.totalProteins != null && entry.totalProteins! > 0) ...[
              const SizedBox(height: 8),
              _macroBadge(
                context,
                icon: Icons.fitness_center,
                color: Colors.blue,
                label: l10n.historyTotalProteins,
                value: '${entry.totalProteins!.toStringAsFixed(1)}g',
              ),
            ],

            // ── Glucose badge (optional) ──
            if (entry.glucose != null) ...[
              const SizedBox(height: 8),
              _macroBadge(
                context,
                icon: Icons.monitor_heart,
                color: Colors.redAccent,
                label: l10n.calcGlucoseLabel,
                value: '${entry.glucose!.toStringAsFixed(0)} mg/dL',
              ),
            ],

            // ── Bolus badge (optional) ──
            if (entry.totalBolus != null) ...[
              const SizedBox(height: 8),
              _macroBadge(
                context,
                icon: Icons.water_drop,
                color: Colors.orange,
                label: l10n.historyBolus,
                value: entry.totalBolus! == entry.totalBolus!.roundToDouble()
                    ? l10n.historyBolusUnits(entry.totalBolus!.round().toString())
                    : l10n.historyBolusUnits(entry.totalBolus!.toStringAsFixed(1)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Widget _macroBadge(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    final isDark = context.isDarkMode;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark
            ? color.withValues(alpha: 0.1)
            : color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimens.radiusInput),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                ExcludeSemantics(child: Icon(icon, size: 14, color: color)),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
