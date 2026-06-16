import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Row of action buttons shown when the meal plate is empty:
/// "Repeat last meal" and "Load template".
class CalculatorEmptyPlateButtons extends StatelessWidget {
  final VoidCallback onRepeatLastMeal;
  final VoidCallback onLoadTemplate;

  const CalculatorEmptyPlateButtons({
    super.key,
    required this.onRepeatLastMeal,
    required this.onLoadTemplate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onRepeatLastMeal,
            icon: const Icon(Icons.replay, size: 18),
            label: Text(l10n.calcRepeatLastMealTooltip),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: Colors.teal,
              side: const BorderSide(color: Colors.teal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onLoadTemplate,
            icon: const Icon(Icons.bookmark_outline, size: 18),
            label: Text(l10n.calcLoadTemplate),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: Colors.teal,
              side: const BorderSide(color: Colors.teal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
