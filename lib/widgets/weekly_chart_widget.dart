import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/extensions/context_extensions.dart';
import '../core/theme/app_colors.dart';
import '../models/food.dart';
import '../core/theme/app_text_styles.dart';
import '../l10n/app_localizations.dart';
import '../services/meal_history_service.dart';

/// Weekly carbohydrate chart for the history page.
class WeeklyChartWidget extends StatelessWidget {
  final String uid;

  const WeeklyChartWidget({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDarkMode;
    final now = DateTime.now();
    final nowDay = DateTime(now.year, now.month, now.day);
    final startOfWeek = nowDay.subtract(const Duration(days: 6));
    final endOfWeek = nowDay.add(const Duration(days: 1));

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
              const ExcludeSemantics(child: Icon(Icons.bar_chart, size: 64, color: Colors.grey)),
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
            Text(l10n.historyLast7Days, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700)),
            const SizedBox(height: 4),
            _buildGlucoseLegend(l10n, isDark),
            const SizedBox(height: 12),
            Expanded(
              child: Semantics(
                label: _buildChartSemanticsLabel(entries, l10n),
                child: BarChart(BarChartData(
                  maxY: maxTotal, minY: 0, alignment: BarChartAlignment.spaceAround,
                  barGroups: entries.asMap().entries.map((e) => BarChartGroupData(x: e.key, barRods: [
                    BarChartRodData(toY: e.value.value, color: AppColors.primary(context), width: 22, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      backDrawRodData: BackgroundBarChartRodData(show: true, toY: maxTotal, color: Colors.grey.withValues(alpha: 0.08))),
                  ])).toList(),
                  gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: interval,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.15), strokeWidth: 1)),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 42, interval: interval,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.max) return const ExcludeSemantics(child: SizedBox.shrink());
                        return Padding(padding: const EdgeInsets.only(right: 6), child: Text('${value.toInt()}g',
                          style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey)));
                      })),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= days.length) return const SizedBox.shrink();
                        return Padding(padding: const EdgeInsets.only(top: 6), child: Text(_weekdayLabel(days[idx]),
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.grey.shade300 : Colors.grey.shade600)));
                      })),
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(enabled: true,
                    touchTooltipData: BarTouchTooltipData(getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final dayKey = entries[group.x].key;
                      final glucoses = glucosesByDay[dayKey] ?? [];
                      final avgGlucose = glucoses.isNotEmpty ? glucoses.reduce((a, b) => a + b) / glucoses.length : null;
                      String tip = 'HC: ${rod.toY.toStringAsFixed(0)}g';
                      if (avgGlucose != null) tip += '\nGlu: ${avgGlucose.toStringAsFixed(0)} mg/dL';
                      return BarTooltipItem(tip, const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12));
                    })),
                )),
              ),
            ),
            const SizedBox(height: 8),
            Padding(padding: const EdgeInsets.only(left: 42), child: Row(children: List.generate(entries.length, (i) {
              final glucoses = glucosesByDay[entries[i].key] ?? [];
              final avgGlucose = glucoses.isNotEmpty ? glucoses.reduce((a, b) => a + b) / glucoses.length : null;
              return Expanded(child: Column(children: [
                if (avgGlucose != null) Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: _glucoseColor(avgGlucose),
                  border: Border.all(color: Colors.white, width: 1.5), boxShadow: [BoxShadow(color: _glucoseColor(avgGlucose).withValues(alpha: 0.3), blurRadius: 3, spreadRadius: 0.5)])),
                const SizedBox(height: 2),
                if (avgGlucose != null) Text(avgGlucose.toStringAsFixed(0), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: _glucoseColor(avgGlucose)))
                else const Text('–', style: TextStyle(fontSize: 9, color: Colors.grey)),
              ]));
            }))),
            const SizedBox(height: 12),
          ]),
        );
      },
    );
  }

  Color _glucoseColor(double mgdl) {
    if (mgdl < 70) return Colors.amber;
    if (mgdl > 180) return Colors.redAccent;
    return Colors.green;
  }

  Widget _buildGlucoseLegend(AppLocalizations l10n, bool isDark) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _legendDot(Colors.green, l10n.historyGlucoseInRange, isDark), const SizedBox(width: 12),
      _legendDot(Colors.redAccent, l10n.historyGlucoseHigh, isDark), const SizedBox(width: 12),
      _legendDot(Colors.amber, l10n.historyGlucoseLow, isDark),
    ]);
  }

  Widget _legendDot(Color color, String label, bool isDark) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 10, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
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
