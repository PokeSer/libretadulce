import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../core/extensions/context_extensions.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import '../l10n/app_localizations.dart';
import '../models/food.dart';
import '../models/insulin_settings.dart';
import '../services/meal_history_service.dart';
import '../services/insulin_settings_service.dart';
import '../services/pdf_report_service.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/edit_meal_sheet.dart';
import '../widgets/history_entry_card.dart';
import '../widgets/history_stats_panel.dart';
import '../widgets/weekly_chart_widget.dart';

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
                      style: TextStyle(
                        color: AppColors.primary(context),
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
                color: AppColors.primary(context),
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
                  selectedColor: AppColors.primary(context).withValues(alpha: 0.25),
                  checkmarkColor: AppColors.primary(context),
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
                  selectedColor: AppColors.primary(context).withValues(alpha: 0.25),
                  checkmarkColor: AppColors.primary(context),
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
                  icon: Icon(
                    Icons.file_download_outlined,
                    color: AppColors.primary(context),
                  ),
                  label: Text(
                    l10n.historyExportButton,
                    style: TextStyle(color: AppColors.primary(context)),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (_viewMode == 1)
          Expanded(child: WeeklyChartWidget(uid: user!.uid))
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

                return Column(
                  children: [
                    HistoryStatsPanel(
                      entries: entries,
                      selectedRange: _viewMode,
                    ),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];

                          return Dismissible(
                            key: Key(entry.id),
                            direction: DismissDirection.horizontal,
                            dismissThresholds: const {
                              DismissDirection.endToStart: 0.25,
                            },
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: AppColors.primary(context),
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
                            child: HistoryEntryCard(
                              entry: entry,
                              uid: user!.uid,
                              onEdit: () => _showEditDialog(entry),
                              onDelete: () async {
                                final messenger = ScaffoldMessenger.of(context);
                                final confirmed = await showConfirmDeleteDialog(
                                  context,
                                  title: l10n.historyDeleteTitle,
                                  content: l10n.historyDeleteConfirm,
                                );
                                if (confirmed == true && mounted) {
                                  final deletedEntry = entry;
                                  MealHistoryService.deleteEntry(
                                    user!.uid,
                                    entry.id,
                                  );
                                  messenger.showSnackBar(
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
                                }
                              },
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
      builder: (_) => EditMealSheet(
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary(context),
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
                  leading: Icon(
                    Icons.table_chart_outlined,
                    color: AppColors.primary(context),
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
                  leading: Icon(Icons.calendar_today,
                      color: AppColors.primary(context)),
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

      // Load insulin settings to know if the user is on mmol/L or mg/dL
      final settings = await InsulinSettingsService.getSettings(user!.uid);
      final glucoseUnit = settings?.glucoseLabel() ?? 'mg/dL';

      final buffer = StringBuffer();
      buffer.writeln('${l10n.historyCsvHeader},$glucoseUnit,${l10n.historyBolus.replaceAll(':', '')} (uds)');

      for (final entry in entries) {
        final dateStr = DateFormat('yyyy-MM-dd').format(entry.timestamp);
        final timeStr = DateFormat('HH:mm').format(entry.timestamp);
        // Glucose stored in mg/dL; convert to display unit if needed
        final rawGlucose = entry.glucose;
        final glucoseStr = rawGlucose == null
            ? ''
            : (settings?.usesMmolL == true
                ? (rawGlucose / 18.018).toStringAsFixed(1)
                : rawGlucose.toStringAsFixed(0));
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

