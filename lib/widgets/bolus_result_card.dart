import 'package:flutter/material.dart';
import '../core/theme/app_dimens.dart';

/// Displays the 3-part insulin bolus breakdown:
/// Meal bolus | Correction | Total
///
/// Extracted from calculator_page.dart to reduce widget size.
class BolusResultCard extends StatelessWidget {
  final String mealBolusLabel;
  final String mealBolusValue;
  final String correctionLabel;
  final String correctionValue;
  final String totalLabel;
  final String totalValue;
  final String unitSuffix;
  final String semanticsLabel;

  const BolusResultCard({
    super.key,
    required this.mealBolusLabel,
    required this.mealBolusValue,
    required this.correctionLabel,
    required this.correctionValue,
    required this.totalLabel,
    required this.totalValue,
    required this.unitSuffix,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      liveRegion: true,
      label: semanticsLabel,
      child: Row(
        children: [
          Expanded(
            child: _bolusItem(
              mealBolusLabel,
              mealBolusValue,
              unitSuffix,
              Theme.of(context).colorScheme.primary,
              isDark,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _bolusItem(
              correctionLabel,
              correctionValue,
              unitSuffix,
              Colors.orange,
              isDark,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _bolusItem(
              totalLabel,
              totalValue,
              unitSuffix,
              Colors.redAccent,
              isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bolusItem(
    String label,
    String value,
    String unit,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 10,
              color: color.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
