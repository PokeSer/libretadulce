import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../core/extensions/context_extensions.dart';
import '../core/utils/meal_type_localizer.dart';
import '../l10n/app_localizations.dart';
import '../models/food.dart';
import '../models/meal_type.dart';
import '../models/insulin_settings.dart';
import '../services/meal_history_service.dart';
import '../services/insulin_settings_service.dart';
import '../widgets/app_common_widgets.dart';
import '../widgets/food_search_sheet.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  late DateTime _selectedDate;
  int _viewMode = 0; // 0 = diario, 1 = semanal

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (user == null) return Center(child: Text(l10n.historyMustLogin));

    final startOfDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    return Column(
      children: [
        Container(
          color: context.isDarkMode ? const Color(0xFF222222) : Colors.teal.shade50,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 32),
                onPressed: () => _changeDate(-1),
                color: Colors.teal,
                tooltip: l10n.historyPrevDay,
              ),
              Column(
                children: [
                  Text(
                    DateFormat('EEEE, d MMMM', Localizations.localeOf(context).toString()).format(_selectedDate).toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (startOfDay.difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).inDays == 0)
                    Text(l10n.historyToday, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 32),
                onPressed: () => _changeDate(1),
                color: Colors.teal,
                tooltip: l10n.historyNextDay,
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Semantics(
                label: l10n.historyDailyAccessibility,
                child: ChoiceChip(
                  label: Text(l10n.historyDaily),
                  selected: _viewMode == 0,
                  onSelected: (_) => setState(() => _viewMode = 0),
                  selectedColor: Colors.teal.withValues(alpha: 0.25),
                  checkmarkColor: Colors.teal,
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
                label: l10n.historyWeeklyAccessibility,
                child: ChoiceChip(
                  label: Text(l10n.historyWeekly),
                  selected: _viewMode == 1,
                  onSelected: (_) => setState(() => _viewMode = 1),
                  selectedColor: Colors.teal.withValues(alpha: 0.25),
                  checkmarkColor: Colors.teal,
                ),
              ),
              const Spacer(),
              Semantics(
                button: true,
                label: l10n.historyExportAccessibility,
                child: TextButton.icon(
                  onPressed: _exportCSV,
                  icon: const Icon(Icons.file_download_outlined, color: Colors.teal),
                  label: Text(l10n.historyExportButton,
                      style: const TextStyle(color: Colors.teal)),
                ),
              ),
            ],
          ),
        ),

        if (_viewMode == 1)
          Expanded(child: _buildWeeklyChart())
        else
          Expanded(
            child: StreamBuilder<List<MealEntry>>(
              stream: MealHistoryService.watchDaily(user!.uid, startOfDay),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Semantics(
                      label: l10n.historyLoading,
                      child: const CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text(l10n.historyErrorLoading('${snapshot.error}')));
                }

                final entries = snapshot.data ?? [];

                if (entries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ExcludeSemantics(child: Icon(Icons.restaurant_menu, size: 64, color: Colors.grey)),
                        const SizedBox(height: 16),
                        Text(
                          l10n.historyNoRecords,
                          style: const TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ],
                    ),
                  );
                }

                double dailyTotCarbs = 0;
                double dailyTotRations = 0;
                for (var entry in entries) {
                  dailyTotCarbs += entry.totalCarbs;
                  dailyTotRations += entry.totalRations;
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StatCard(
                            title: l10n.historyTotalRations,
                            value: dailyTotRations.toStringAsFixed(1),
                            color: Colors.amber.shade800,
                            isDark: context.isDarkMode,
                          ),
                          StatCard(
                            title: l10n.historyTotalCarbs,
                            value: '${dailyTotCarbs.toStringAsFixed(1)}g',
                            color: Colors.teal,
                            isDark: context.isDarkMode,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          final items = entry.items;
                          final date = entry.timestamp;

                          return Dismissible(
                            key: Key(entry.id),
                            direction: DismissDirection.horizontal,
                            dismissThresholds: const {DismissDirection.endToStart: 0.25},
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: const Icon(Icons.edit, color: Colors.white, size: 30),
                            ),
                            secondaryBackground: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete, color: Colors.white, size: 30),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                _showEditDialog(entry);
                                return false;
                              }
                              return await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(l10n.historyDeleteTitle),
                                  content: Text(l10n.historyDeleteConfirm),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: Text(l10n.historyCancelButton),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: Text(l10n.historyDeleteButton, style: const TextStyle(color: Colors.redAccent)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) return;
                              final deletedEntry = entry;
                              MealHistoryService.deleteEntry(user!.uid, entry.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.historyDeleteSuccess),
                                  action: SnackBarAction(
                                    label: l10n.calcUndo,
                                    onPressed: () {
                                      MealHistoryService.restoreEntry(user!.uid, deletedEntry);
                                    },
                                  ),
                                  duration: const Duration(seconds: 5),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            ExcludeSemantics(child: Icon(entry.mealType.icon, color: Colors.teal)),
                                            const SizedBox(width: 8),
                                            Text(
                                              mealTypeLocalizedLabel(entry.mealType, l10n).toUpperCase(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.teal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              DateFormat('HH:mm').format(date),
                                              style: const TextStyle(color: Colors.grey),
                                            ),
                                            const SizedBox(width: 4),
                                            IconButton(
                                              icon: const Icon(Icons.edit_outlined,
                                                  color: Colors.teal, size: 20),
                                              tooltip: l10n.historyEditButton,
                                              onPressed: () => _showEditDialog(entry),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline,
                                                  color: Colors.redAccent, size: 20),
                                              tooltip: l10n.historyDeleteTooltip(mealTypeLocalizedLabel(entry.mealType, l10n)),
                                              onPressed: () async {
                                                final messenger = ScaffoldMessenger.of(context);
                                                final confirmed = await showDialog<bool>(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text(l10n.historyDeleteTitle),
                                                    content: Text(l10n.historyDeleteConfirm),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(ctx).pop(false),
                                                        child: Text(l10n.historyCancelButton),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(ctx).pop(true),
                                                        child: Text(l10n.historyDeleteButton,
                                                            style: const TextStyle(
                                                                color: Colors.redAccent)),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                if (confirmed == true && mounted) {
                                                  final deletedEntry = entry;
                                                  MealHistoryService.deleteEntry(user!.uid, entry.id);
                                                  messenger.showSnackBar(
                                                    SnackBar(
                                                      content: Text(l10n.historyDeleteSuccess),
                                                      action: SnackBarAction(
                                                        label: l10n.calcUndo,
                                                        onPressed: () {
                                                          MealHistoryService.restoreEntry(user!.uid, deletedEntry);
                                                        },
                                                      ),
                                                      duration: const Duration(seconds: 5),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    ...items.map((item) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              l10n.historyGramsFood(item.grams.toStringAsFixed(0), item.name),
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          Text(
                                            l10n.historyRacShort(item.raciones.toStringAsFixed(1)),
                                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    )),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: context.isDarkMode
                                            ? Colors.teal.withValues(alpha: 0.1)
                                            : Colors.teal.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(l10n.historySubtotal, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                          Text(
                                            l10n.historyRationsCarbs(entry.totalRations.toStringAsFixed(1), entry.totalCarbs.toStringAsFixed(0)),
                                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (entry.glucose != null) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: context.isDarkMode
                                              ? Colors.red.withValues(alpha: 0.08)
                                              : Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const ExcludeSemantics(child: Icon(Icons.monitor_heart, size: 14, color: Colors.redAccent)),
                                                const SizedBox(width: 4),
                                                Text(l10n.calcGlucoseLabel,
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors.redAccent)),
                                              ],
                                            ),
                                            Text(
                                              '${entry.glucose!.toStringAsFixed(0)} mg/dL',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.redAccent),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    if (entry.totalBolus != null) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: context.isDarkMode
                                              ? Colors.orange.withValues(alpha: 0.1)
                                              : Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const ExcludeSemantics(child: Icon(Icons.water_drop, size: 14, color: Colors.orange)),
                                                const SizedBox(width: 4),
                                                Text(l10n.historyBolus,
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors.orange)),
                                              ],
                                            ),
                                            Text(
                                              entry.totalBolus! == entry.totalBolus!.roundToDouble()
                                                  ? l10n.historyBolusUnits(entry.totalBolus!.round().toString())
                                                  : l10n.historyBolusUnits(entry.totalBolus!.toStringAsFixed(1)),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    final l10n = AppLocalizations.of(context);

    final now = DateTime.now();
    final nowDay = DateTime(now.year, now.month, now.day);
    final startOfWeek = nowDay.subtract(const Duration(days: 6));
    final endOfWeek = nowDay.add(const Duration(days: 1));

    return StreamBuilder<List<MealEntry>>(
      stream: MealHistoryService.watchRange(user!.uid, startOfWeek, endOfWeek),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Semantics(
              label: l10n.historyLoading,
              child: const CircularProgressIndicator(),
            ),
          );
        }

        final mealEntries = snapshot.data ?? [];

        final days = List.generate(7,
            (i) => nowDay.subtract(Duration(days: 6 - i)));

        final Map<String, double> carbsByDay = {};
        for (final d in days) {
          final key = DateFormat('dd/MM').format(d);
          carbsByDay[key] = 0;
        }

        for (final entry in mealEntries) {
          final dayKey = DateFormat('dd/MM')
              .format(DateTime(entry.timestamp.year, entry.timestamp.month, entry.timestamp.day));
          if (carbsByDay.containsKey(dayKey)) {
            carbsByDay[dayKey] = (carbsByDay[dayKey] ?? 0) + entry.totalCarbs;
          }
        }

        final entries = carbsByDay.entries.toList();
        final allZero = entries.every((e) => e.value == 0);

        if (allZero) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ExcludeSemantics(child: Icon(Icons.bar_chart, size: 64, color: Colors.grey)),
                const SizedBox(height: 16),
                Text(
                  l10n.historyNoData7Days,
                  style: TextStyle(
                      color: context.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          );
        }

        double maxTotal = 0;
        for (final e in entries) {
          if (e.value > maxTotal) maxTotal = e.value;
        }
        maxTotal = (maxTotal > 0) ? maxTotal : 50;
        final double interval = (maxTotal / 4).ceilToDouble().clamp(1, double.infinity).toDouble();
        maxTotal = interval * 4;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.historyLast7Days,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Semantics(
                  label: _buildChartSemanticsLabel(entries, l10n),
                  child: BarChart(
                    BarChartData(
                    maxY: maxTotal,
                    minY: 0,
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: entries.asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value.value,
                            color: Colors.teal,
                            width: 22,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6)),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxTotal,
                              color: Colors.grey.withValues(alpha: 0.08),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: interval,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withValues(alpha: 0.15),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 42,
                          interval: interval,
                          getTitlesWidget: (value, meta) {
                            if (value == meta.max) return const ExcludeSemantics(child: SizedBox.shrink());
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                '${value.toInt()}g',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey.shade500),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() < entries.length) {
                              return Text(
                                entries[value.toInt()].key,
                                style: const TextStyle(fontSize: 11),
                              );
                            }
                            return const ExcludeSemantics(child: SizedBox.shrink());
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final key = entries[groupIndex].key;
                          return BarTooltipItem(
                            l10n.historyChartTooltip(key, entries[groupIndex].value.toStringAsFixed(1)),
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _buildChartSemanticsLabel(
    List<MapEntry<String, double>> entries,
    AppLocalizations l10n,
  ) {
    if (entries.isEmpty) return l10n.historyNoData7Days;
    final parts = entries.map((e) => '${e.key}: ${e.value.toStringAsFixed(1)}g');
    return '${l10n.historyLast7Days}. ${parts.join(', ')}. ${l10n.historyTotalCarbs}';
  }

  Future<void> _showEditDialog(MealEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDarkMode;

    InsulinSettings? settings;
    if (user != null) {
      settings = await InsulinSettingsService.getSettings(user!.uid);
    }

    MealType mealType = entry.mealType;
    DateTime selectedTime = entry.timestamp;
    double? editedGlucose = entry.glucose;
    final List<Map<String, dynamic>> editableItems = entry.items.map((i) => {
      'name': i.name,
      'grams': i.grams,
      'carbsPer100g': (i.carbs / i.grams * 100),
    }).toList();
    final List<TextEditingController> gramsControllers = editableItems
        .map((i) => TextEditingController(text: (i['grams'] as double).toStringAsFixed(0)))
        .toList();

    const hcPerRation = 10.0;

    double itemCarbs(int idx) {
      final item = editableItems[idx];
      return (item['grams'] as double) * (item['carbsPer100g'] as double) / 100;
    }

    double totalCarbs() {
      double t = 0;
      for (int i = 0; i < editableItems.length; i++) {
        t += itemCarbs(i);
      }
      return t;
    }

    double totalRaciones() => totalCarbs() / hcPerRation;

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        Future<void> addFood(void Function(void Function()) setDialogState) async {
          final sheetCtx = ctx;
          final Food? food = await showModalBottomSheet<Food>(
            context: sheetCtx,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const FoodSearchSheet(),
          );
          if (food == null || !sheetCtx.mounted) return;
          setDialogState(() {
            editableItems.add({
              'name': food.displayName,
              'grams': 100.0,
              'carbsPer100g': food.carbsPer100g,
            });
            gramsControllers.add(TextEditingController(text: '100'));
          });
        }

        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (ctx, scrollController) {
            return StatefulBuilder(
              builder: (ctx, setDialogState) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.historyEditTitle,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal)),
                          IconButton(
                            icon: const Icon(Icons.close),
                            tooltip: MaterialLocalizations.of(ctx).closeButtonLabel,
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Text(l10n.calcMealTypeLabel,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: MealType.mealList.map((type) {
                          final isSelected = mealType == type;
                          return Semantics(
                            checked: isSelected,
                            label: mealTypeLocalizedLabel(type, l10n),
                            child: ChoiceChip(
                              label: Text(mealTypeLocalizedLabel(type, l10n), style: const TextStyle(fontSize: 12)),
                              selected: isSelected,
                              selectedColor: Colors.teal.withValues(alpha: 0.3),
                              checkmarkColor: Colors.teal,
                              onSelected: (_) => setDialogState(() => mealType = type),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      Semantics(
                        button: true,
                        label: l10n.calcDateLabel,
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: ctx,
                              initialDate: selectedTime,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                              builder: (context, child) => MediaQuery(
                                data: MediaQuery.of(context),
                                child: child!,
                              ),
                            );
                            if (date != null) {
                              setDialogState(() => selectedTime = DateTime(
                                date.year, date.month, date.day,
                                selectedTime.hour, selectedTime.minute,
                              ));
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                ExcludeSemantics(child: Icon(Icons.calendar_today, color: Theme.of(ctx).colorScheme.primary)),
                                const SizedBox(width: 12),
                                Text(l10n.calcDateLabel,
                                    style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                                const Spacer(),
                                Text(DateFormat.yMMMd().format(selectedTime),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const Icon(Icons.arrow_drop_down, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Semantics(
                        button: true,
                        label: l10n.calcTimeLabel,
                        child: InkWell(
                          onTap: () async {
                            final now = DateTime.now();
                            final time = await showTimePicker(
                              context: ctx,
                              initialTime: TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute),
                              builder: (context, child) => MediaQuery(
                                data: MediaQuery.of(context),
                                child: child!,
                              ),
                            );
                            if (time != null) {
                              final chosen = DateTime(
                                selectedTime.year, selectedTime.month, selectedTime.day,
                                time.hour, time.minute,
                              );
                              setDialogState(() => selectedTime = chosen.isAfter(now) ? now : chosen);
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                ExcludeSemantics(child: Icon(Icons.access_time, color: Theme.of(ctx).colorScheme.primary)),
                                const SizedBox(width: 12),
                                Text(l10n.calcTimeLabel,
                                    style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                                const Spacer(),
                                Text(DateFormat.Hm().format(selectedTime),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const Icon(Icons.arrow_drop_down, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.calcMyPlate,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
                          Semantics(
                            button: true,
                            label: l10n.calcAddToPlate,
                            child: TextButton.icon(
                              onPressed: () => addFood(setDialogState),
                              icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                              label: Text(l10n.calcAddToPlate,
                                  style: const TextStyle(color: Colors.teal, fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      ...editableItems.asMap().entries.map((e) {
                        final idx = e.key;
                        final item = editableItems[idx];
                        final grams = item['grams'] as double;
                        final carbsPer100 = item['carbsPer100g'] as double;
                        final carbs = grams * carbsPer100 / 100;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 4),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(item['name'] as String,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline,
                                          color: Colors.redAccent, size: 20),
                                      tooltip: l10n.calcDeleteFromPlate,
                                      onPressed: () {
                                        setDialogState(() {
                                          editableItems.removeAt(idx);
                                          gramsControllers[idx].dispose();
                                          gramsControllers.removeAt(idx);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: l10n.historyEditGramsLabel,
                                          suffixText: 'g',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        ),
                                        keyboardType:
                                            const TextInputType.numberWithOptions(decimal: true),
                                        controller: gramsControllers[idx],
                                        onChanged: (v) {
                                          final val = double.tryParse(v);
                                          if (val != null && val > 0) {
                                            setDialogState(() => editableItems[idx]['grams'] = val);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text('${carbs.toStringAsFixed(1)}g HC',
                                        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.teal)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 16),

                      TextField(
                        decoration: InputDecoration(
                          labelText: l10n.calcGlucoseLabel,
                          hintText: l10n.calcGlucoseHint,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.monitor_heart),
                          suffixText: settings?.glucoseLabel() ?? l10n.calcGlucoseSuffix,
                          filled: true,
                          fillColor: isDark ? const Color(0xFF333333) : Colors.white,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        controller: TextEditingController(
                            text: (() {
                              final g = entry.glucose;
                              if (g == null) return '';
                              if (settings != null) {
                                return settings.fromStoredGlucoseUnit(g).toStringAsFixed(0);
                              }
                              return g.toStringAsFixed(0);
                            })(),
                        ),
                        onChanged: (v) {
                          final val = double.tryParse(v);
                          if (val != null) {
                            setDialogState(() => editedGlucose =
                                settings?.toStoredGlucoseUnit(val) ?? val);
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(child: StatCard(
                            title: l10n.calcRations,
                            value: totalRaciones().toStringAsFixed(1),
                            color: Colors.amber.shade800,
                            isDark: isDark,
                          )),
                          const SizedBox(width: 12),
                          Expanded(child: StatCard(
                            title: l10n.calcGramsHC,
                            value: '${totalCarbs().toStringAsFixed(1)}g',
                            color: Colors.teal,
                            isDark: isDark,
                          )),
                        ],
                      ),
                      const SizedBox(height: 24),

                      FilledButton.icon(
                        onPressed: editableItems.isEmpty ? null : () async {
                          final updatedItems = editableItems.map((item) {
                            final g = item['grams'] as double;
                            final cp100 = item['carbsPer100g'] as double;
                            final c = g * cp100 / 100;
                            return {
                              'name': item['name'],
                              'grams': g,
                              'carbs': c,
                              'raciones': c / hcPerRation,
                            };
                          }).toList();

                          final messenger = ScaffoldMessenger.of(context);
                          await MealHistoryService.updateEntry(
                            user!.uid,
                            entry.id,
                            mealType: mealType.rawValue,
                            totalCarbs: totalCarbs(),
                            totalRations: totalRaciones(),
                            items: updatedItems,
                            glucose: editedGlucose,
                            timestamp: selectedTime,
                          );
                          if (ctx.mounted) {
                            Navigator.of(ctx).pop();
                            messenger.showSnackBar(
                              SnackBar(content: Text(l10n.historyEditSuccess)),
                            );
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: Text(l10n.historyEditSave,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _exportCSV() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final entries = await MealHistoryService.fetchAll(user!.uid);

      if (entries.isEmpty) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.historyExportEmpty)),
        );
        return;
      }

      final buffer = StringBuffer();
      buffer.writeln('${l10n.historyCsvHeader},Glucemia (mg/dL),Bolo (uds)');

      for (final entry in entries) {
        final dateStr = DateFormat('yyyy-MM-dd').format(entry.timestamp);
        final timeStr = DateFormat('HH:mm').format(entry.timestamp);
        final glucoseStr = entry.glucose?.toStringAsFixed(0) ?? '';
        final bolusStr = entry.totalBolus?.toStringAsFixed(1) ?? '';

        if (entry.items.isEmpty) {
          buffer.writeln('$dateStr,$timeStr,"${entry.mealType.rawValue}","-",-,"${entry.totalRations.toStringAsFixed(1)}","${entry.totalCarbs.toStringAsFixed(1)}",$glucoseStr,$bolusStr');
        } else {
          for (final item in entry.items) {
            buffer.writeln('$dateStr,$timeStr,"${entry.mealType.rawValue}","${item.name}","${item.grams.toStringAsFixed(0)}","${item.raciones.toStringAsFixed(1)}","${item.carbs.toStringAsFixed(1)}",$glucoseStr,$bolusStr');
          }
        }
      }

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/libretadulce_historial.csv');
      await file.writeAsString(buffer.toString());

      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path)],
        subject: l10n.historyShareSubject,
      ));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.historyExportError(e.toString()))),
      );
    }
  }
}
