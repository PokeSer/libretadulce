import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/extensions/context_extensions.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/formatters.dart';
import '../l10n/app_localizations.dart';
import '../models/food.dart';
import '../services/food_repository.dart';
import '../services/open_food_facts_service.dart';
import '../widgets/food_list_item.dart';
import '../widgets/confirm_delete_dialog.dart';

class FoodsPage extends StatefulWidget {
  const FoodsPage({super.key});

  @override
  State<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> with TickerProviderStateMixin {
  final User? user = FirebaseAuth.instance.currentUser;
  late final TabController _tabController;

  // ── Personal foods state ──
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _kcalController = TextEditingController();
  final TextEditingController _proteinsController = TextEditingController();
  final TextEditingController _fatsController = TextEditingController();
  final TextEditingController _listSearchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  int _documentLimit = 20;

  // ── Global foods state ──
  String _globalSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        if (_searchQuery.isEmpty) {
          setState(() => _documentLimit += 20);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _listSearchController.dispose();
    _scrollController.dispose();
    _nameController.dispose();
    _brandController.dispose();
    _carbsController.dispose();
    _kcalController.dispose();
    _proteinsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  // ── Barcode scanning ──

  Future<void> _scanBarcode({
    TextEditingController? nameCtrl,
    TextEditingController? brandCtrl,
    TextEditingController? carbsCtrl,
  }) async {
    final l10n = AppLocalizations.of(context);
    final barcode = await OpenFoodFactsService.scanBarcode(context);
    if (barcode == null || barcode == '-1' || barcode.isEmpty) return;
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.globalScanning)),
    );

