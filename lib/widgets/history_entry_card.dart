import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/extensions/context_extensions.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/utils/meal_type_localizer.dart';
import '../l10n/app_localizations.dart';
import '../models/food.dart';
import '../services/meal_ai_advisor_service.dart';
import '../services/meal_history_service.dart';
import '../services/food_photo_analyzer_service.dart';

/// Card for a single MealEntry in the history list.
/// Renders: meal type chip, timestamp, items list, totals row,
/// bolus badge, glucose badge (both optional), and an AI advisor panel.
class HistoryEntryCard extends StatefulWidget {
  final MealEntry entry;
  final String uid;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const HistoryEntryCard({
    super.key,
    required this.entry,
    required this.uid,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<HistoryEntryCard> createState() => _HistoryEntryCardState();
}

class _HistoryEntryCardState extends State<HistoryEntryCard> {
  bool _isAnalyzing = false;
  String? _errorMessage;

  // Local copy of the entry so we can update aiAnalysis without waiting
  // for a Firestore round-trip.
  late MealEntry _entry;

  @override
  void initState() {
    super.initState();
    _entry = widget.entry;
  }

  @override
  void didUpdateWidget(HistoryEntryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent pushes a new entry (e.g. after Firestore update), sync.
    if (oldWidget.entry != widget.entry) {
      _entry = widget.entry;
    }
  }

  Future<void> _analyze() async {
    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
    });

    try {
      final locale = Localizations.localeOf(context).languageCode;
      final analysis = await MealAiAdvisorService.analyzeMeal(
        _entry,
        locale: locale,
      );
      final jsonStr = analysis.toJsonString();
      // Persist to Firestore
      await MealHistoryService.saveAiAnalysis(
        widget.uid,
        _entry.id,
        aiAnalysisJson: jsonStr,
      );
      if (mounted) {
        setState(() {
          _entry = _entry.copyWith(
            aiAnalysis: jsonStr,
            aiAnalysisDate: DateTime.now(),
          );
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  Future<void> _deleteAnalysis() async {
    await MealHistoryService.deleteAiAnalysis(widget.uid, _entry.id);
    if (mounted) {
      setState(() {
        _entry = _entry.copyWith(aiAnalysis: null, aiAnalysisDate: null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDarkMode;
    final date = _entry.timestamp;
    final items = _entry.items;

    final analysis = MealAiAnalysis.tryParseJsonString(_entry.aiAnalysis);

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
                        child: Icon(_entry.mealType.icon,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          mealTypeLocalizedLabel(_entry.mealType, l10n)
                              .toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
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
                    if (widget.onEdit != null) ...[
                      const SizedBox(width: 4),
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        tooltip: l10n.historyEditButton,
                        onPressed: widget.onEdit,
                      ),
                    ],
                    if (widget.onDelete != null) ...[
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        tooltip: l10n.historyDeleteTooltip(
                          mealTypeLocalizedLabel(_entry.mealType, l10n),
                        ),
                        onPressed: widget.onDelete,
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
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ── Totals row ──
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.12)
                    : Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(AppDimens.radiusInput),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      l10n.historySubtotal,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.historyRationsCarbs(
                      _entry.totalRations.toStringAsFixed(1),
                      _entry.totalCarbs.toStringAsFixed(0),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // ── Fats (optional) ──
            if (_entry.totalFats != null && _entry.totalFats! > 0) ...[
              const SizedBox(height: 8),
              _macroBadge(context,
                  icon: Icons.opacity,
                  color: Colors.orange,
                  label: l10n.historyTotalFats,
                  value: '${_entry.totalFats!.toStringAsFixed(1)}g'),
            ],

            // ── Proteins (optional) ──
            if (_entry.totalProteins != null &&
                _entry.totalProteins! > 0) ...[
              const SizedBox(height: 8),
              _macroBadge(context,
                  icon: Icons.fitness_center,
                  color: Colors.blue,
                  label: l10n.historyTotalProteins,
                  value: '${_entry.totalProteins!.toStringAsFixed(1)}g'),
            ],

            // ── Glucose badge (optional) ──
            if (_entry.glucose != null) ...[
              const SizedBox(height: 8),
              _macroBadge(context,
                  icon: Icons.monitor_heart,
                  color: Colors.redAccent,
                  label: l10n.calcGlucoseLabel,
                  value: '${_entry.glucose!.toStringAsFixed(0)} mg/dL'),
            ],

            // ── Bolus badge (optional) ──
            if (_entry.totalBolus != null) ...[
              const SizedBox(height: 8),
              _macroBadge(context,
                  icon: Icons.water_drop,
                  color: Colors.orange,
                  label: l10n.historyBolus,
                  value: _entry.totalBolus! ==
                          _entry.totalBolus!.roundToDouble()
                      ? l10n.historyBolusUnits(
                          _entry.totalBolus!.round().toString())
                      : l10n.historyBolusUnits(
                          _entry.totalBolus!.toStringAsFixed(1))),
            ],

            // ── AI Advisor section ──
            const SizedBox(height: 12),
            if (analysis != null)
              _AiAnalysisPanel(
                analysis: analysis,
                analysisDate: _entry.aiAnalysisDate,
                onDelete: _deleteAnalysis,
                l10n: l10n,
                isDark: isDark,
              )
            else if (_isAnalyzing)
              _buildAnalyzingIndicator(l10n)
            else
              _buildAnalyzeButton(l10n, isDark),

            // Error message
            if (_errorMessage != null && !_isAnalyzing) ...[
              const SizedBox(height: 8),
              _buildErrorRow(l10n),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton(AppLocalizations l10n, bool isDark) {
    return ValueListenableBuilder<bool>(
      valueListenable: FoodPhotoAnalyzerService.apiKeyConfigured,
      builder: (context, hasKey, _) {
        if (!hasKey) {
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                ExcludeSemantics(
                  child: Icon(Icons.auto_awesome,
                      size: 14, color: AppColors.textMuted(context)),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.historyAiNoKey,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted(context),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Semantics(
          button: true,
          label: l10n.historyAiAnalyzeButton,
          child: OutlinedButton.icon(
            onPressed: _analyze,
            icon: const Icon(Icons.auto_awesome, size: 16),
            label: Text(
              l10n.historyAiAnalyzeButton,
              style: const TextStyle(fontSize: 13),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary(context),
              side: BorderSide(
                  color: AppColors.primary(context).withValues(alpha: 0.5)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusInput),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalyzingIndicator(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary(context),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            l10n.historyAiAnalyzing,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary(context),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorRow(AppLocalizations l10n) {
    return Row(
      children: [
        const Icon(Icons.error_outline, size: 14, color: Colors.redAccent),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            _errorMessage ?? l10n.historyAiError,
            style:
                const TextStyle(fontSize: 12, color: Colors.redAccent),
          ),
        ),
        TextButton(
          onPressed: _analyze,
          style: TextButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            visualDensity: VisualDensity.compact,
          ),
          child: Text(
            'Retry',
            style: TextStyle(
                fontSize: 12, color: AppColors.primary(context)),
          ),
        ),
      ],
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
                ExcludeSemantics(
                    child: Icon(icon, size: 14, color: color)),
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

// ─────────────────────────────────────────────────────────────────────────────
// AI Analysis Panel
// ─────────────────────────────────────────────────────────────────────────────

class _AiAnalysisPanel extends StatelessWidget {
  final MealAiAnalysis analysis;
  final DateTime? analysisDate;
  final VoidCallback onDelete;
  final AppLocalizations l10n;
  final bool isDark;

  const _AiAnalysisPanel({
    required this.analysis,
    required this.analysisDate,
    required this.onDelete,
    required this.l10n,
    required this.isDark,
  });

  Color get _profileColor {
    switch (analysis.glycemicProfile) {
      case GlycemicProfile.high:
        return Colors.redAccent;
      case GlycemicProfile.medium:
        return Colors.orange;
      case GlycemicProfile.low:
        return Colors.green;
      case GlycemicProfile.unknown:
        return Colors.grey;
    }
  }

  String _profileLabel() {
    switch (analysis.glycemicProfile) {
      case GlycemicProfile.high:
        return l10n.historyAiGlycemicHigh;
      case GlycemicProfile.medium:
        return l10n.historyAiGlycemicMedium;
      case GlycemicProfile.low:
        return l10n.historyAiGlycemicLow;
      case GlycemicProfile.unknown:
        return '–';
    }
  }

  IconData get _profileIcon {
    switch (analysis.glycemicProfile) {
      case GlycemicProfile.high:
        return Icons.trending_up;
      case GlycemicProfile.medium:
        return Icons.trending_flat;
      case GlycemicProfile.low:
        return Icons.trending_down;
      case GlycemicProfile.unknown:
        return Icons.help_outline;
    }
  }

  String _formatTimingMinutes() {
    final m = analysis.insulinTimingMinutes;
    if (m == 0) return '±0 min';
    return m < 0 ? '$m min' : '+$m min';
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary(context);
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? primary.withValues(alpha: 0.06)
            : primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header bar ──
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.10),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimens.radiusCard)),
            ),
            child: Row(
              children: [
                ExcludeSemantics(
                  child: Icon(Icons.auto_awesome, size: 14, color: primary),
                ),
                const SizedBox(width: 6),
                Text(
                  'IA',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: primary,
                    letterSpacing: 0.5,
                  ),
                ),
                if (analysisDate != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('d MMM HH:mm').format(analysisDate!),
                    style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted(context)),
                  ),
                ],
                const Spacer(),
                // Delete button
                Semantics(
                  button: true,
                  label: l10n.historyAiDeleteAnalysis,
                  child: InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(Icons.close,
                          size: 14,
                          color: AppColors.textMuted(context)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Glycemic profile badge ──
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _profileColor.withValues(
                            alpha: isDark ? 0.18 : 0.10),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color:
                                _profileColor.withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ExcludeSemantics(
                            child: Icon(_profileIcon,
                                size: 14, color: _profileColor),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${l10n.historyAiGlycemicProfile}: ${_profileLabel()}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _profileColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (analysis.glycemicSummary.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    analysis.glycemicSummary,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: isDark
                          ? Colors.grey.shade200
                          : Colors.grey.shade800,
                    ),
                  ),
                ],

                // ── Insulin timing ──
                if (analysis.insulinTiming.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(
                          alpha: isDark ? 0.12 : 0.07),
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusInput),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExcludeSemantics(
                          child: Icon(Icons.water_drop,
                              size: 15, color: Colors.blue.shade400),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    l10n.historyAiInsulinTiming,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blue.shade400,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.blue
                                          .withValues(alpha: 0.15),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _formatTimingMinutes(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                analysis.insulinTiming,
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.4,
                                  color: isDark
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ── Tips ──
                if (analysis.tips.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    l10n.historyAiTips,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary(context),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...analysis.tips.map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text('• ',
                                style: TextStyle(
                                    color: AppColors.primary(context),
                                    fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                tip,
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.4,
                                  color: isDark
                                      ? Colors.grey.shade200
                                      : Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],

                // ── Post-meal advice ──
                if (analysis.postMealAdvice.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(
                          alpha: isDark ? 0.10 : 0.06),
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusInput),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExcludeSemantics(
                          child: Icon(Icons.tips_and_updates,
                              size: 14, color: Colors.green.shade500),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.historyAiPostMeal,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green.shade500,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                analysis.postMealAdvice,
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.4,
                                  fontStyle: FontStyle.italic,
                                  color: isDark
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
