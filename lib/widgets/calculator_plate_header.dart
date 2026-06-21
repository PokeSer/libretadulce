import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../l10n/app_localizations.dart';

/// Header row for the "My Plate" section: title + save template + clear.
class CalculatorPlateHeader extends StatelessWidget {
  final VoidCallback onSaveAsTemplate;
  final VoidCallback onClear;

  const CalculatorPlateHeader({
    super.key,
    required this.onSaveAsTemplate,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.calcMyPlate,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primary(context),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.bookmark_add_outlined, color: AppColors.primary(context)),
              tooltip: l10n.calcSaveAsTemplate,
              onPressed: onSaveAsTemplate,
            ),
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              label: Text(
                l10n.calcClear,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