    try {
      final result = await OpenFoodFactsService.lookupBarcode(barcode,
          fallbackName: l10n.barcodeScannedFood);
      if (result != null) {
        setState(() {
          (nameCtrl ?? _nameController).text = result.name;
          (brandCtrl ?? _brandController).text = result.brand;
          if (result.carbsPer100g != null) {
            (carbsCtrl ?? _carbsController).text =
                result.carbsPer100g!.toStringAsFixed(1);
          }
          if (carbsCtrl == null) {
            if (result.kcalPer100g != null) {
              _kcalController.text = result.kcalPer100g!.toStringAsFixed(0);
            }
            if (result.proteinsPer100g != null) {
              _proteinsController.text =
                  result.proteinsPer100g!.toStringAsFixed(1);
            }
            if (result.fatsPer100g != null) {
              _fatsController.text = result.fatsPer100g!.toStringAsFixed(1);
            }
          }
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.globalFound)),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.globalNotFoundDB)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.globalConnectionError)),
        );
      }
    }
  }

  // ── Personal foods actions ──

  void _showAddFoodDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.foodsAddTitle,
                  style: TextStyle(color: AppColors.primary(context))),
              IconButton(
                icon: Icon(Icons.qr_code_scanner,
                    color: AppColors.primary(context)),
                tooltip: l10n.foodsScanTooltip,
                onPressed: () => _scanBarcode(),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
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
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
              onPressed: () {
                _clearFoodControllers();
                Navigator.pop(context);
              },
              child: Text(l10n.foodsCancel,
                  style: TextStyle(color: AppColors.textMuted(context))),
            ),
            ElevatedButton(
              onPressed: () async {
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
                  id: '',
                  name: _nameController.text.trim(),
                  brand: _brandController.text.trim(),
                  carbsPer100g: carbs,
                  kcalPer100g: kcal,
                  proteinsPer100g: proteins,
                  fatsPer100g: fats,
                );

                await FoodRepository.addFood(user!.uid, food);

                if (!context.mounted) return;
                _clearFoodControllers();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(context)),
              child: Text(l10n.foodsSave,
                  style: TextStyle(color: AppColors.onPrimary(context))),
            ),
          ],
        );
      },
    );
  }

  void _clearFoodControllers() {
    _nameController.clear();
    _brandController.clear();
    _carbsController.clear();
    _kcalController.clear();
    _proteinsController.clear();
    _fatsController.clear();
  }

  void _deleteFood(Food food) async {
    await FoodRepository.deleteFood(user!.uid, food.id);
    if (mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.calcItemRemoved(food.displayName)),
          action: SnackBarAction(
            label: l10n.calcUndo,
            onPressed: () async {
              await FoodRepository.addFood(user!.uid, food);
            },
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _toggleFavorite(String docId, bool currentStatus) async {
    if (!MediaQuery.of(context).disableAnimations) {
      HapticFeedback.lightImpact();
    }
    await FoodRepository.toggleFavorite(user!.uid, docId, currentStatus);
  }

  // ── Global foods actions ──

  void _showRequestFoodDialog() {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController();
    final brandController = TextEditingController();
    final carbsController = TextEditingController();
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(l10n.globalRequestTitle)),
              IconButton(
                icon: Icon(Icons.qr_code_scanner,
                    color: AppColors.primary(context)),
                tooltip: l10n.globalScanTooltip,
                onPressed: () => _scanBarcode(
                  nameCtrl: nameController,
                  brandCtrl: brandController,
                  carbsCtrl: carbsController,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.globalRequestDesc,
                  style: TextStyle(color: AppColors.textMuted(context)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  autofillHints: const [AutofillHints.name],
                  decoration: InputDecoration(
                    labelText: l10n.globalRequestName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: brandController,
                  decoration: InputDecoration(
                    labelText: l10n.globalRequestBrand,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: carbsController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.globalRequestCarbs,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: urlController,
                  autofillHints: const [AutofillHints.url],
                  decoration: InputDecoration(
                    labelText: l10n.globalRequestUrl,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.globalRequestCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final brand = brandController.text.trim();
                final carbs = parseSpanishDecimal(carbsController.text);
                final url = urlController.text.trim();

                if (name.isNotEmpty && carbs != null && user != null) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('food_requests')
                        .add({
                      'name': name,
                      'brand': brand,
                      'carbsPer100g': carbs,
                      'productUrl': url,
                      'status': 'pending',
                      'userId': user!.uid,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.globalRequestSent)),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.serviceError)),
                      );
                    }
                  }
                }
              },
              child: Text(l10n.globalRequestSend),
            ),
          ],
        );
      },
    );
  }

  void _copyToMyFoods(Food food) async {
    final l10n = AppLocalizations.of(context);
    if (user != null) {
      await FoodRepository.copyToUserFoods(user!.uid, food);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.globalAddedToMyFoods(food.name))),
        );
      }
    }
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (user == null) {
      return Center(child: Text(l10n.foodsMustLogin));
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary(context),
        unselectedLabelColor: AppColors.textSecondary(context),
        indicatorColor: AppColors.primary(context),
        tabs: [
          Tab(icon: const ExcludeSemantics(child: Icon(Icons.fastfood)), text: l10n.navFoods),
          Tab(icon: const ExcludeSemantics(child: Icon(Icons.book)), text: 'Libreta Dulce'),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPersonalFoods(l10n),
          _buildGlobalFoods(l10n),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (context, _) {
          final isPersonal = _tabController.index == 0;
          return FloatingActionButton.extended(
            onPressed:
                isPersonal ? _showAddFoodDialog : _showRequestFoodDialog,
            backgroundColor: AppColors.primary(context),
            foregroundColor: AppColors.onPrimary(context),
            icon: Icon(isPersonal ? Icons.add : Icons.outbox),
            label: Text(
                isPersonal ? l10n.foodsNewFood : l10n.globalSuggestProduct),
          );
        },
      ),
    );
  }

  // ── Personal foods tab ──

  Widget _buildPersonalFoods(AppLocalizations l10n) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
          child: TextField(
            controller: _listSearchController,
            decoration: InputDecoration(
              hintText: l10n.foodsSearch,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColors.surfaceAlt(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value.trim().toLowerCase());
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Food>>(
            stream: FoodRepository.watchUserFoods(user!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(l10n.foodsLoadingError));
              }

              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return Center(
                  child: Semantics(
                    label: l10n.foodSearchTitle,
                    child:
                        CircularProgressIndicator(color: AppColors.primary(context)),
                  ),
                );
              }

              final foods = snapshot.data ?? [];

              if (foods.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ExcludeSemantics(
                          child: Icon(Icons.kitchen,
                              size: 80,
                              color: AppColors.primaryLight(context))),
                      const SizedBox(height: 16),
                      Text(
                        l10n.foodsEmpty,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyText(context),
                      ),
                    ],
                  ),
                );
              }

              final List<Food> filteredFoods = foods.where((food) {
                if (_searchQuery.isEmpty) return true;
                final name = food.name.toLowerCase();
                final brand = food.brand.toLowerCase();
                return name.contains(_searchQuery) ||
                    brand.contains(_searchQuery);
              }).toList();

              filteredFoods.sort((a, b) {
                if (a.isFavorite && !b.isFavorite) return -1;
                if (!a.isFavorite && b.isFavorite) return 1;
                return a.name.compareTo(b.name);
              });

              final displayFoods = _searchQuery.isEmpty
                  ? filteredFoods.take(_documentLimit).toList()
                  : filteredFoods;

              return ListView.builder(
                controller: _scrollController,
                itemCount: displayFoods.length,
                padding: const EdgeInsets.only(bottom: 80, top: 8),
                itemBuilder: (context, index) {
                  final food = displayFoods[index];

                  return Dismissible(
                    key: Key(food.id),
                    direction: DismissDirection.endToStart,
                    dismissThresholds: const {
                      DismissDirection.endToStart: 0.25
                    },
                    background: Container(
                      margin: AppDimens.cardMargin,
                      decoration: BoxDecoration(
                        color: AppColors.error(context),
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusCard),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: ExcludeSemantics(
                        child: Icon(Icons.delete,
                            color: AppColors.onError(context), size: 30),
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await showConfirmDeleteDialog(
                        context,
                        content: l10n.foodsDeleteConfirm(food.name),
                      );
                    },
                    onDismissed: (direction) => _deleteFood(food),
                    child: FoodListItem(
                      food: food,
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: Icon(
                              food.isFavorite
                                  ? Icons.star
                                  : Icons.star_border,
                              color: food.isFavorite
                                  ? AppColors.accentFavorite(context)
                                  : AppColors.textMuted(context),
                            ),
                            tooltip: food.isFavorite
                                ? l10n.foodsRemoveFromFavorites
                                : l10n.foodsAddToFavorites,
                            onPressed: () =>
                                _toggleFavorite(food.id, food.isFavorite),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline,
                                color: AppColors.error(context)),
                            tooltip: l10n.foodsDeleteTooltip(food.name),
                            onPressed: () async {
                              final confirmed = await showConfirmDeleteDialog(
                                context,
                                content: l10n.foodsDeleteConfirm(food.name),
                              );
                              if (confirmed) {
                                _deleteFood(food);
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () => _showFoodDetail(food, l10n),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFoodDetail(Food food, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(food.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.foodsDetailTitle,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Semantics(
              label: l10n.foodsDetailCarbs('${food.carbsPer100g}'),
              child: Text('🎯 ${l10n.foodsDetailCarbs('${food.carbsPer100g}')}',
                  style: const TextStyle(fontSize: 16)),
            ),
            if (food.kcalPer100g != null)
              Semantics(
                label: l10n.foodsDetailCalories('${food.kcalPer100g}'),
                child: Text(
                    '🔥 ${l10n.foodsDetailCalories('${food.kcalPer100g}')}',
                    style: const TextStyle(fontSize: 16)),
              ),
            if (food.proteinsPer100g != null)
              Semantics(
                label: l10n.foodsDetailProtein('${food.proteinsPer100g}'),
                child: Text(
                    '💪 ${l10n.foodsDetailProtein('${food.proteinsPer100g}')}',
                    style: const TextStyle(fontSize: 16)),
              ),
            if (food.fatsPer100g != null)
              Semantics(
                label: l10n.foodsDetailFat('${food.fatsPer100g}'),
                child: Text(
                    '🥑 ${l10n.foodsDetailFat('${food.fatsPer100g}')}',
                    style: const TextStyle(fontSize: 16)),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.foodsDetailClose),
          ),
        ],
      ),
    );
  }

  // ── Global foods tab ──

  Widget _buildGlobalFoods(AppLocalizations l10n) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) =>
                setState(() => _globalSearchQuery = value.toLowerCase()),
            decoration: InputDecoration(
              hintText: l10n.globalSearch,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Food>>(
            stream: FoodRepository.watchGlobalFoods(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Semantics(
                    label: l10n.globalLoading,
                    child: CircularProgressIndicator(
                        color: AppColors.primary(context)),
                  ),
                );
              }

              final allFoods = snapshot.data ?? [];

              final filtered = allFoods.where((food) {
                return food.name
                    .toLowerCase()
                    .contains(_globalSearchQuery);
              }).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ExcludeSemantics(
                          child: Icon(Icons.public,
                              size: 64,
                              color: AppColors.primaryLight(context))),
                      const SizedBox(height: 16),
                      Text(l10n.globalNoResults,
                          style: AppTextStyles.bodyText(context)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: filtered.length,
                padding: const EdgeInsets.only(bottom: 80, top: 8),
                itemBuilder: (context, index) {
                  final food = filtered[index];

                  return Card(
                    margin: AppDimens.cardMargin,
                    shape: RoundedRectangleBorder(
                      side: context.isDarkMode
                          ? BorderSide(color: AppColors.borderSecondary(context))
                          : BorderSide.none,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusCard),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary(context),
                        child: Icon(Icons.public,
                            color: AppColors.onPrimary(context),
                            semanticLabel: l10n.globalGlobalFood),
                      ),
                      title: Text(food.displayName,
                          style: AppTextStyles.appBarTitle),
                      subtitle: Text(
                          l10n.calcCarbsPer100g('${food.carbsPer100g}')),
                      trailing: IconButton(
                        icon: Icon(Icons.add_circle,
                            color: AppColors.primary(context)),
                        tooltip: l10n.globalCopyToMyFoods,
                        onPressed: () => _copyToMyFoods(food),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
