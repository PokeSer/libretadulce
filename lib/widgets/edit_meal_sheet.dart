import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import '../l10n/app_localizations.dart';
import '../models/food.dart';
import '../models/insulin_settings.dart';
import '../models/meal_type.dart';
import '../services/meal_history_service.dart';
import 'app_common_widgets.dart';
import 'date_time_picker_tile.dart';
import 'food_search_sheet.dart';
import 'glucose_input_field.dart';
import 'meal_type_chip_selector.dart';

/// Bottom sheet for editing a meal entry's items, meal type, timestamp and glucose.
class EditMealSheet extends StatefulWidget {
  final MealEntry entry;
  final InsulinSettings? settings;
  final String uid;
  final AppLocalizations l10n;
  final bool isDark;

  const EditMealSheet({
    super.key,
    required this.entry,
    required this.settings,
    required this.uid,
    required this.l10n,
    required this.isDark,
  });

  @override
  State<EditMealSheet> createState() => _EditMealSheetState();
}

class _EditMealSheetState extends State<EditMealSheet> {
  static const _hcPerRation = 10.0;

  late MealType _mealType;
  late DateTime _selectedTime;
  late double? _editedGlucose;
  late final List<Map<String, dynamic>> _editableItems;
  late final List<TextEditingController> _gramsControllers;
  bool _saving = false;
  late final TextEditingController _glucoseController;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _mealType = entry.mealType;
    _selectedTime = entry.timestamp;
    _editedGlucose = entry.glucose;

    _editableItems = entry.items.map((i) {
      return {
        'name': i.name,
        'grams': i.grams,
        'carbsPer100g': i.grams > 0 ? (i.carbs / i.grams * 100) : 0.0,
      };
    }).toList();

    _gramsControllers = _editableItems
        .map((i) => TextEditingController(text: (i['grams'] as double).toStringAsFixed(0)))
        .toList();

