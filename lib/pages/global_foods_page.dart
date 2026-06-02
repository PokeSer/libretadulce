import 'package:flutter/material.dart';
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

class GlobalFoodsPage extends StatefulWidget {
  const GlobalFoodsPage({super.key});

  @override
  State<GlobalFoodsPage> createState() => _GlobalFoodsPageState();
}

class _GlobalFoodsPageState extends State<GlobalFoodsPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  String _searchQuery = '';

  Future<void> _scanBarcode(
      TextEditingController nameController,
      TextEditingController brandController,
      TextEditingController carbsController) async {
    final l10n = AppLocalizations.of(context);
    final barcode = await OpenFoodFactsService.scanBarcode(context);
    if (barcode != null && barcode != '-1' && barcode.isNotEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.globalScanning)),
      );

      final result = await OpenFoodFactsService.lookupBarcode(barcode, fallbackName: l10n.barcodeScannedFood);

      if (result != null && mounted) {
        setState(() {
          nameController.text = result.name;
          brandController.text = result.brand;
          if (result.carbsPer100g != null) {
            carbsController.text = result.carbsPer100g!.toStringAsFixed(1);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.globalFound)),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.globalNotFound)),
        );
      }
    }
  }

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
                icon: Icon(Icons.qr_code_scanner, color: AppColors.primary(context)),
                tooltip: l10n.globalScanTooltip,
                onPressed: () => _scanBarcode(nameController, brandController, carbsController),
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
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
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
                      SnackBar(
                        content: Text(l10n.globalRequestSent),
                      ),
                    );
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
          SnackBar(
            content: Text(l10n.globalAddedToMyFoods(food.name)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) =>
                  setState(() => _searchQuery = value.toLowerCase()),
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
                      child: const CircularProgressIndicator(),
                    ),
                  );
                }

                final allFoods = snapshot.data ?? [];

                final filtered = allFoods.where((food) {
                  return food.name.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(l10n.globalNoResults),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final food = filtered[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        side: context.isDarkMode
                            ? BorderSide(color: Colors.grey.shade800)
                            : BorderSide.none,
                        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary(context),
                          child: Icon(Icons.public, color: AppColors.onPrimary(context), semanticLabel: l10n.globalGlobalFood),
                        ),
                        title: Text(
                          food.displayName,
                          style: AppTextStyles.appBarTitle,
                        ),
                        subtitle: Text(l10n.calcCarbsPer100g('${food.carbsPer100g}')),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: AppColors.primary(context),
                          ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showRequestFoodDialog,
        icon: const Icon(Icons.outbox),
        label: Text(l10n.globalSuggestProduct),
        backgroundColor: AppColors.primary(context),
        foregroundColor: AppColors.onPrimary(context),
      ),
    );
  }
}
