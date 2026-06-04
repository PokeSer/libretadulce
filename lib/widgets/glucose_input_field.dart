import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../l10n/app_localizations.dart';
import '../models/insulin_settings.dart';

/// Campo de entrada de glucosa reutilizable.
/// Reutilizado en calculator_page y history_page (edit dialog).
class GlucoseInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final InsulinSettings? settings;
  final AppLocalizations l10n;

  const GlucoseInputField({
    super.key,
    required this.controller,
    this.onChanged,
    this.settings,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: l10n.calcGlucoseLabel,
        hintText: l10n.calcGlucoseHint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        ),
        prefixIcon: const Icon(Icons.monitor_heart),
        suffixText: settings?.glucoseLabel() ?? l10n.calcGlucoseSuffix,
        filled: true,
        fillColor: AppColors.surfaceBg(context),
      ),
      onChanged: onChanged,
    );
  }
}
