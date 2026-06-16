import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';
import '../l10n/app_localizations.dart';
import '../models/food.dart';

/// Bottom sheet for adding or editing a food.
/// [initial] is null for add mode, non-null for edit mode.
class FoodFormSheet extends StatefulWidget {
  final Food? initial;
  final ValueChanged<Food> onSave;

  const FoodFormSheet({
    super.key,
    this.initial,
    required this.onSave,
  });

  @override
  State<FoodFormSheet> createState() => _FoodFormSheetState();
}

class _FoodFormSheetState extends State<FoodFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _carbsController;
  late final TextEditingController _kcalController;
  late final TextEditingController _proteinsController;
  late final TextEditingController _fatsController;

  bool get _isEditMode => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final food = widget.initial;
    _nameController = TextEditingController(text: food?.name ?? '');
    _brandController = TextEditingController(text: food?.brand ?? '');
    _carbsController = TextEditingController(
      text: food != null ? food.carbsPer100g.toStringAsFixed(1) : '',
    );
    _kcalController = TextEditingController(
      text: food?.kcalPer100g?.toStringAsFixed(0) ?? '',
    );
    _proteinsController = TextEditingController(
      text: food?.proteinsPer100g?.toStringAsFixed(1) ?? '',
    );
    _fatsController = TextEditingController(
      text: food?.fatsPer100g?.toStringAsFixed(1) ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _carbsController.dispose();
    _kcalController.dispose();
    _proteinsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final l10n = AppLocalizations.of(context);

    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.foodsNameRequired)),
      );
      return;
    }
    if (_carbsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.foodsCarbsRequired)),
      );
      return;
    }

    final carbs = parseSpanishDecimal(_carbsController.text);
    final kcal = parseSpanishDecimal(_kcalController.text);
    final proteins = parseSpanishDecimal(_proteinsController.text);
    final fats = parseSpanishDecimal(_fatsController.text);

    if (carbs == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.foodsCarbsInvalid)),
      );
      return;
    }

    final food = Food(
      id: widget.initial?.id ?? '',
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      carbsPer100g: carbs,
      kcalPer100g: kcal,
      proteinsPer100g: proteins,
      fatsPer100g: fats,
    );

    widget.onSave(food);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _isEditMode ? l10n.foodsDetailTitle : l10n.foodsAddTitle,
            style: TextStyle(color: AppColors.primary(context)),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            autofillHints: const [AutofillHints.name],
            decoration: InputDecoration(
              labelText: l10n.foodsNameLabel,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.apple),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _brandController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: l10n.foodsBrandLabel,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.storefront),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _carbsController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.foodsCarbsLabel,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.scale),
              suffixText: l10n.foodsCarbsSuffix,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _kcalController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.foodsKcalLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _proteinsController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.foodsProteinLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _fatsController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.foodsFatLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.foodsCancel,
            style: TextStyle(color: AppColors.textMuted(context)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _handleSave();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary(context),
          ),
          child: Text(
            l10n.foodsSave,
            style: TextStyle(color: AppColors.onPrimary(context)),
          ),
        ),
      ],
    );
  }
}
