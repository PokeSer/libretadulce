import 'package:flutter/material.dart';
import '../core/theme/app_dimens.dart';
import '../l10n/app_localizations.dart';

/// Displays the calculated macros result (carbs + rations in normal mode,
/// grams of food in inverse mode).
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

    return Container(
      padding: AppDimens.screenPadding,
      decoration: BoxDecoration(
        color: !isInverseMode
            ? Theme.of(context).colorScheme.primary
            : const Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(AppDimens.radiusXxl),
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
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (!isInverseMode) ...[
                  Column(
                    children: [
                      Text(
                        totalCarbs.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        l10n.calcGramsHC,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(height: 60, width: 2, color: Colors.white30),
                  Column(
                    children: [
                      Text(
                        totalRaciones.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.amberAccent,
                        ),
                      ),
                      Text(
                        l10n.calcRations,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Column(
                    children: [
                      Text(
                        '${calculatedGrams.toStringAsFixed(0)} g',
                        style: const TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        l10n.calcOfFood(foodName ?? 'alimento'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
