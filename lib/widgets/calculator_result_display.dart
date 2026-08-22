import 'package:flutter/material.dart';
import '../core/theme/app_dimens.dart';
import '../l10n/app_localizations.dart';

/// The dose window: the calculated macros rendered as magnified instrument
/// digits inside a quiet green field, with the tick ruler as its scale.
class CalculatorResultDisplay extends StatelessWidget {
  final bool isInverseMode;
  final double totalCarbs;
  final double totalRaciones;
  final double calculatedGrams;
  final String? foodName;

  const CalculatorResultDisplay({
    super.key,
    required this.isInverseMode,
    required this.totalCarbs,
    required this.totalRaciones,
    required this.calculatedGrams,
    this.foodName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: AppDimens.screenPadding,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusXxl),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.35)),
      ),
      child: Semantics(
        liveRegion: true,
        label: !isInverseMode
            ? '${l10n.calcGramsHC}: ${totalCarbs.toStringAsFixed(1)}, ${l10n.calcRations}: ${totalRaciones.toStringAsFixed(1)}'
            : '${l10n.calcOfFood(foodName ?? 'alimento')}: ${calculatedGrams.toStringAsFixed(0)}g',
        child: Column(
          children: [
            Text(
              !isInverseMode
                  ? l10n.calcResultTitle
                  : l10n.calcResultInverseTitle,
              style: TextStyle(
                color: scheme.onPrimaryContainer.withValues(alpha: 0.75),
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isInverseMode) ...[
                  _DoseColumn(
                    value: totalCarbs.toStringAsFixed(1),
                    unitLabel: l10n.calcGramsHC,
                  ),
                  Container(height: 64, width: 1, color: scheme.primary.withValues(alpha: 0.3)),
                  _DoseColumn(
                    value: totalRaciones.toStringAsFixed(1),
                    unitLabel: l10n.calcRations,
                    emphasized: true,
                  ),
                ] else ...[
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          calculatedGrams.toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 54,
                            height: 1.05,
                            fontWeight: FontWeight.w600,
                            fontFeatures: const [
                              FontFeature.tabularFigures(),
                            ],
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          l10n.calcOfFood(foodName ?? 'alimento'),
                          style: TextStyle(
                            color: scheme.onPrimaryContainer.withValues(alpha: 0.75),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 18),
            ExcludeSemantics(
              child: SizedBox(
                height: 8,
                width: double.infinity,
                child: CustomPaint(painter: _TickRulerPainter(scheme)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoseColumn extends StatelessWidget {
  final String value;
  final String unitLabel;
  final bool emphasized;

  const _DoseColumn({
    required this.value,
    required this.unitLabel,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: emphasized ? 56 : 48,
            height: 1.05,
            fontFeatures: const [FontFeature.tabularFigures()],
            fontWeight: FontWeight.w600,
            color: emphasized
                ? scheme.onPrimaryContainer
                : scheme.onPrimaryContainer.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          unitLabel,
          style: TextStyle(
            color: scheme.onPrimaryContainer.withValues(alpha: 0.75),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// The instrument's scale strip: fine ticks with every fifth raised.
class _TickRulerPainter extends CustomPainter {
  final ColorScheme scheme;

  _TickRulerPainter(this.scheme);

  @override
  void paint(Canvas canvas, Size size) {
    final tick = Paint()
      ..color = scheme.onPrimaryContainer.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    const spacing = 12.0;
    var x = 4.0;
    var i = 0;
    while (x < size.width - 2) {
      final tall = i % 5 == 0;
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x, size.height - (tall ? size.height : size.height * 0.5)),
        tick,
      );
      x += spacing;
      i++;
    }
  }

  @override
  bool shouldRepaint(covariant _TickRulerPainter oldDelegate) =>
      oldDelegate.scheme != scheme;
}
