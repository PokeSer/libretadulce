import 'package:flutter/material.dart';
import '../core/theme/app_dimens.dart';

/// Displays the 3-part insulin bolus breakdown:
/// Meal bolus | Correction | Total
///
/// One quiet panel divided by hairlines — a dose scale, not three boxes.
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
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      liveRegion: true,
      label: semanticsLabel,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          children: [
            Expanded(
              child: _bolusItem(
                context,
                mealBolusLabel,
                mealBolusValue,
                scheme.onSurface,
              ),
            ),
            _divider(scheme),
            Expanded(
              child: _bolusItem(
                context,
                correctionLabel,
                correctionValue,
                scheme.tertiary,
              ),
            ),
            _divider(scheme),
            Expanded(
              child: _bolusItem(
                context,
                totalLabel,
                totalValue,
                scheme.primary,
                emphasized: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(ColorScheme scheme) =>
      Container(width: 1, height: 52, color: scheme.outlineVariant);

  Widget _bolusItem(
    BuildContext context,
    String label,
    String value,
    Color color, {
    bool emphasized = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1,
            color: emphasized ? color : scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: emphasized ? 26 : 22,
            height: 1.1,
            fontFeatures: const [FontFeature.tabularFigures()],
            fontWeight: FontWeight.w600,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          unitSuffix,
          style: TextStyle(
            fontSize: 10,
            fontFeatures: const [FontFeature.tabularFigures()],
            color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
