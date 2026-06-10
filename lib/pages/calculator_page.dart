import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/extensions/context_extensions.dart';
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
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/date_time_picker_tile.dart';
import '../widgets/food_search_sheet.dart';
import '../widgets/glucose_input_field.dart';
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
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  double _calculatedGrams = 0.0;
  double _totalCarbs = 0.0;
  double _totalRaciones = 0.0;

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
    if (_inputController.text.isEmpty || _selectedCarbsPer100g == 0.0) {
      setState(() {
        _calculatedGrams = 0.0;
        _totalCarbs = 0.0;
        _totalRaciones = 0.0;
      });
      return;
    }

    final double? inputVal = parseSpanishDecimal(_inputController.text);
    if (inputVal != null) {
      setState(() {
        if (!_isInverseMode) {
          _calculatedGrams = inputVal;
          _totalCarbs = (_selectedCarbsPer100g / 100) * inputVal;
          _totalRaciones = _totalCarbs / 10;
        } else {
          _totalRaciones = inputVal;
          _totalCarbs = inputVal * 10;
          _calculatedGrams = (_totalCarbs * 100) / _selectedCarbsPer100g;
        }
      });
    }
  }

  void _addToMeal() {
    if (_selectedFoodName != null && _calculatedGrams > 0) {
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
      _mealItems.fold(0.0, (acum, item) => acum + item['raciones']);
  double get _mealTotalCarbs =>
      _mealItems.fold(0.0, (acum, item) => acum + item['carbs']);

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
        _calculateMacros();
      });
    }
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
                return ListTile(
                  title: Text(mealTypeLocalizedLabel(type, l10n)),
                  onTap: () {
                    selectedMealType = type.rawValue;
                    Navigator.pop(ctx);
                  },
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

        double? totalBolus;
        double? glucoseMgdl;
        if (_insulinSettings != null) {
          final mealBolus = _insulinSettings!.calculateMealBolus(
            _mealTotalCarbs,
            mealType: mealTypeEnum,
          );
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
          items: _mealItems,
          totalBolus: totalBolus,
          glucose: glucoseMgdl,
          timestamp: _selectedTime,
        );

        if (mounted) {
          if (!MediaQuery.of(context).disableAnimations) {
            HapticFeedback.mediumImpact();
          }
          final localizedType = mealTypeLocalizedLabel(
            MealType.fromString(selectedMealType!),
            l10n,
          );
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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.calcSaveError(e.toString()))),
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

  Widget _buildBolusResult(bool isDark, AppLocalizations l10n) {
    final bolus = _calculateMealBolus();
    final correction = _calculateCorrection();

    if (_mealItems.isEmpty) {
      return Text(
        l10n.calcNoFoodsMessage,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
      );
    }

    if (_selectedMealType == null) {
      return Text(
        l10n.calcNoMealTypeMessage,
        style: TextStyle(color: Colors.orange.shade600, fontSize: 13),
      );
    }

    if (bolus == null) {
      return Text(
        l10n.calcCalculating,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
      );
    }

    final total = _insulinSettings!.roundBolus(bolus + (correction ?? 0));
    final bolusRounded = _insulinSettings!.roundBolus(bolus);
    final correctionRounded = correction != null
        ? _insulinSettings!.roundBolus(correction)
        : null;

    final unitSuffix = l10n.calcBolusUnitSuffix;

    return Semantics(
      liveRegion: true,
      label:
          '${l10n.calcBolusMeal}: ${_insulinSettings!.formatBolus(bolusRounded)} $unitSuffix, '
          '${l10n.calcBolusCorrection}: ${correctionRounded != null ? _insulinSettings!.formatBolus(correctionRounded) : '--'} $unitSuffix, '
          '${l10n.calcBolusTotal}: ${_insulinSettings!.formatBolus(total)} $unitSuffix',
      child: Row(
        children: [
          Expanded(
            child: _bolusItem(
              l10n.calcBolusMeal,
              _insulinSettings!.formatBolus(bolusRounded),
              unitSuffix,
              Colors.teal,
              isDark,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _bolusItem(
              l10n.calcBolusCorrection,
              correctionRounded != null
                  ? _insulinSettings!.formatBolus(correctionRounded)
                  : '--',
              unitSuffix,
              Colors.orange,
              isDark,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _bolusItem(
              l10n.calcBolusTotal,
              _insulinSettings!.formatBolus(total),
              unitSuffix,
              Colors.redAccent,
              isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bolusItem(
    String label,
    String value,
    String unit,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            unit,
            style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.7)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
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
    final isDark = context.isDarkMode;

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
                      final favFoods = snapshot.data ?? [];
                      if (favFoods.isEmpty) {
                        return const ExcludeSemantics(child: SizedBox.shrink());
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.calcFavoritesTitle,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 48,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: favFoods.length,
                              itemBuilder: (context, index) {
                                final food = favFoods[index];
                                final bool isSelected =
                                    _selectedFoodName == food.displayName;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Semantics(
                                    checked: isSelected,
                                    label: food.displayName,
                                    child: FilterChip(
                                      label: Text(
                                        food.displayName,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      selected: isSelected,
                                      visualDensity: VisualDensity.standard,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      onSelected: (_) {
                                        setState(() {
                                          _selectedFoodName = food.displayName;
                                          _selectedCarbsPer100g =
                                              food.carbsPer100g;
                                          _calculateMacros();
                                        });
                                      },
                                      backgroundColor: AppColors.surfaceAlt(
                                        context,
                                      ),
                                      selectedColor: Colors.teal.withValues(
                                        alpha: 0.25,
                                      ),
                                      checkmarkColor: Colors.teal,
                                      side: BorderSide(
                                        color: isSelected
                                            ? Colors.teal
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),

                  Semantics(
                    button: true,
                    label: _selectedFoodName != null
                        ? l10n.calcSelectedFood(_selectedFoodName!)
                        : l10n.calcSearchFoodAccessibility,
                    child: InkWell(
                      onTap: _openFoodSearchSheet,
                      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.borderSecondary(context),
                          ),
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusCard,
                          ),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedFoodName ?? l10n.calcSearchFood,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: _selectedFoodName != null
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: _selectedFoodName != null
                                          ? AppColors.textHeading(context)
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                  if (_selectedFoodName != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.calcCarbsPer100g(
                                        _selectedCarbsPer100g.toString(),
                                      ),
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ],
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

                  Container(
                    padding: AppDimens.screenPadding,
                    decoration: BoxDecoration(
                      color: !_isInverseMode
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.insulinGreen(context),
                      borderRadius: BorderRadius.circular(AppDimens.radiusXxl),
                    ),
                    child: Semantics(
                      liveRegion: true,
                      label: !_isInverseMode
                          ? '${l10n.calcGramsHC}: ${_totalCarbs.toStringAsFixed(1)}, ${l10n.calcRations}: ${_totalRaciones.toStringAsFixed(1)}'
                          : '${l10n.calcOfFood(_selectedFoodName ?? 'alimento')}: ${_calculatedGrams.toStringAsFixed(0)}g',
                      child: Column(
                        children: [
                          Text(
                            !_isInverseMode
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
                              if (!_isInverseMode) ...[
                                Column(
                                  children: [
                                    Text(
                                      _totalCarbs.toStringAsFixed(1),
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
                                Container(
                                  height: 60,
                                  width: 2,
                                  color: Colors.white30,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      _totalRaciones.toStringAsFixed(1),
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
                                      '${_calculatedGrams.toStringAsFixed(0)} g',
                                      style: const TextStyle(
                                        fontSize: 54,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      l10n.calcOfFood(
                                        _selectedFoodName ?? 'alimento',
                                      ),
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
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed:
                        (_selectedFoodName != null && _calculatedGrams > 0)
                        ? _addToMeal
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                    label: Text(
                      l10n.calcAddToPlate,
                      style: AppTextStyles.sectionTitle,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.teal.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusCard,
                        ),
                      ),
                    ),
                  ),

                  if (_mealItems.isEmpty) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _repeatLastMeal,
                            icon: const Icon(Icons.replay, size: 18),
                            label: Text(l10n.calcRepeatLastMealTooltip),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              foregroundColor: Colors.teal,
                              side: const BorderSide(color: Colors.teal),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusCard,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _loadTemplate,
                            icon: const Icon(Icons.bookmark_outline, size: 18),
                            label: Text(l10n.calcLoadTemplate),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              foregroundColor: Colors.teal,
                              side: const BorderSide(color: Colors.teal),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusCard,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (_mealItems.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Divider(thickness: 2),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.calcMyPlate,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.bookmark_add_outlined,
                                color: Colors.teal,
                              ),
                              tooltip: l10n.calcSaveAsTemplate,
                              onPressed: _saveAsTemplate,
                            ),
                            TextButton.icon(
                              onPressed: _clearMeal,
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              label: Text(
                                l10n.calcClear,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _mealItems.length,
                      itemBuilder: (context, index) {
                        final item = _mealItems[index];
                        return Dismissible(
                          key: ValueKey(item['id']),
                          direction: DismissDirection.endToStart,
                          dismissThresholds: const {
                            DismissDirection.endToStart: 0.2,
                          },
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(
                                AppDimens.radiusCard,
                              ),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const ExcludeSemantics(
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          confirmDismiss: (direction) =>
                              showConfirmDeleteDialog(
                                context,
                                title: l10n.calcDeleteFromPlate,
                                content: l10n.historyDeleteConfirm,
                              ),
                          onDismissed: (direction) => _removeMealItem(index),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: ExcludeSemantics(
                                child: Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              title: Text(
                                item['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                l10n.calcGramsConsumed(
                                  item['grams'].toStringAsFixed(0),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          l10n.calcRacShort(
                                            item['raciones'].toStringAsFixed(1),
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          l10n.calcHC(
                                            item['carbs'].toStringAsFixed(1),
                                          ),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.redAccent,
                                      size: 22,
                                    ),
                                    tooltip: l10n.calcDeleteFromPlate,
                                    onPressed: () => _removeMealItem(index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: AppDimens.cardPadding,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.teal.withValues(alpha: 0.1)
                            : Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusCard,
                        ),
                        border: Border.all(
                          color: isDark
                              ? Colors.teal.shade800
                              : Colors.teal.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              l10n.calcTotalPlate,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.teal,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                l10n.calcTotalRac(
                                  _mealTotalRaciones.toStringAsFixed(1),
                                ),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: isDark
                                      ? Colors.teal.shade200
                                      : Colors.teal.shade800,
                                ),
                              ),
                              Text(
                                l10n.calcTotalHC(
                                  _mealTotalCarbs.toStringAsFixed(1),
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.teal.shade300
                                      : Colors.teal.shade800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

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

                    if (_settingsLoaded && _insulinSettings != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg(context),
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusDialog,
                          ),
                          border: Border.all(
                            color: Colors.teal.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                const ExcludeSemantics(
                                  child: Icon(
                                    Icons.water_drop,
                                    color: Colors.teal,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.calcBolusTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GlucoseInputField(
                              controller: _glucosaController,
                              settings: _insulinSettings,
                              l10n: l10n,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16),
                            _buildBolusResult(isDark, l10n),
                          ],
                        ),
                      ),
                    ],
                    if (_settingsLoaded && _insulinSettings == null)
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusCard,
                          ),
                        ),
                        color: AppColors.surfaceBg(context),
                        child: Padding(
                          padding: AppDimens.cardPadding,
                          child: Row(
                            children: [
                              const ExcludeSemantics(
                                child: Icon(
                                  Icons.water_drop,
                                  color: Colors.grey,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l10n.calcConfigureMessage,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const InsulinSettingsPage(),
                                    ),
                                  ).then((_) => _loadInsulinSettings());
                                },
                                child: Text(l10n.calcConfigureButton),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _saveMealToHistory,
                      icon: const Icon(Icons.save),
                      label: Text(
                        l10n.calcSaveHistory,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusCard,
                          ),
                        ),
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
