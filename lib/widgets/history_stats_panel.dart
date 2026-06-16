import 'package:flutter/material.dart';
import '../core/extensions/context_extensions.dart';
import '../l10n/app_localizations.dart';
import '../models/food.dart';
import 'app_common_widgets.dart';

/// Collapsible stats section for the history page.
/// Shows weekly/daily averages and a summary of the given entries.
class HistoryStatsPanel extends StatelessWidget {
  final List<MealEntry> entries;
  final int selectedRange; // 0 = daily, 1 = weekly

  const HistoryStatsPanel({
    super.key,
    required this.entries,
    required this.selectedRange,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDarkMode;

    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    double totalCarbs = 0;
    double totalRations = 0;
    for (final entry in entries) {
      totalCarbs += entry.totalCarbs;
      totalRations += entry.totalRations;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatCard(
            title: l10n.historyTotalRations,
            value: totalRations.toStringAsFixed(1),
            color: Colors.amber.shade800,
            isDark: isDark,
          ),
          StatCard(
            title: l10n.historyTotalCarbs,
            value: '${totalCarbs.toStringAsFixed(1)}g',
            color: Colors.teal,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}
