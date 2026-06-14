import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../core/extensions/context_extensions.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/meal_type_localizer.dart';
import '../l10n/app_localizations.dart';
import '../models/food.dart';
import '../models/meal_type.dart';
import '../models/insulin_settings.dart';
import '../services/meal_history_service.dart';
import '../services/insulin_settings_service.dart';
import '../services/pdf_report_service.dart';
import '../widgets/app_common_widgets.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/date_time_picker_tile.dart';
import '../widgets/food_search_sheet.dart';
import '../widgets/glucose_input_field.dart';
import '../widgets/meal_type_chip_selector.dart';

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

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (user == null) return Center(child: Text(l10n.historyMustLogin));

    final startOfDay = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    return Column(
      children: [
        Container(
          color: AppColors.headerBg(context),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 32),
                onPressed: () => _changeDate(-1),
                color: AppColors.primary(context),
                tooltip: l10n.historyPrevDay,
              ),
              Column(
                children: [
                  Text(
                    DateFormat(
                      'EEEE, d MMMM',
                      Localizations.localeOf(context).toString(),
                    ).format(_selectedDate).toUpperCase(),
                    style: AppTextStyles.sectionTitle,
                  ),
                  if (startOfDay
                          .difference(
                            DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                            ),
                          )
                          .inDays ==
                      0)
                    Text(
                      l10n.historyToday,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 32),
                onPressed: _isToday(_selectedDate)
                    ? null
                    : () => _changeDate(1),
                color: Colors.teal,
                tooltip: l10n.historyNextDay,
              ),
            ],
          ),
        ),

        Padding(
          padding: AppDimens.listTileContent,
          child: Row(
            children: [
              Semantics(
                checked: _viewMode == 0,
                label: l10n.historyDailyAccessibility,
                child: ChoiceChip(
                  label: Text(l10n.historyDaily),
                  selected: _viewMode == 0,
                  onSelected: (_) => setState(() => _viewMode = 0),
                  selectedColor: Colors.teal.withValues(alpha: 0.25),
                  checkmarkColor: Colors.teal,
                  visualDensity: VisualDensity.standard,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
                checked: _viewMode == 1,
                label: l10n.historyWeeklyAccessibility,
                child: ChoiceChip(
                  label: Text(l10n.historyWeekly),
                  selected: _viewMode == 1,
                  onSelected: (_) => setState(() => _viewMode = 1),
                  selectedColor: Colors.teal.withValues(alpha: 0.25),
                  checkmarkColor: Colors.teal,
                  visualDensity: VisualDensity.standard,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
              ),
              const Spacer(),
              Semantics(
                button: true,
                label: l10n.historyExportAccessibility,
                child: TextButton.icon(
                  onPressed: _showExportOptions,
                  icon: const Icon(
                    Icons.file_download_outlined,
                    color: Colors.teal,
                  ),
                  label: Text(
                    l10n.historyExportButton,
                    style: const TextStyle(color: Colors.teal),
                  ),
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
                  return Center(
                    child: Text(l10n.historyErrorLoading('${snapshot.error}')),
                  );
                }

                final entries = snapshot.data ?? [];

                if (entries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ExcludeSemantics(
                          child: Icon(
                            Icons.restaurant_menu,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.historyNoRecords,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
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
                            dismissThresholds: const {
                              DismissDirection.endToStart: 0.25,
                            },
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusDialog,
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: const ExcludeSemantics(
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            secondaryBackground: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusDialog,
                                ),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const ExcludeSemantics(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                _showEditDialog(entry);
                                return false;
                              }
                              return showConfirmDeleteDialog(
                                context,
                                title: l10n.historyDeleteTitle,
                                content: l10n.historyDeleteConfirm,
                              );
                            },
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                return;
                              }
                              final deletedEntry = entry;
                              MealHistoryService.deleteEntry(
                                user!.uid,
                                entry.id,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.historyDeleteSuccess),
                                  action: SnackBarAction(
                                    label: l10n.calcUndo,
                                    onPressed: () {
                                      MealHistoryService.restoreEntry(
                                        user!.uid,
                                        deletedEntry,
                                      );
                                    },
                                  ),
                                  duration: const Duration(seconds: 5),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusDialog,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              ExcludeSemantics(
                                                child: Icon(
                                                  entry.mealType.icon,
                                                  color: Colors.teal,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Flexible(
                                                child: Text(
                                                  mealTypeLocalizedLabel(
                                                    entry.mealType,
                                                    l10n,
                                                  ).toUpperCase(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.teal,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              DateFormat('HH:mm').format(date),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit_outlined,
                                                color: Colors.teal,
                                                size: 20,
                                              ),
                                              tooltip: l10n.historyEditButton,
                                              onPressed: () =>
                                                  _showEditDialog(entry),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.redAccent,
                                                size: 20,
                                              ),
                                              tooltip: l10n
                                                  .historyDeleteTooltip(
                                                    mealTypeLocalizedLabel(
                                                      entry.mealType,
                                                      l10n,
                                                    ),
                                                  ),
                                              onPressed: () async {
                                                final messenger =
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    );
                                                final confirmed =
                                                    await showConfirmDeleteDialog(
                                                      context,
                                                      title: l10n
                                                          .historyDeleteTitle,
                                                      content: l10n
                                                          .historyDeleteConfirm,
                                                    );
                                                if (confirmed == true &&
                                                    mounted) {
                                                  final deletedEntry = entry;
                                                  MealHistoryService.deleteEntry(
                                                    user!.uid,
                                                    entry.id,
                                                  );
                                                  messenger.showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        l10n.historyDeleteSuccess,
                                                      ),
                                                      action: SnackBarAction(
                                                        label: l10n.calcUndo,
                                                        onPressed: () {
                                                          MealHistoryService.restoreEntry(
                                                            user!.uid,
                                                            deletedEntry,
                                                          );
                                                        },
                                                      ),
                                                      duration: const Duration(
                                                        seconds: 5,
                                                      ),
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
                                    ...items.map(
                                      (item) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                l10n.historyGramsFood(
                                                  item.grams.toStringAsFixed(0),
                                                  item.name,
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              l10n.historyRacShort(
                                                item.raciones.toStringAsFixed(
                                                  1,
                                                ),
                                              ),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.isDarkMode
                                            ? Colors.teal.withValues(alpha: 0.1)
                                            : Colors.teal.shade50,
                                        borderRadius: BorderRadius.circular(
                                          AppDimens.radiusInput,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                              entry.totalRations
                                                  .toStringAsFixed(1),
                                              entry.totalCarbs.toStringAsFixed(
                                                0,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (entry.totalFats != null &&
                                        entry.totalFats! > 0) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: context.isDarkMode
                                              ? Colors.orange.withValues(
                                                  alpha: 0.1,
                                                )
                                              : Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(
                                            AppDimens.radiusInput,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const ExcludeSemantics(
                                                    child: Icon(
                                                      Icons.opacity,
                                                      size: 14,
                                                      color: Colors.orange,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      l10n.historyTotalFats,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors.orange,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              '${entry.totalFats!.toStringAsFixed(1)}g',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    if (entry.totalProteins != null &&
                                        entry.totalProteins! > 0) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: context.isDarkMode
                                              ? Colors.blue.withValues(
                                                  alpha: 0.1,
                                                )
                                              : Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(
                                            AppDimens.radiusInput,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const ExcludeSemantics(
                                                    child: Icon(
                                                      Icons.fitness_center,
                                                      size: 14,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      l10n.historyTotalProteins,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors.blue,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              '${entry.totalProteins!.toStringAsFixed(1)}g',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    if (entry.glucose != null) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: context.isDarkMode
                                              ? Colors.red.withValues(
                                                  alpha: 0.08,
                                                )
                                              : Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(
                                            AppDimens.radiusInput,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const ExcludeSemantics(
                                                    child: Icon(
                                                      Icons.monitor_heart,
                                                      size: 14,
                                                      color: Colors.redAccent,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      l10n.calcGlucoseLabel,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors.redAccent,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              '${entry.glucose!.toStringAsFixed(0)} mg/dL',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    if (entry.totalBolus != null) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: context.isDarkMode
                                              ? Colors.orange.withValues(
                                                  alpha: 0.1,
                                                )
                                              : Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(
                                            AppDimens.radiusInput,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const ExcludeSemantics(
                                                    child: Icon(
                                                      Icons.water_drop,
                                                      size: 14,
                                                      color: Colors.orange,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      l10n.historyBolus,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors.orange,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              entry.totalBolus! ==
                                                      entry.totalBolus!
                                                          .roundToDouble()
                                                  ? l10n.historyBolusUnits(
                                                      entry.totalBolus!
                                                          .round()
                                                          .toString(),
                                                    )
                                                  : l10n.historyBolusUnits(
                                                      entry.totalBolus!
                                                          .toStringAsFixed(1),
                                                    ),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange,
                                              ),
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
    final isDark = context.isDarkMode;

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

        final days = List.generate(
          7,
          (i) => nowDay.subtract(Duration(days: 6 - i)),
        );

        // ── Aggregate carbs + glucose per day ──
        final Map<String, double> carbsByDay = {};
        final Map<String, List<double>> glucosesByDay = {};
        for (final d in days) {
          final key = DateFormat('dd/MM').format(d);
          carbsByDay[key] = 0;
          glucosesByDay[key] = [];
        }

        for (final entry in mealEntries) {
          final dayKey = DateFormat('dd/MM').format(
            DateTime(
              entry.timestamp.year,
              entry.timestamp.month,
              entry.timestamp.day,
            ),
          );
          if (carbsByDay.containsKey(dayKey)) {
            carbsByDay[dayKey] = (carbsByDay[dayKey] ?? 0) + entry.totalCarbs;
          }
          if (entry.glucose != null && glucosesByDay.containsKey(dayKey)) {
            glucosesByDay[dayKey]!.add(entry.glucose!);
          }
        }

        final entries = carbsByDay.entries.toList();
        final allZero = entries.every((e) => e.value == 0);

        if (allZero) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ExcludeSemantics(
                  child: Icon(Icons.bar_chart, size: 64, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.historyNoData7Days,
                  style: AppTextStyles.bodyText(context),
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
        final double interval = (maxTotal / 4)
            .ceilToDouble()
            .clamp(1, double.infinity)
            .toDouble();
        maxTotal = interval * 4;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.historyLast7Days,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              // ── Glucose color legend ──
              _buildGlucoseLegend(l10n, isDark),
              const SizedBox(height: 12),
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
                                top: Radius.circular(6),
                              ),
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
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 42,
                            interval: interval,
                            getTitlesWidget: (value, meta) {
                              if (value == meta.max) {
                                return const ExcludeSemantics(
                                  child: SizedBox.shrink(),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Text(
                                  '${value.toInt()}g',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= days.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  _weekdayLabel(days[idx]),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final dayKey = entries[group.x].key;
                            final glucoses = glucosesByDay[dayKey] ?? [];
                            final avgGlucose = glucoses.isNotEmpty
                                ? glucoses.reduce((a, b) => a + b) /
                                      glucoses.length
                                : null;
                            String tip = 'HC: ${rod.toY.toStringAsFixed(0)}g';
                            if (avgGlucose != null) {
                              tip +=
                                  '\nGlu: ${avgGlucose.toStringAsFixed(0)} mg/dL';
                            }
                            return BarTooltipItem(
                              tip,
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // ── Glucose dots row (aligned with chart bars) ──
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 42),
                child: Row(
                  children: List.generate(entries.length, (i) {
                    final glucoses = glucosesByDay[entries[i].key] ?? [];
                    final avgGlucose = glucoses.isNotEmpty
                        ? glucoses.reduce((a, b) => a + b) / glucoses.length
                        : null;
                    return Expanded(
                      child: Column(
                        children: [
                          if (avgGlucose != null)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _glucoseColor(avgGlucose),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _glucoseColor(
                                      avgGlucose,
                                    ).withValues(alpha: 0.3),
                                    blurRadius: 3,
                                    spreadRadius: 0.5,
                                  ),
                                ],
                              ),
                            )
                          else
                            const SizedBox(width: 10, height: 10),
                          const SizedBox(height: 2),
                          if (avgGlucose != null)
                            Text(
                              avgGlucose.toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: _glucoseColor(avgGlucose),
                              ),
                            )
                          else
                            const Text(
                              '–',
                              style: TextStyle(fontSize: 9, color: Colors.grey),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  /// Returns a color for a glucose value (mg/dL).
  Color _glucoseColor(double mgdl) {
    if (mgdl < 70) return Colors.amber; // hypo
    if (mgdl > 180) return Colors.redAccent; // hyper
    return Colors.green; // in range
  }

  /// Legend row explaining the glucose dot colors.
  Widget _buildGlucoseLegend(AppLocalizations l10n, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendDot(Colors.green, l10n.historyGlucoseInRange, isDark),
        const SizedBox(width: 12),
        _legendDot(Colors.redAccent, l10n.historyGlucoseHigh, isDark),
        const SizedBox(width: 12),
        _legendDot(Colors.amber, l10n.historyGlucoseLow, isDark),
      ],
    );
  }

  Widget _legendDot(Color color, String label, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  String _weekdayLabel(DateTime date) {
    // Abbreviated weekday labels
    const labels = ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sá', 'Do'];
    // DateTime.weekday: 1=Monday, 7=Sunday
    return labels[date.weekday - 1];
  }

  String _buildChartSemanticsLabel(
    List<MapEntry<String, double>> entries,
    AppLocalizations l10n,
  ) {
    if (entries.isEmpty) return l10n.historyNoData7Days;
    final parts = entries.map(
      (e) => '${e.key}: ${e.value.toStringAsFixed(1)}g',
    );
    return '${l10n.historyLast7Days}. ${parts.join(', ')}. ${l10n.historyTotalCarbs}';
  }

  Future<void> _showEditDialog(MealEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDarkMode;

    InsulinSettings? settings;
    if (user != null) {
      settings = await InsulinSettingsService.getSettings(user!.uid);
    }

    if (!mounted) return;

    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EditMealSheet(
        entry: entry,
        settings: settings,
        uid: user!.uid,
        l10n: l10n,
        isDark: isDark,
      ),
    );
    // No-op: sheet handles its own save
  }

  void _showExportOptions() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.historyExportOptionsTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.redAccent,
                    size: 28,
                  ),
                  title: Text(l10n.historyPdfExportOption),
                  subtitle: Text(
                    l10n.historyPdfExportSubtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _exportPdf();
                  },
                ),
                const Divider(indent: 72),
                ListTile(
                  leading: const Icon(
                    Icons.table_chart_outlined,
                    color: Colors.teal,
                    size: 28,
                  ),
                  title: Text(l10n.historyCsvExportOption),
                  subtitle: Text(
                    l10n.historyCsvExportSubtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _exportCSV();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _exportPdf() async {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final messenger = ScaffoldMessenger.of(context);

    // ── Ask for date range ──
    final now = DateTime.now();
    final initialFrom = DateTime(now.year, now.month - 1, now.day);
    DateTime fromDate = initialFrom;
    DateTime toDate = now;

    final range = await showDialog<Map<String, DateTime>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: Text(l10n.historyPdfDateRangeTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_today,
                      color: Colors.teal),
                  title: Text(l10n.historyPdfFrom),
                  subtitle: Text(DateFormat('dd/MM/yyyy', locale)
                      .format(fromDate)),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: fromDate,
                      firstDate: DateTime(2020),
                      lastDate: toDate,
                      helpText: l10n.historyPdfFrom,
                    );
                    if (picked != null) {
                      setState(() => fromDate = picked);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today,
                      color: Colors.orange),
                  title: Text(l10n.historyPdfTo),
                  subtitle: Text(DateFormat('dd/MM/yyyy', locale)
                      .format(toDate)),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: toDate,
                      firstDate: fromDate,
                      lastDate: now,
                      helpText: l10n.historyPdfTo,
                    );
                    if (picked != null) {
                      setState(() => toDate = picked);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child:
                    Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, {
                  'from': fromDate,
                  'to': toDate,
                }),
                child: Text(l10n.historyPdfGenerate),
              ),
            ],
          );
        },
      ),
    );

    if (range == null) return;

    if (!mounted) return;
    try {
      await PdfReportService.generateReport(
        uid: user!.uid,
        l10n: l10n,
        locale: locale,
        userName: user!.displayName ?? l10n.profileDefaultName,
        from: range['from']!,
        to: range['to']!,
      );
    } on PdfEmptyException catch (_) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.historyPdfEmpty),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint('[HistoryPage._exportPdf] Error: $e');
      messenger.showSnackBar(
        SnackBar(
          content: Text('${l10n.historyPdfError}: $e'),
          duration: const Duration(seconds: 6),
        ),
      );
    }
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
          buffer.writeln(
            '$dateStr,$timeStr,"${entry.mealType.rawValue}","-",-,"${entry.totalRations.toStringAsFixed(1)}","${entry.totalCarbs.toStringAsFixed(1)}",$glucoseStr,$bolusStr',
          );
        } else {
          for (final item in entry.items) {
            buffer.writeln(
              '$dateStr,$timeStr,"${entry.mealType.rawValue}","${item.name}","${item.grams.toStringAsFixed(0)}","${item.raciones.toStringAsFixed(1)}","${item.carbs.toStringAsFixed(1)}",$glucoseStr,$bolusStr',
            );
          }
        }
      }

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/libretadulce_historial.csv');
      await file.writeAsString(buffer.toString());

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: l10n.historyShareSubject,
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.historyExportError(e.toString()))),
      );
    }
  }
}

// ────────────────────────────────────────────────────────────────────
// Edit Meal Sheet — proper StatefulWidget for reliable state management
// ────────────────────────────────────────────────────────────────────

class _EditMealSheet extends StatefulWidget {
  final MealEntry entry;
  final InsulinSettings? settings;
  final String uid;
  final AppLocalizations l10n;
  final bool isDark;

  const _EditMealSheet({
    required this.entry,
    required this.settings,
    required this.uid,
    required this.l10n,
    required this.isDark,
  });

  @override
  State<_EditMealSheet> createState() => _EditMealSheetState();
}

class _EditMealSheetState extends State<_EditMealSheet> {
  static const _hcPerRation = 10.0;

  late MealType _mealType;
  late DateTime _selectedTime;
  late double? _editedGlucose;
  late final List<Map<String, dynamic>> _editableItems;
  late final List<TextEditingController> _gramsControllers;
  bool _saving = false;
  late final TextEditingController _glucoseController;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _mealType = entry.mealType;
    _selectedTime = entry.timestamp;
    _editedGlucose = entry.glucose;

    _editableItems = entry.items.map((i) {
      return {
        'name': i.name,
        'grams': i.grams,
        'carbsPer100g': i.grams > 0 ? (i.carbs / i.grams * 100) : 0.0,
      };
    }).toList();

    _gramsControllers = _editableItems
        .map(
          (i) => TextEditingController(
            text: (i['grams'] as double).toStringAsFixed(0),
          ),
        )
        .toList();

    final g = entry.glucose;
    String glucoseText = '';
    if (g != null) {
      if (widget.settings != null) {
        glucoseText = widget.settings!
            .fromStoredGlucoseUnit(g)
            .toStringAsFixed(0);
      } else {
        glucoseText = g.toStringAsFixed(0);
      }
    }
    _glucoseController = TextEditingController(text: glucoseText);
  }

  @override
  void dispose() {
    for (final c in _gramsControllers) {
      c.dispose();
    }
    _glucoseController.dispose();
    super.dispose();
  }

  double _itemCarbs(int idx) {
    final item = _editableItems[idx];
    return (item['grams'] as double) * (item['carbsPer100g'] as double) / 100;
  }

  double get _totalCarbs {
    double t = 0;
    for (int i = 0; i < _editableItems.length; i++) {
      t += _itemCarbs(i);
    }
    return t;
  }

  double get _totalRations => _totalCarbs / _hcPerRation;

  Future<void> _addFood() async {
    final Food? food = await showModalBottomSheet<Food>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FoodSearchSheet(),
    );
    if (food == null || !mounted) return;
    setState(() {
      _editableItems.add({
        'name': food.displayName,
        'grams': 100.0,
        'carbsPer100g': food.carbsPer100g,
      });
      _gramsControllers.add(TextEditingController(text: '100'));
    });
  }

  void _removeItem(int idx) {
    setState(() {
      _editableItems.removeAt(idx);
      _gramsControllers[idx].dispose();
      _gramsControllers.removeAt(idx);
    });
  }

  Future<void> _save() async {
    if (_editableItems.isEmpty || _saving) return;
    setState(() => _saving = true);

    final messenger = ScaffoldMessenger.of(context);
    try {
      final updatedItems = _editableItems.map((item) {
        final g = item['grams'] as double;
        final cp100 = item['carbsPer100g'] as double;
        final c = g * cp100 / 100;
        return {
          'name': item['name'],
          'grams': g,
          'carbs': c,
          'raciones': c / _hcPerRation,
        };
      }).toList();

      await MealHistoryService.updateEntry(
        widget.uid,
        widget.entry.id,
        mealType: _mealType.rawValue,
        totalCarbs: _totalCarbs,
        totalRations: _totalRations,
        items: updatedItems,
        glucose: _editedGlucose,
        timestamp: _selectedTime,
      );

      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(widget.l10n.historyEditSuccess),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('[EditMealSheet._save] Error: $e');
      if (mounted) {
        setState(() => _saving = false);
        messenger.showSnackBar(
          SnackBar(
            content: Text(widget.l10n.serviceError),
            duration: const Duration(seconds: 6),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final isDark = widget.isDark;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: AppDimens.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.historyEditTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: MaterialLocalizations.of(ctx).closeButtonLabel,
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              MealTypeChipSelector(
                selected: _mealType,
                onChanged: (type) => setState(() => _mealType = type),
                l10n: l10n,
              ),
              const SizedBox(height: 16),

              DateTimePickerTile(
                selectedTime: _selectedTime,
                onChanged: (dt) => setState(() => _selectedTime = dt),
                mode: PickerMode.date,
                label: l10n.calcDateLabel,
              ),
              const SizedBox(height: 8),

              DateTimePickerTile(
                selectedTime: _selectedTime,
                onChanged: (dt) => setState(() => _selectedTime = dt),
                mode: PickerMode.time,
                label: l10n.calcTimeLabel,
              ),
              const SizedBox(height: 20),

              // ── Plate header + add button ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.calcMyPlate,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: Colors.teal,
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: l10n.calcAddToPlate,
                    child: TextButton.icon(
                      onPressed: _addFood,
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.teal,
                      ),
                      label: Text(
                        l10n.calcAddToPlate,
                        style: const TextStyle(
                          color: Colors.teal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // ── Food items ──
              ..._editableItems.asMap().entries.map((e) {
                final idx = e.key;
                final item = _editableItems[idx];
                final grams = item['grams'] as double;
                final carbsPer100 = item['carbsPer100g'] as double;
                final carbs = grams * carbsPer100 / 100;
                final rations = carbs / _hcPerRation;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade900
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                      border: Border.all(
                        color: isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade200,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row 1: name + rations + delete
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item['name'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                l10n.calcRacShort(rations.toStringAsFixed(1)),
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 15,
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
                                onPressed: () => _removeItem(idx),
                              ),
                            ],
                          ),
                          // Row 2: grams input
                          Padding(
                            padding: const EdgeInsets.only(left: 26, top: 2),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: l10n.historyEditGramsLabel,
                                      suffixText: 'g',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppDimens.radiusInput,
                                        ),
                                      ),
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                    ),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    controller: _gramsControllers[idx],
                                    onChanged: (v) {
                                      final val = double.tryParse(v);
                                      if (val != null && val > 0) {
                                        setState(
                                          () => _editableItems[idx]['grams'] =
                                              val,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                _macroPill(
                                  l10n.calcHC(carbs.toStringAsFixed(1)),
                                  Colors.teal,
                                  isDark,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              GlucoseInputField(
                controller: _glucoseController,
                settings: widget.settings,
                l10n: l10n,
                onChanged: (v) {
                  final val = double.tryParse(v);
                  if (val != null) {
                    setState(
                      () => _editedGlucose =
                          widget.settings?.toStoredGlucoseUnit(val) ?? val,
                    );
                  }
                },
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: StatCard(
                      title: l10n.calcRations,
                      value: _totalRations.toStringAsFixed(1),
                      color: Colors.amber.shade800,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: l10n.calcGramsHC,
                      value: '${_totalCarbs.toStringAsFixed(1)}g',
                      color: Colors.teal,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: (_editableItems.isEmpty || _saving) ? null : _save,
                icon: const Icon(Icons.save),
                label: Text(
                  l10n.historyEditSave,
                  style: AppTextStyles.sectionTitle,
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  /// Compact colored pill for a macro value.
  Widget _macroPill(String text, Color color, bool isDark) {
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
