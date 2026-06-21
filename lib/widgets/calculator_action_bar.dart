import 'package:flutter/material.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_colors.dart';
import '../l10n/app_localizations.dart';

/// Bottom action bar for the calculator: search food and scan (AI photo) buttons.
class CalculatorActionBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onScanTap;

  const CalculatorActionBar({
    super.key,
    required this.onSearchTap,
    required this.onScanTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Food search button ──
        Semantics(
          button: true,
          label: l10n.calcSearchFoodAccessibility,
          child: InkWell(
            onTap: onSearchTap,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderSecondary(context)),
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                color: AppColors.surfaceBg(context),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.restaurant,
                    color: Theme.of(context).colorScheme.primary,
                    semanticLabel: l10n.calcFoodAccessibility,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.calcSearchFood,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const ExcludeSemantics(
                    child: Icon(Icons.search, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // ── Camera / AI scan button ──
        Semantics(
          button: true,
          label: l10n.photoCameraButton,
          child: InkWell(
            onTap: onScanTap,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary(context).withValues(alpha: 0.4),
                ),
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                color: AppColors.primary(context).withValues(alpha: 0.05),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: Icon(Icons.camera_alt, color: AppColors.primary(context), size: 22),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      l10n.photoCameraButton,
                      style: TextStyle(
                        color: AppColors.primary(context),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
