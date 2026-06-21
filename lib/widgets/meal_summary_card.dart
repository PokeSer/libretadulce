import 'package:flutter/material.dart';
import '../core/extensions/context_extensions.dart';
import '../core/theme/app_dimens.dart';
import '../l10n/app_localizations.dart';
import '../models/insulin_settings.dart';
import 'bolus_result_card.dart';
import 'glucose_input_field.dart';

/// Card displaying total carbs, total rations, optional bolus result,
/// and glucose input for the current meal plate.
class MealSummaryCard extends StatelessWidget {
  final double totalCarbs;
  final double totalRations;
  final double totalFats;
  final double totalProteins;
  final double? mealBolus;
  final double? correctionBolus;
  final TextEditingController glucoseController;
  final ValueChanged<String>? onGlucoseChanged;
  final InsulinSettings? insulinSettings;
  final bool settingsLoaded;
  final VoidCallback? onConfigureTap;

  const MealSummaryCard({
    super.key,
    required this.totalCarbs,
    required this.totalRations,
    this.totalFats = 0,
    this.totalProteins = 0,
    this.mealBolus,
    this.correctionBolus,
    required this.glucoseController,
    this.onGlucoseChanged,
    this.insulinSettings,
    this.settingsLoaded = false,
    this.onConfigureTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Totals card ──
        Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          decoration: BoxDecoration(
            color: isDark
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                : Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            border: Border.all(
              color: isDark
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.4)
                  : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: icon + title + rations
              Row(
                children: [
                  Icon(Icons.summarize, color: Theme.of(context).colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.calcTotalPlate,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.calcTotalRac(totalRations.toStringAsFixed(1)),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Row 2: macro pills
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _macroPill(
                    l10n.calcTotalHC(totalCarbs.toStringAsFixed(1)),
                    Theme.of(context).colorScheme.primary,
                    isDark,
                  ),
                  if (totalFats > 0)
                    _macroPill(
                      l10n.calcTotalFats(totalFats.toStringAsFixed(1)),
                      Colors.orange,
                      isDark,
                    ),
                  if (totalProteins > 0)
                    _macroPill(
                      l10n.calcTotalProteins(totalProteins.toStringAsFixed(1)),
                      Colors.blue,
                      isDark,
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // ── Bolus section (only when settings loaded) ──
        if (settingsLoaded && insulinSettings != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusDialog),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ExcludeSemantics(
                      child: Icon(Icons.water_drop, color: Theme.of(context).colorScheme.primary, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.calcBolusTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GlucoseInputField(
                  controller: glucoseController,
                  settings: insulinSettings!,
                  l10n: l10n,
                  onChanged: onGlucoseChanged,
                ),
                const SizedBox(height: 16),
                _buildBolusResult(l10n, insulinSettings!),
              ],
            ),
          ),
        ],
        if (settingsLoaded && insulinSettings == null)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const ExcludeSemantics(
                    child: Icon(Icons.water_drop, color: Colors.grey, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.calcConfigureMessage,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: onConfigureTap,
                    child: Text(l10n.calcConfigureButton),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBolusResult(AppLocalizations l10n, InsulinSettings settings) {
    if (mealBolus == null) {
      return Text(
        l10n.calcCalculating,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
      );
    }

    final total = settings.roundBolus(mealBolus! + (correctionBolus ?? 0));
    final bolusRounded = settings.roundBolus(mealBolus!);
    final correctionRounded = correctionBolus != null
        ? settings.roundBolus(correctionBolus!)
        : null;

    final unitSuffix = l10n.calcBolusUnitSuffix;

    return BolusResultCard(
      mealBolusLabel: l10n.calcBolusMeal,
      mealBolusValue: settings.formatBolus(bolusRounded),
      correctionLabel: l10n.calcBolusCorrection,
      correctionValue: correctionRounded != null
          ? settings.formatBolus(correctionRounded)
          : '--',
      totalLabel: l10n.calcBolusTotal,
      totalValue: settings.formatBolus(total),
      unitSuffix: unitSuffix,
      semanticsLabel:
          '${l10n.calcBolusMeal}: ${settings.formatBolus(bolusRounded)} $unitSuffix, '
          '${l10n.calcBolusCorrection}: ${correctionRounded != null ? settings.formatBolus(correctionRounded) : '--'} $unitSuffix, '
          '${l10n.calcBolusTotal}: ${settings.formatBolus(total)} $unitSuffix',
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
