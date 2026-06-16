import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/formatters.dart';
import '../models/food.dart';
import '../models/meal_type.dart';
import '../services/food_repository.dart';
import '../services/meal_history_service.dart';
import '../services/insulin_settings_service.dart';
import '../services/meal_template_service.dart';
import '../models/insulin_settings.dart';
import '../models/meal_template.dart';
import '../services/calculation_service.dart';
import '../widgets/calculator_action_bar.dart';
import '../widgets/calculator_empty_plate_buttons.dart';
import '../widgets/calculator_favorites_row.dart';
import '../widgets/calculator_plate_header.dart';
import '../widgets/calculator_result_display.dart';
import '../widgets/calculator_selected_food_info.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/date_time_picker_tile.dart';
import '../widgets/food_item_row.dart';
import '../widgets/food_photo_analyzer_sheet.dart';
import '../widgets/food_search_sheet.dart';
import '../widgets/meal_summary_card.dart';
import '../widgets/meal_type_chip_selector.dart';
import 'insulin_settings_page.dart';
import '../l10n/app_localizations.dart';
import '../core/utils/meal_type_localizer.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage>
    with TickerProviderStateMixin {
  final User? user = FirebaseAuth.instance.currentUser;

  late final TabController _tabController;
  bool _isInverseMode = false;

  String? _selectedFoodName;
  double _selectedCarbsPer100g = 0.0;
  double _selectedFatsPer100g = 0.0;
  double _selectedProteinsPer100g = 0.0;
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  double _calculatedGrams = 0.0;
  double _totalCarbs = 0.0;
  double _totalRaciones = 0.0;
  double _totalFats = 0.0;
  double _totalProteins = 0.0;

  final List<Map<String, dynamic>> _mealItems = [];
  int _mealItemCounter = 0;
  MealType? _selectedMealType;
  DateTime _selectedTime = DateTime.now();

  final TextEditingController _glucosaController = TextEditingController();
  InsulinSettings? _insulinSettings;
  bool _settingsLoaded = false;

  static const _prefsLastMealTypeKey = 'last_meal_type';

  Future<void> _loadLastMealType() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsLastMealTypeKey);
    if (raw != null && mounted) {
      final mealType = MealType.fromString(raw);
      setState(() => _selectedMealType = mealType);
    }
  }

  Future<void> _saveLastMealType(MealType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsLastMealTypeKey, type.rawValue);
  }

  void _calculateMacros() {
    if (_inputController.text.isEmpty) {
      setState(() {
        _calculatedGrams = 0.0;
        _totalCarbs = 0.0;
        _totalRaciones = 0.0;
        _totalFats = 0.0;
        _totalProteins = 0.0;
      });
      return;
    }

    final double? inputVal = parseSpanishDecimal(_inputController.text);
    if (inputVal != null) {
      setState(() {
        if (!_isInverseMode) {
          _calculatedGrams = inputVal;
          _totalCarbs = CalculationService.carbsFromGrams(
            _selectedCarbsPer100g,
            inputVal,
          );
          _totalRaciones = CalculationService.rationsFromCarbs(_totalCarbs);
          _totalFats = CalculationService.macroFromGrams(
            _selectedFatsPer100g,
            inputVal,
          );
          _totalProteins = CalculationService.macroFromGrams(
            _selectedProteinsPer100g,
            inputVal,
          );
        } else {
          // Inverse mode: only works if carbs per 100g > 0
          if (_selectedCarbsPer100g > 0) {
            _totalRaciones = inputVal;
            _totalCarbs = CalculationService.carbsFromRations(inputVal);
            _calculatedGrams = CalculationService.gramsFromCarbs(
              _totalCarbs,
              _selectedCarbsPer100g,
            );
            _totalFats = CalculationService.macroFromGrams(
              _selectedFatsPer100g,
              _calculatedGrams,
            );
            _totalProteins = CalculationService.macroFromGrams(
              _selectedProteinsPer100g,
              _calculatedGrams,
            );
          } else {
            // Can't calculate grams from raciones when carbs are 0
            _totalRaciones = 0.0;
            _totalCarbs = 0.0;
            _calculatedGrams = 0.0;
            _totalFats = 0.0;
            _totalProteins = 0.0;
          }
        }
      });
    }
  }

  bool get _canAddToMeal =>
      _selectedFoodName != null &&
      _calculatedGrams >= 0 &&
      _inputController.text.isNotEmpty;

  void _addToMeal() {
    if (_canAddToMeal) {
      if (!MediaQuery.of(context).disableAnimations) {
        HapticFeedback.lightImpact();
      }
      _inputFocusNode.unfocus();
      setState(() {
        _mealItems.add({
          'id': 'meal_${_mealItemCounter++}',
          'name': _selectedFoodName,
          'grams': _calculatedGrams,
          'carbs': _totalCarbs,
          'raciones': _totalRaciones,
          'fats': _totalFats,
          'proteins': _totalProteins,
        });
        _inputController.clear();
        _calculateMacros();
      });
    }
  }

  void _clearMeal() {
    final l10n = AppLocalizations.of(context);
    final savedItems = List<Map<String, dynamic>>.from(_mealItems);
    final savedMealType = _selectedMealType;
    _inputFocusNode.unfocus();
    setState(() {
      _mealItems.clear();
      _selectedMealType = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.calcClear),
        action: SnackBarAction(
          label: l10n.calcUndo,
          onPressed: () {
            setState(() {
              _mealItems.addAll(savedItems);
              _selectedMealType = savedMealType;
            });
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _removeMealItem(int index) {
    final l10n = AppLocalizations.of(context);
    final removedItem = _mealItems[index];
    setState(() {
      _mealItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.calcItemRemoved(removedItem['name'])),
        action: SnackBarAction(
          label: l10n.calcUndo,
          onPressed: () {
            setState(() {
              _mealItems.insert(index, removedItem);
            });
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  double get _mealTotalRaciones =>
      CalculationService.sumMealItems(_mealItems, 'raciones');
  double get _mealTotalCarbs =>
      CalculationService.sumMealItems(_mealItems, 'carbs');
  double get _mealTotalFats =>
      CalculationService.sumMealItems(_mealItems, 'fats');
  double get _mealTotalProteins =>
      CalculationService.sumMealItems(_mealItems, 'proteins');
  // ── Repeat last meal ──────────────────────────────────────────

  Future<void> _repeatLastMeal() async {
    if (user == null) return;
    final l10n = AppLocalizations.of(context);

    // Fetch recent meals and find one matching current meal type
    final entries = await MealHistoryService.fetchAll(user!.uid);
    if (entries.isEmpty) return;

    final targetType = _selectedMealType;
    MealEntry? lastMeal;

    if (targetType != null) {
      // Find last meal of the same type
      for (final e in entries.reversed) {
        if (e.mealType == targetType && e.items.isNotEmpty) {
          lastMeal = e;
          break;
        }
      }
    }
    // Fallback: last meal of any type
    lastMeal ??= entries.lastWhere(
      (e) => e.items.isNotEmpty,
      orElse: () => entries.last,
    );

    if (!mounted || lastMeal.items.isEmpty) return;

    _inputFocusNode.unfocus();
    setState(() {
      _mealItems.clear();
      for (final item in lastMeal!.items) {
        _mealItems.add({
          'id': 'meal_${_mealItemCounter++}',
          'name': item.name,
          'grams': item.grams,
          'carbs': item.carbs,
          'raciones': item.raciones,
        });
      }
      _selectedMealType ??= lastMeal.mealType;
    });

    final localizedType = mealTypeLocalizedLabel(lastMeal.mealType, l10n);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.calcRepeatLastMeal(localizedType)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Save as template ──────────────────────────────────────────

  Future<void> _saveAsTemplate() async {
    if (_mealItems.isEmpty || user == null) return;
    final l10n = AppLocalizations.of(context);

    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.calcSaveAsTemplate),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.calcTemplateNameHint,
              border: const OutlineInputBorder(),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return l10n.calcTemplateNameRequired;
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, true);
              }
            },
            child: Text(l10n.calcSaveAsTemplate),
          ),
        ],
      ),
    );

    if (saved == true && mounted) {
      final items = _mealItems
          .map(
            (item) => {
              'name': item['name'],
              'grams': item['grams'],
              'carbs': item['carbs'],
              'raciones': item['raciones'],
            },
          )
          .toList();

      await MealTemplateService.save(
        user!.uid,
        name: nameController.text.trim(),
        items: items,
        mealType: _selectedMealType?.rawValue,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.calcTemplateSaved)));
      }
    }
  }

  // ── Load template ─────────────────────────────────────────────

  Future<void> _loadTemplate() async {
    if (user == null) return;
    final l10n = AppLocalizations.of(context);

    final templates = await showDialog<MealTemplate>(
      context: context,
      builder: (ctx) => StreamBuilder<List<MealTemplate>>(
        stream: MealTemplateService.watchAll(user!.uid),
        builder: (context, snapshot) {
          final templates = snapshot.data ?? [];
          return AlertDialog(
            title: Text(l10n.calcLoadTemplate),
            content: SizedBox(
              width: double.maxFinite,
              child: templates.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        l10n.calcNoTemplates,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: templates.length,
                      itemBuilder: (context, index) {
                        final t = templates[index];
                        final carbs = t.items.fold<double>(
                          0,
                          (sum, i) => sum + (i['carbs'] as num).toDouble(),
                        );
                        return ListTile(
                          title: Text(t.name),
                          subtitle: Text(
                            '${t.items.length} items · ${carbs.toStringAsFixed(0)}g HC',
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                            tooltip: l10n.calcDeleteTemplate,
                            onPressed: () async {
                              final confirmed = await showConfirmDeleteDialog(
                                ctx,
                                content: l10n.calcDeleteTemplateConfirm(t.name),
                              );
                              if (confirmed == true) {
                                await MealTemplateService.delete(
                                  user!.uid,
                                  t.id,
                                );
                              }
                            },
                          ),
                          onTap: () => Navigator.pop(ctx, t),
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
              ),
            ],
          );
        },
      ),
    );

    if (templates != null && mounted) {
      _inputFocusNode.unfocus();
      setState(() {
        _mealItems.clear();
        for (final item in templates.items) {
          _mealItems.add({
            'id': 'meal_${_mealItemCounter++}',
            'name': item['name'],
            'grams': item['grams'],
            'carbs': item['carbs'],
            'raciones': item['raciones'],
          });
        }
        if (templates.mealType != null && _selectedMealType == null) {
          _selectedMealType = MealType.fromString(templates.mealType!);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.calcTemplateLoaded(templates.name)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _openFoodSearchSheet() async {
    final Food? selectedFood = await showModalBottomSheet<Food>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FoodSearchSheet(),
    );
    if (selectedFood != null) {
      setState(() {
        _selectedFoodName = selectedFood.displayName;
        _selectedCarbsPer100g = selectedFood.carbsPer100g;
        _selectedFatsPer100g = selectedFood.fatsPer100g ?? 0.0;
        _selectedProteinsPer100g = selectedFood.proteinsPer100g ?? 0.0;
        _calculateMacros();
      });
    }
  }

  void _openPhotoAnalyzer() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FoodPhotoAnalyzerSheet(
        onAddToPlate: (result) {
          final carbs = result.grams * result.carbsPer100g / 100;
          final raciones = carbs / 10.0;
          final fats = result.fatsPer100g != null ? result.grams * result.fatsPer100g! / 100 : 0.0;
          final proteins = result.proteinsPer100g != null ? result.grams * result.proteinsPer100g! / 100 : 0.0;

          setState(() {
            _mealItems.add({
              'id': 'meal_${_mealItemCounter++}',
              'name': result.name,
              'grams': result.grams,
              'carbs': carbs,
              'raciones': raciones,
              'fats': fats,
              'proteins': proteins,
            });
          });
        },
      ),
    );
  }

  Future<void> _saveMealToHistory() async {
    if (_mealItems.isEmpty || user == null) return;
    final l10n = AppLocalizations.of(context);

    String? selectedMealType;

    if (_selectedMealType != null) {
      selectedMealType = _selectedMealType!.rawValue;
    } else {
      final mealTypes = MealType.mealList;
      await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(l10n.calcSaveTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: mealTypes.map((type) {
                return Semantics(
                  button: true,
                  label: mealTypeLocalizedLabel(type, l10n),
                  child: ListTile(
                    title: Text(mealTypeLocalizedLabel(type, l10n)),
                    onTap: () {
                      selectedMealType = type.rawValue;
                      Navigator.pop(ctx);
                    },
                  ),
                );
              }).toList(),
            ),
          );
        },
      );
    }

    if (selectedMealType != null) {
      try {
        final mealTypeEnum = MealType.fromString(selectedMealType!);
        double? totalBolus, glucoseMgdl;
        if (_insulinSettings != null) {
          final mealBolus = _insulinSettings!.calculateMealBolus(_mealTotalCarbs, mealType: mealTypeEnum);
          final glucText = _glucosaController.text.trim();
          double correction = 0;
          if (glucText.isNotEmpty) {
            final gluc = double.tryParse(glucText);
            if (gluc != null) {
              glucoseMgdl = _insulinSettings!.toStoredGlucoseUnit(gluc);
              correction = _insulinSettings!.calculateCorrection(gluc);
            }
          }
          totalBolus = _insulinSettings!.roundBolus(mealBolus + correction);
        }

        await MealHistoryService.saveEntry(
          user!.uid,
          mealType: selectedMealType!,
          totalCarbs: _mealTotalCarbs,
          totalRations: _mealTotalRaciones,
          totalFats: _mealTotalFats,
          totalProteins: _mealTotalProteins,
          items: _mealItems,
          totalBolus: totalBolus,
          glucose: glucoseMgdl,
          timestamp: _selectedTime,
        );

        if (mounted) {
          if (!MediaQuery.of(context).disableAnimations) HapticFeedback.mediumImpact();
          final localizedType = mealTypeLocalizedLabel(MealType.fromString(selectedMealType!), l10n);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                totalBolus != null
                    ? l10n.calcSaveSuccessBolus(
                        localizedType,
                        _insulinSettings!.formatBolus(totalBolus),
                      )
                    : l10n.calcSaveSuccess(localizedType),
              ),
            ),
          );
          _inputFocusNode.unfocus();
          _clearMeal();
        }
      } catch (e) {
        debugPrint('[CalculatorPage._saveMealToHistory] Error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.calcSaveError(e.toString())),
              duration: const Duration(seconds: 6),
            ),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _isInverseMode = _tabController.index == 1;
          _calculateMacros();
        });
      }
    });
    _loadInsulinSettings();
    _loadLastMealType();
  }

  Future<void> _loadInsulinSettings() async {
    if (user == null) return;
    final settings = await InsulinSettingsService.getSettings(user!.uid);
    if (mounted) {
      setState(() {
        _insulinSettings = settings;
        _settingsLoaded = true;
      });
    }
  }

  double? _calculateMealBolus() {
    if (_insulinSettings == null || _mealTotalCarbs <= 0) return null;
    return _insulinSettings!.calculateMealBolus(
      _mealTotalCarbs,
      mealType: _selectedMealType,
    );
  }

  double? _calculateCorrection() {
    if (_insulinSettings == null) return null;
    final glucText = _glucosaController.text.trim();
    if (glucText.isEmpty) return null;
    final gluc = double.tryParse(glucText);
    if (gluc == null) return null;
    return _insulinSettings!.calculateCorrection(gluc);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inputController.dispose();
    _inputFocusNode.dispose();
    _glucosaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (user == null) return Center(child: Text(l10n.calcMustLogin));

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary(context),
          unselectedLabelColor: AppColors.textSecondary(context),
          indicatorColor: AppColors.primary(context),
          tabs: [
            Tab(
              icon: const ExcludeSemantics(child: Icon(Icons.scale)),
              text: l10n.calcTabGrams,
            ),
            Tab(
              icon: const ExcludeSemantics(child: Icon(Icons.restaurant_menu)),
              text: l10n.calcTabRations,
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: AppDimens.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StreamBuilder<List<Food>>(
                    stream: FoodRepository.watchFavoriteFoods(user!.uid),
                    builder: (context, snapshot) {
                      return CalculatorFavoritesRow(
                        favorites: snapshot.data ?? [],
                        selectedFoodName: _selectedFoodName,
                        onFoodSelected: (food) {
                          setState(() {
                            _selectedFoodName = food.displayName;
                            _selectedCarbsPer100g = food.carbsPer100g;
                            _selectedFatsPer100g = food.fatsPer100g ?? 0.0;
                            _selectedProteinsPer100g = food.proteinsPer100g ?? 0.0;
                            _calculateMacros();
                          });
                        },
                      );
                    },
                  ),

                  // ── Selected food info ──
                  if (_selectedFoodName != null) ...[
                    CalculatorSelectedFoodInfo(
                      foodName: _selectedFoodName!,
                      carbsPer100g: _selectedCarbsPer100g,
                    ),
                    const SizedBox(height: 12),
                  ],

                  CalculatorActionBar(
                    onSearchTap: _openFoodSearchSheet,
                    onScanTap: _openPhotoAnalyzer,
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller: _inputController,
                    focusNode: _inputFocusNode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (value) => _calculateMacros(),
                    enabled: _selectedFoodName != null,
                    decoration: InputDecoration(
                      labelText: !_isInverseMode
                          ? l10n.calcInputGramsLabel
                          : l10n.calcInputRationsLabel,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusCard,
                        ),
                      ),
                      prefixIcon: Icon(
                        !_isInverseMode ? Icons.scale : Icons.restaurant_menu,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      suffixText: !_isInverseMode
                          ? l10n.calcInputGramsSuffix
                          : l10n.calcInputRationsSuffix,
                      filled: true,
                      fillColor: _selectedFoodName == null
                          ? AppColors.surfaceAlt(context)
                          : (AppColors.surfaceBg(context)),
                    ),
                  ),

                  const SizedBox(height: 48),

                  CalculatorResultDisplay(
                    isInverseMode: _isInverseMode,
                    totalCarbs: _totalCarbs,
                    totalRaciones: _totalRaciones,
                    calculatedGrams: _calculatedGrams,
                    foodName: _selectedFoodName,
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: _canAddToMeal ? _addToMeal : null,
                    icon: const Icon(Icons.add_circle_outline),
                    label: Text(l10n.calcAddToPlate, style: AppTextStyles.sectionTitle),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.teal.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                      ),
                    ),
                  ),

                  if (_mealItems.isEmpty) ...[
                    const SizedBox(height: 16),
                    CalculatorEmptyPlateButtons(
                      onRepeatLastMeal: _repeatLastMeal,
                      onLoadTemplate: _loadTemplate,
                    ),
                  ],

                  if (_mealItems.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Divider(thickness: 2),
                    const SizedBox(height: 16),
                    CalculatorPlateHeader(
                      onSaveAsTemplate: _saveAsTemplate,
                      onClear: _clearMeal,
                    ),
                    const SizedBox(height: 8),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _mealItems.length,
                      itemBuilder: (context, index) {
                        final item = _mealItems[index];
                        return FoodItemRow(
                          itemId: item['id'] as String,
                          foodName: item['name'] as String,
                          grams: (item['grams'] as num).toDouble(),
                          carbs: (item['carbs'] as num).toDouble(),
                          rations: (item['raciones'] as num).toDouble(),
                          fats: item['fats'] as double?,
                          proteins: item['proteins'] as double?,
                          onDelete: () => _removeMealItem(index),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    MealTypeChipSelector(
                      selected: _selectedMealType,
                      onChanged: (type) {
                        setState(() => _selectedMealType = type);
                        _saveLastMealType(type);
                      },
                      l10n: l10n,
                    ),

                    const SizedBox(height: 12),
                    DateTimePickerTile(
                      selectedTime: _selectedTime,
                      onChanged: (dt) {
                        setState(() => _selectedTime = dt);
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      mode: PickerMode.date,
                      label: l10n.calcDateLabel,
                    ),
                    const SizedBox(height: 8),
                    DateTimePickerTile(
                      selectedTime: _selectedTime,
                      onChanged: (dt) {
                        setState(() => _selectedTime = dt);
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      mode: PickerMode.time,
                      label: l10n.calcTimeLabel,
                    ),

                    const SizedBox(height: 24),
                    MealSummaryCard(
                      totalCarbs: _mealTotalCarbs,
                      totalRations: _mealTotalRaciones,
                      totalFats: _mealTotalFats,
                      totalProteins: _mealTotalProteins,
                      mealBolus: _calculateMealBolus(),
                      correctionBolus: _calculateCorrection(),
                      glucoseController: _glucosaController,
                      onGlucoseChanged: (_) => setState(() {}),
                      insulinSettings: _insulinSettings,
                      settingsLoaded: _settingsLoaded,
                      onConfigureTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InsulinSettingsPage(),
                          ),
                        ).then((_) => _loadInsulinSettings());
                      },
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _saveMealToHistory,
                      icon: const Icon(Icons.save),
                      label: Text(l10n.calcSaveHistory, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusCard)),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ], // spread if _mealItems.isNotEmpty
                ], // inner Column children
              ), // Column
            ), // Padding
          ), // SingleChildScrollView
        ), // Expanded
      ], // outer Column children
    ); // Column
  }
}
