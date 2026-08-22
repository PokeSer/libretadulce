import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/extensions/context_extensions.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../models/food.dart';
import '../models/insulin_settings.dart';
import '../l10n/app_localizations.dart';
import '../services/meal_history_service.dart';

/// Weekly carbohydrate landscape for the history page.
///
/// The bar axis is carbs; glucose rides underneath as range-coded nodes.
/// Color always means something measurable.
class WeeklyChartWidget extends StatelessWidget {
  final String uid;
  final InsulinSettings? settings;

  const WeeklyChartWidget({super.key, required this.uid, this.settings});

  /// Formats a glucose value (stored in mg/dL) into the user's display unit.
  String _displayGlucose(double mgdl) => settings != null
      ? settings!.formatGlucose(settings!.fromStoredGlucoseUnit(mgdl))
      : mgdl.toStringAsFixed(0);

  String _glucoseUnit() => settings?.glucoseLabel() ?? 'mg/dL';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDarkMode;
    final now = DateTime.now();
    final nowDay = DateTime(now.year, now.month, now.day);
    final startOfWeek = nowDay.subtract(const Duration(days: 6));
    final endOfWeek = nowDay.add(const Duration(days: 1));
    final scheme = Theme.of(context).colorScheme;

    return StreamBuilder<List<MealEntry>>(
      stream: MealHistoryService.watchRange(uid, startOfWeek, endOfWeek),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Semantics(label: l10n.historyLoading, child: const CircularProgressIndicator()),
          );
        }
        final mealEntries = snapshot.data ?? [];
        final days = List.generate(7, (i) => nowDay.subtract(Duration(days: 6 - i)));
        final Map<String, double> carbsByDay = {};
        final Map<String, List<double>> glucosesByDay = {};
        for (final d in days) {
          final key = DateFormat('dd/MM').format(d);
          carbsByDay[key] = 0;
          glucosesByDay[key] = [];
        }
        for (final entry in mealEntries) {
          final dayKey = DateFormat('dd/MM').format(DateTime(entry.timestamp.year, entry.timestamp.month, entry.timestamp.day));
          if (carbsByDay.containsKey(dayKey)) carbsByDay[dayKey] = (carbsByDay[dayKey] ?? 0) + entry.totalCarbs;
          if (entry.glucose != null && glucosesByDay.containsKey(dayKey)) glucosesByDay[dayKey]!.add(entry.glucose!);
        }
        final entries = carbsByDay.entries.toList();
        if (entries.every((e) => e.value == 0)) {
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ExcludeSemantics(child: Icon(Icons.show_chart_rounded, size: 64, color: AppColors.hintColor(context))),
              const SizedBox(height: 16),
              Text(l10n.historyNoData7Days, style: AppTextStyles.bodyText(context)),
            ]),
          );
        }
        double maxTotal = 0;
        for (final e in entries) { if (e.value > maxTotal) maxTotal = e.value; }
        maxTotal = (maxTotal > 0) ? maxTotal : 50;
        final double interval = (maxTotal / 4).ceilToDouble().clamp(1, double.infinity).toDouble();
        maxTotal = interval * 4;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              l10n.historyLast7Days.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            _buildGlucoseLegend(l10n, context),
            const SizedBox(height: 12),
            Expanded(
              child: Semantics(
                label: _buildChartSemanticsLabel(entries, l10n),
                child: BarChart(BarChartData(
                  maxY: maxTotal, minY: 0, alignment: BarChartAlignment.spaceAround,
                  barGroups: entries.asMap().entries.map((e) {
                    final day = days[e.key];
                    final isToday = day.year == now.year && day.month == now.month && day.day == now.day;
                    return BarChartGroupData(x: e.key, barRods: [
                      BarChartRodData(
                        toY: e.value.value,
                        color: e.value.value == 0
                            ? scheme.surfaceContainerHighest
                            : isToday
                                ? AppColors.curveStroke(context)
                                : scheme.primary.withValues(alpha: isDark ? 0.45 : 0.30),
                        width: 22,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxTotal,
                          color: scheme.surfaceContainerHighest.withValues(alpha: isDark ? 0.35 : 0.5),
                        ),
                      ),
                    ]);
                  }).toList(),
                  gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: interval,
                    getDrawingHorizontalLine: (value) => FlLine(color: scheme.outlineVariant, strokeWidth: 1)),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 44, interval: interval,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.max) return const ExcludeSemantics(child: SizedBox.shrink());
                        return Padding(padding: const EdgeInsets.only(right: 8), child: Text('${value.toInt()}g',
                          style: AppTextStyles.metric(context, color: scheme.onSurfaceVariant, size: 11)));
                      })),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= days.length) return const SizedBox.shrink();
                        final isToday = days[idx].year == now.year && days[idx].month == now.month && days[idx].day == now.day;
                        return Padding(padding: const EdgeInsets.only(top: 6), child: Text(_weekdayLabel(days[idx]).toUpperCase(),
                          style: TextStyle(fontSize: 10, letterSpacing: 0.8, fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                            color: isToday ? AppColors.curveStroke(context) : scheme.onSurfaceVariant)));
                      })),
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => scheme.inverseSurface,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final dayKey = entries[group.x].key;
                        final glucoses = glucosesByDay[dayKey] ?? [];
                        final avgGlucose = glucoses.isNotEmpty ? glucoses.reduce((a, b) => a + b) / glucoses.length : null;
                        String tip = 'HC ${rod.toY.toStringAsFixed(0)}g';
                        if (avgGlucose != null) tip += ' · ${_displayGlucose(avgGlucose)} ${_glucoseUnit()}';
                        return BarTooltipItem(tip, TextStyle(
                          color: scheme.onInverseSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ));
                      })),
                )),
              ),
            ),
            const SizedBox(height: 8),
            Padding(padding: const EdgeInsets.only(left: 44), child: Row(children: List.generate(entries.length, (i) {
              final glucoses = glucosesByDay[entries[i].key] ?? [];
              final avgGlucose = glucoses.isNotEmpty ? glucoses.reduce((a, b) => a + b) / glucoses.length : null;
              return Expanded(child: Column(children: [
                if (avgGlucose != null) Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.glucoseRange(context, avgGlucose),
                  border: Border.all(color: scheme.surface, width: 1.5))),
                const SizedBox(height: 2),
                if (avgGlucose != null) Text(_displayGlucose(avgGlucose), style: AppTextStyles.metric(context, color: AppColors.glucoseRange(context, avgGlucose), size: 10))
                else Text('–', style: AppTextStyles.metric(context, color: scheme.onSurfaceVariant, size: 10)),
              ]));
            }))),
            const SizedBox(height: 12),
          ]),
        );
      },
    );
  }

  Widget _buildGlucoseLegend(AppLocalizations l10n, BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _legendDot(context, AppColors.glucoseInRange(context), l10n.historyGlucoseInRange), const SizedBox(width: 12),
      _legendDot(context, AppColors.glucoseHigh(context), l10n.historyGlucoseHigh), const SizedBox(width: 12),
      _legendDot(context, AppColors.glucoseLow(context), l10n.historyGlucoseLow),
    ]);
  }

  Widget _legendDot(BuildContext context, Color color, String label) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
    ]);
  }

  String _weekdayLabel(DateTime date) {
    // Use locale-aware abbreviation (2 chars) instead of hardcoded Spanish
    final locale = WidgetsBinding.instance.platformDispatcher.locale.toString();
    final label = DateFormat('EEE', locale).format(date);
    // Trim to 2 chars max for chart readability
    return label.length > 2 ? label.substring(0, 2) : label;
  }

  String _buildChartSemanticsLabel(List<MapEntry<String, double>> entries, AppLocalizations l10n) {
    if (entries.isEmpty) return l10n.historyNoData7Days;
    final parts = entries.map((e) => '${e.key}: ${e.value.toStringAsFixed(1)}g');
    return '${l10n.historyLast7Days}. ${parts.join(', ')}. ${l10n.historyTotalCarbs}';
  }
}
