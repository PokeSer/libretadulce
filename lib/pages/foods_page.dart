import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/extensions/context_extensions.dart';
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

class _FoodsPageState extends State<FoodsPage> {
  final User? user = FirebaseAuth.instance.currentUser;

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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        if (_searchQuery.isEmpty) {
          setState(() {
            _documentLimit += 20;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _listSearchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    final l10n = AppLocalizations.of(context);
    final barcode = await OpenFoodFactsService.scanBarcode(context);
    if (barcode == null || barcode == '-1' || barcode.isEmpty) return;
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.globalScanning)),
    );

    try {
      final result = await OpenFoodFactsService.lookupBarcode(barcode);
      if (result != null) {
        setState(() {
          _nameController.text = result.name;
          _brandController.text = result.brand;
          if (result.carbsPer100g != null) {
            _carbsController.text = result.carbsPer100g!.toStringAsFixed(1);
          }
          if (result.kcalPer100g != null) {
            _kcalController.text = result.kcalPer100g!.toStringAsFixed(0);
          }
          if (result.proteinsPer100g != null) {
            _proteinsController.text = result.proteinsPer100g!.toStringAsFixed(1);
          }
          if (result.fatsPer100g != null) {
            _fatsController.text = result.fatsPer100g!.toStringAsFixed(1);
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

  void _showAddFoodDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.foodsAddTitle, style: const TextStyle(color: Colors.teal)),
              IconButton(
                icon: const Icon(Icons.qr_code_scanner, color: Colors.teal),
                tooltip: l10n.foodsScanTooltip,
                onPressed: _scanBarcode,
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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                _nameController.clear();
                _brandController.clear();
                _carbsController.clear();
                _kcalController.clear();
                _proteinsController.clear();
                _fatsController.clear();
                Navigator.pop(context);
              },
              child: Text(l10n.foodsCancel, style: const TextStyle(color: Colors.grey)),
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
                _nameController.clear();
                _brandController.clear();
                _carbsController.clear();
                _kcalController.clear();
                _proteinsController.clear();
                _fatsController.clear();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: Text(l10n.foodsSave, style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _deleteFood(String docId) async {
    await FoodRepository.deleteFood(user!.uid, docId);
  }

  void _toggleFavorite(String docId, bool currentStatus) async {
    await FoodRepository.toggleFavorite(user!.uid, docId, currentStatus);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (user == null) {
      return Center(child: Text(l10n.foodsMustLogin));
    }

    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
            child: TextField(
              controller: _listSearchController,
              decoration: InputDecoration(
                hintText: l10n.foodsSearch,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
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

                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return Center(
                    child: Semantics(
                      label: l10n.foodSearchTitle,
                      child: const CircularProgressIndicator(color: Colors.teal),
                    ),
                  );
                }

                final foods = snapshot.data ?? [];

                if (foods.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ExcludeSemantics(child: Icon(Icons.kitchen, size: 80, color: Colors.teal.shade100)),
                        const SizedBox(height: 16),
                        Text(
                          l10n.foodsEmpty,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                final List<Food> filteredFoods = foods.where((food) {
                  if (_searchQuery.isEmpty) return true;
                  final name = food.name.toLowerCase();
                  final brand = food.brand.toLowerCase();
                  return name.contains(_searchQuery) || brand.contains(_searchQuery);
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
                      dismissThresholds: const {DismissDirection.endToStart: 0.25},
                      background: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white, size: 30),
                      ),
                      confirmDismiss: (direction) async {
                        return await showConfirmDeleteDialog(
                          context,
                           content: l10n.foodsDeleteConfirm(food.name),
                        );
                      },
                      onDismissed: (direction) => _deleteFood(food.id),
                      child: FoodListItem(
                        food: food,
                        trailing: Wrap(
                          spacing: 4,
                          children: [
                            IconButton(
                              icon: Icon(
                                food.isFavorite ? Icons.star : Icons.star_border,
                                color: food.isFavorite ? Colors.amber.shade600 : Colors.grey.shade400,
                              ),
                              tooltip: food.isFavorite ? l10n.foodsRemoveFromFavorites : l10n.foodsAddToFavorites,
                              onPressed: () => _toggleFavorite(food.id, food.isFavorite),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              tooltip: l10n.foodsDeleteTooltip(food.name),
                              onPressed: () async {
                                final confirmed = await showConfirmDeleteDialog(
                                  context,
                                  content: l10n.foodsDeleteConfirm(food.name),
                                );
                                if (confirmed) {
                                  _deleteFood(food.id);
                                }
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(food.displayName),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.foodsDetailTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Semantics(
                                    label: l10n.foodsDetailCarbs('${food.carbsPer100g}'),
                                     child: Text('🎯 ${l10n.foodsDetailCarbs('${food.carbsPer100g}')}', style: const TextStyle(fontSize: 16)),
                                  ),
                                  if (food.kcalPer100g != null)
                                    Semantics(
                                      label: l10n.foodsDetailCalories('${food.kcalPer100g}'),
                                      child: Text('🔥 ${l10n.foodsDetailCalories('${food.kcalPer100g}')}', style: const TextStyle(fontSize: 16)),
                                    ),
                                  if (food.proteinsPer100g != null)
                                    Semantics(
                                      label: l10n.foodsDetailProtein('${food.proteinsPer100g}'),
                                      child: Text('💪 ${l10n.foodsDetailProtein('${food.proteinsPer100g}')}', style: const TextStyle(fontSize: 16)),
                                    ),
                                  if (food.fatsPer100g != null)
                                    Semantics(
                                      label: l10n.foodsDetailFat('${food.fatsPer100g}'),
                                      child: Text('🥑 ${l10n.foodsDetailFat('${food.fatsPer100g}')}', style: const TextStyle(fontSize: 16)),
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
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddFoodDialog,
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(l10n.foodsNewFood),
      ),
    );
  }
}
