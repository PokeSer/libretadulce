import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/meal_type_localizer.dart';
import '../l10n/app_localizations.dart';
import '../models/insulin_settings.dart';
import '../models/meal_type.dart';
import '../services/insulin_settings_service.dart';

class InsulinSettingsPage extends StatefulWidget {
  const InsulinSettingsPage({super.key});

  @override
  State<InsulinSettingsPage> createState() => _InsulinSettingsPageState();
}

class _InsulinSettingsPageState extends State<InsulinSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final User? _user = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _showMealRatios = false;
  bool _supportsHalfUnits = true;
  bool _roundBolusDown = false;
  bool _usesMmolL = false;

  late TextEditingController _ratioBaseCtrl;
  late TextEditingController _ratioDesayunoCtrl;
  late TextEditingController _ratioMediaMananaCtrl;
  late TextEditingController _ratioAlmuerzoCtrl;
  late TextEditingController _ratioMeriendaCtrl;
  late TextEditingController _ratioCenaCtrl;
  late TextEditingController _ratioSnackCtrl;
  late TextEditingController _factorCorreccionCtrl;
  late TextEditingController _glucosaObjetivoCtrl;

  @override
  void initState() {
    super.initState();
    _ratioBaseCtrl = TextEditingController();
    _ratioDesayunoCtrl = TextEditingController();
    _ratioMediaMananaCtrl = TextEditingController();
    _ratioAlmuerzoCtrl = TextEditingController();
    _ratioMeriendaCtrl = TextEditingController();
    _ratioCenaCtrl = TextEditingController();
    _ratioSnackCtrl = TextEditingController();
    _factorCorreccionCtrl = TextEditingController();
    _glucosaObjetivoCtrl = TextEditingController();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    if (_user == null) return;
    final settings = await InsulinSettingsService.getSettings(_user.uid);
    if (mounted) {
      setState(() {
        if (settings != null) {
          _ratioBaseCtrl.text = settings.ratioBase.toString();
          _factorCorreccionCtrl.text = settings.factorCorreccion.toString();
          _glucosaObjetivoCtrl.text = settings.glucosaObjetivo.toString();
          _supportsHalfUnits = settings.supportsHalfUnits;
          _roundBolusDown = settings.roundBolusDown;
          _usesMmolL = settings.usesMmolL;
          if (settings.ratioDesayuno != null) {
            _ratioDesayunoCtrl.text = settings.ratioDesayuno.toString();
            _showMealRatios = true;
          }
          _ratioMediaMananaCtrl.text = settings.ratioMediaManana?.toString() ?? '';
          _ratioAlmuerzoCtrl.text = settings.ratioAlmuerzo?.toString() ?? '';
          _ratioMeriendaCtrl.text = settings.ratioMerienda?.toString() ?? '';
          _ratioCenaCtrl.text = settings.ratioCena?.toString() ?? '';
          _ratioSnackCtrl.text = settings.ratioSnack?.toString() ?? '';
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _user == null) return;

    setState(() => _isSaving = true);

    final ratioBase = parseSpanishDecimal(_ratioBaseCtrl.text.trim());
    final factorCorreccion = parseSpanishDecimal(_factorCorreccionCtrl.text.trim());
    final glucosaObjetivo = parseSpanishDecimal(_glucosaObjetivoCtrl.text.trim());
    if (ratioBase == null || factorCorreccion == null || glucosaObjetivo == null) return;

    final settings = InsulinSettings(
      ratioBase: ratioBase,
      ratioDesayuno: _tryParse(_ratioDesayunoCtrl),
      ratioMediaManana: _tryParse(_ratioMediaMananaCtrl),
      ratioAlmuerzo: _tryParse(_ratioAlmuerzoCtrl),
      ratioMerienda: _tryParse(_ratioMeriendaCtrl),
      ratioCena: _tryParse(_ratioCenaCtrl),
      ratioSnack: _tryParse(_ratioSnackCtrl),
      factorCorreccion: factorCorreccion,
      glucosaObjetivo: glucosaObjetivo,
      supportsHalfUnits: _supportsHalfUnits,
      roundBolusDown: _roundBolusDown,
      usesMmolL: _usesMmolL,
    );

    try {
      await InsulinSettingsService.saveSettings(_user.uid, settings);

      if (mounted) {
        final l10n = AppLocalizations.of(context);
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.insulinSaved)),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('[InsulinSettingsPage._save] Error: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.serviceError),
            duration: const Duration(seconds: 6),
          ),
        );
      }
    }
  }

  double? _tryParse(TextEditingController ctrl) {
    return parseSpanishDecimal(ctrl.text.trim());
  }

  @override
  void dispose() {
    _ratioBaseCtrl.dispose();
    _ratioDesayunoCtrl.dispose();
    _ratioMediaMananaCtrl.dispose();
    _ratioAlmuerzoCtrl.dispose();
    _ratioMeriendaCtrl.dispose();
    _ratioCenaCtrl.dispose();
    _ratioSnackCtrl.dispose();
    _factorCorreccionCtrl.dispose();
    _glucosaObjetivoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Semantics(
            label: l10n.insulinTitle,
            child: CircularProgressIndicator(color: AppColors.primary(context)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.insulinTitle),
      ),
      body: SingleChildScrollView(
        padding: AppDimens.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.insulinDesc,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary(context), height: 1.5),
              ),
              const SizedBox(height: 24),

              Text(
                l10n.insulinRatioTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark(context),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _ratioBaseCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.insulinRatioBase,
                  hintText: l10n.insulinRatioHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.water_drop),
                  suffixText: l10n.insulinRatioSuffix,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return l10n.insulinRatioRequired;
                  if (double.tryParse(v.trim()) == null) return l10n.insulinInvalidNumber;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Semantics(
                button: true,
                label: l10n.insulinMealRatios,
                expanded: _showMealRatios,
                child: InkWell(
                  onTap: () => setState(() => _showMealRatios = !_showMealRatios),
                  child: Row(
                    children: [
                      ExcludeSemantics(
                        child: Icon(
                          _showMealRatios ? Icons.expand_less : Icons.expand_more,
                          color: AppColors.primary(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.insulinMealRatios,
                        style: TextStyle(color: AppColors.primaryDark(context), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showMealRatios) ...[
                const SizedBox(height: 12),
                _mealRatioField(
                  mealTypeLocalizedLabel(MealType.desayuno, l10n),
                  _ratioDesayunoCtrl,
                  MealType.desayuno.icon,
                  l10n,
                ),
                _mealRatioField(
                  mealTypeLocalizedLabel(MealType.mediaManana, l10n),
                  _ratioMediaMananaCtrl,
                  MealType.mediaManana.icon,
                  l10n,
                ),
                _mealRatioField(
                  mealTypeLocalizedLabel(MealType.almuerzo, l10n),
                  _ratioAlmuerzoCtrl,
                  MealType.almuerzo.icon,
                  l10n,
                ),
                _mealRatioField(
                  mealTypeLocalizedLabel(MealType.merienda, l10n),
                  _ratioMeriendaCtrl,
                  MealType.merienda.icon,
                  l10n,
                ),
                _mealRatioField(
                  mealTypeLocalizedLabel(MealType.cena, l10n),
                  _ratioCenaCtrl,
                  MealType.cena.icon,
                  l10n,
                ),
                _mealRatioField(
                  mealTypeLocalizedLabel(MealType.snack, l10n),
                  _ratioSnackCtrl,
                  MealType.snack.icon,
                  l10n,
                ),
              ],

              const SizedBox(height: 24),
              Text(
                l10n.insulinFactorTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark(context),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _factorCorreccionCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.insulinFactorLabel,
                  hintText: l10n.insulinFactorHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.trending_down),
                  suffixText: _usesMmolL ? 'mmol/L por ud' : l10n.insulinFactorSuffix,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return l10n.insulinFactorRequired;
                  final val = double.tryParse(v.trim());
                  if (val == null) return l10n.insulinInvalidNumber;
                  if (val <= 0) return l10n.insulinMustBePositive;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _glucosaObjetivoCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.insulinGlucoseTargetLabel,
                  hintText: l10n.insulinGlucoseTargetHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.track_changes),
                  suffixText: _usesMmolL ? 'mmol/L' : l10n.insulinGlucoseTargetSuffix,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return l10n.insulinGlucoseTargetRequired;
                  final val = double.tryParse(v.trim());
                  if (val == null) return l10n.insulinInvalidNumber;
                  if (val <= 0) return l10n.insulinMustBePositive;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                title: Text(l10n.insulinHalfUnits),
                subtitle: Text(l10n.insulinHalfUnitsDesc),
                value: _supportsHalfUnits,
                activeTrackColor: AppColors.primaryLight(context),
                activeThumbColor: AppColors.primary(context),
                onChanged: (v) => setState(() => _supportsHalfUnits = v),
              ),

              const SizedBox(height: 8),
              SwitchListTile(
                title: Text(l10n.insulinRoundDown),
                subtitle: Text(l10n.insulinRoundDownDesc),
                value: _roundBolusDown,
                activeTrackColor: AppColors.primaryLight(context),
                activeThumbColor: AppColors.primary(context),
                onChanged: (v) => setState(() => _roundBolusDown = v),
              ),

              const Divider(height: 32),

              Text(
                l10n.insulinGlucoseUnit,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark(context),
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: Text(l10n.insulinGlucoseUnitDesc),
                subtitle: Text(l10n.insulinGlucoseUnitLabel),
                value: _usesMmolL,
                activeTrackColor: AppColors.primaryLight(context),
                activeThumbColor: AppColors.primary(context),
                onChanged: (v) => setState(() => _usesMmolL = v),
              ),

              const SizedBox(height: 32),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: _isSaving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary(context)),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _isSaving ? l10n.insulinSaving : l10n.insulinSave,
                    style: AppTextStyles.sectionTitle,
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary(context),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusCard)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mealRatioField(
    String label,
    TextEditingController ctrl,
    IconData icon,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: l10n.insulinOptionalHint,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon, size: 20),
          suffixText: l10n.insulinRatioSuffix,
        ),
      ),
    );
  }
}