    final g = entry.glucose;
    String glucoseText = '';
    if (g != null) {
      if (widget.settings != null) {
        glucoseText = widget.settings!.fromStoredGlucoseUnit(g).toStringAsFixed(0);
      } else {
        glucoseText = g.toStringAsFixed(0);
      }
    }
    _glucoseController = TextEditingController(text: glucoseText);
  }

  @override
  void dispose() {
    for (final c in _gramsControllers) { c.dispose(); }
    _glucoseController.dispose();
    super.dispose();
  }

  double _itemCarbs(int idx) {
    final item = _editableItems[idx];
    return (item['grams'] as double) * (item['carbsPer100g'] as double) / 100;
  }

  double get _totalCarbs {
    double t = 0;
    for (int i = 0; i < _editableItems.length; i++) { t += _itemCarbs(i); }
    return t;
  }

  double get _totalRations => _totalCarbs / _hcPerRation;

  Future<void> _addFood() async {
    final Food? food = await showModalBottomSheet<Food>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FoodSearchSheet(),
    );
    if (food == null || !mounted) return;
    setState(() {
      _editableItems.add({'name': food.displayName, 'grams': 100.0, 'carbsPer100g': food.carbsPer100g});
      _gramsControllers.add(TextEditingController(text: '100'));
    });
  }

  void _removeItem(int idx) {
    setState(() {
      _editableItems.removeAt(idx);
      _gramsControllers[idx].dispose();
      _gramsControllers.removeAt(idx);
    });
  }

  Future<void> _save() async {
    if (_editableItems.isEmpty || _saving) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final updatedItems = _editableItems.map((item) {
        final g = item['grams'] as double;
        final cp100 = item['carbsPer100g'] as double;
        final c = g * cp100 / 100;
        return {'name': item['name'], 'grams': g, 'carbs': c, 'raciones': c / _hcPerRation};
      }).toList();

      await MealHistoryService.updateEntry(widget.uid, widget.entry.id,
        mealType: _mealType.rawValue, totalCarbs: _totalCarbs,
        totalRations: _totalRations, items: updatedItems,
        glucose: _editedGlucose, timestamp: _selectedTime);

      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(SnackBar(content: Text(widget.l10n.historyEditSuccess), duration: const Duration(seconds: 2)));
      }
    } catch (e) {
      debugPrint('[EditMealSheet._save] Error: $e');
      if (mounted) {
        setState(() => _saving = false);
        messenger.showSnackBar(SnackBar(content: Text(widget.l10n.serviceError), duration: const Duration(seconds: 6)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final isDark = widget.isDark;

    return DraggableScrollableSheet(
      initialChildSize: 0.85, minChildSize: 0.5, maxChildSize: 0.95, expand: false,
      builder: (ctx, scrollController) {
        return SingleChildScrollView(
          controller: scrollController, padding: AppDimens.screenPadding,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(l10n.historyEditTitle, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary(context))),
              IconButton(icon: const Icon(Icons.close), tooltip: MaterialLocalizations.of(ctx).closeButtonLabel, onPressed: () => Navigator.of(ctx).pop()),
            ]),
            const SizedBox(height: 20),
            MealTypeChipSelector(selected: _mealType, onChanged: (type) => setState(() => _mealType = type), l10n: l10n),
            const SizedBox(height: 16),
            DateTimePickerTile(selectedTime: _selectedTime, onChanged: (dt) => setState(() => _selectedTime = dt), mode: PickerMode.date, label: l10n.calcDateLabel),
            const SizedBox(height: 8),
            DateTimePickerTile(selectedTime: _selectedTime, onChanged: (dt) => setState(() => _selectedTime = dt), mode: PickerMode.time, label: l10n.calcTimeLabel),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(l10n.calcMyPlate, style: AppTextStyles.sectionTitle.copyWith(color: AppColors.primary(context))),
              Semantics(button: true, label: l10n.calcAddToPlate, child: TextButton.icon(
                onPressed: _addFood, icon: Icon(Icons.add_circle_outline, color: AppColors.primary(context)),
                label: Text(l10n.calcAddToPlate, style: TextStyle(color: AppColors.primary(context), fontSize: 13)))),
            ]),
            const SizedBox(height: 8),
            ..._editableItems.asMap().entries.map((e) {
              final idx = e.key;
              final item = _editableItems[idx];
              final grams = item['grams'] as double;
              final carbsPer100 = item['carbsPer100g'] as double;
              final carbs = grams * carbsPer100 / 100;
              final rations = carbs / _hcPerRation;
              return Padding(padding: const EdgeInsets.only(bottom: 8), child: Container(
                decoration: BoxDecoration(color: isDark ? Colors.grey.shade900 : Colors.grey.shade50, borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                  border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200)), clipBehavior: Clip.antiAlias,
                child: Padding(padding: const EdgeInsets.fromLTRB(12, 10, 4, 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Icon(Icons.check_circle, size: 18, color: Theme.of(context).colorScheme.primary), const SizedBox(width: 8),
                    Expanded(child: Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis)),
                    Text(l10n.calcRacShort(rations.toStringAsFixed(1)), style: TextStyle(fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary, fontSize: 15)),
                    IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20), tooltip: l10n.calcDeleteFromPlate, visualDensity: VisualDensity.compact, onPressed: () => _removeItem(idx)),
                  ]),
                  Padding(padding: const EdgeInsets.only(left: 26, top: 2), child: Row(children: [
                    SizedBox(width: 100, child: TextField(
                      decoration: InputDecoration(labelText: l10n.historyEditGramsLabel, suffixText: 'g', border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimens.radiusInput)),
                        isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true), controller: _gramsControllers[idx],
                      onChanged: (v) { final val = double.tryParse(v); if (val != null && val > 0) setState(() => _editableItems[idx]['grams'] = val); })),
                    const SizedBox(width: 10),
                    _macroPill(l10n.calcHC(carbs.toStringAsFixed(1)), AppColors.primary(context), isDark),
                  ])),
                ])),
              ));
            }),
            const SizedBox(height: 16),
            GlucoseInputField(controller: _glucoseController, settings: widget.settings, l10n: l10n,
              onChanged: (v) { final val = double.tryParse(v); if (val != null) setState(() => _editedGlucose = widget.settings?.toStoredGlucoseUnit(val) ?? val); }),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Expanded(child: StatCard(title: l10n.calcRations, value: _totalRations.toStringAsFixed(1), color: Colors.amber.shade800, isDark: isDark)),
              const SizedBox(width: 12),
              Expanded(child: StatCard(title: l10n.calcGramsHC, value: '${_totalCarbs.toStringAsFixed(1)}g', color: AppColors.primary(context), isDark: isDark)),
            ]),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: (_editableItems.isEmpty || _saving) ? null : _save,
              icon: const Icon(Icons.save), label: Text(l10n.historyEditSave, style: AppTextStyles.sectionTitle),
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: AppColors.primary(context),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusCard)))),
            const SizedBox(height: 16),
          ]),
        );
      },
    );
  }

  Widget _macroPill(String text, Color color, bool isDark) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: isDark ? 0.15 : 0.08), borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: color)));
  }
}
