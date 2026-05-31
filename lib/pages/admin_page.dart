import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/extensions/context_extensions.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import '../l10n/app_localizations.dart';
import '../models/food.dart';
import '../services/food_repository.dart';
import '../services/admin_service.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future<void> _approveRequest(
    String requestId,
    Map<String, dynamic> data,
  ) async {
    await AdminService.approveRequest(requestId, data);

    if (mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.adminApproved)),
      );
    }
  }

  Future<void> _rejectRequest(String requestId) async {
    await AdminService.rejectRequest(requestId);
    if (mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.adminRejected)),
      );
    }
  }

  Future<void> _deleteGlobalFood(String docId) async {
    await FoodRepository.deleteGlobalFood(docId);
    if (mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.adminDeleted)),
      );
    }
  }

  void _editGlobalFood(Food food) {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController(text: food.name);
    final brandController = TextEditingController(text: food.brand);
    final carbsController = TextEditingController(
      text: food.carbsPer100g.toString(),
    );
    final kcalController = TextEditingController(
      text: food.kcalPer100g?.toString() ?? '',
    );
    final proteinController = TextEditingController(
      text: food.proteinsPer100g?.toString() ?? '',
    );
    final fatController = TextEditingController(
      text: food.fatsPer100g?.toString() ?? '',
    );
    final urlController = TextEditingController(
      text: food.productUrl ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.adminEditTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  autofillHints: const [AutofillHints.name],
                  decoration: InputDecoration(
                    labelText: l10n.adminNameLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: brandController,
                  decoration: InputDecoration(
                    labelText: l10n.foodsBrandLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: carbsController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.adminCarbsLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: kcalController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.foodsKcalLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: proteinController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.foodsProteinLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: fatController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.foodsFatLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
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
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.adminCancelButton),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final brand = brandController.text.trim();
                final carbsRaw = carbsController.text.replaceAll(',', '.');
                final carbs = double.tryParse(carbsRaw);
                final kcal = double.tryParse(
                  kcalController.text.replaceAll(',', '.'),
                );
                final protein = double.tryParse(
                  proteinController.text.replaceAll(',', '.'),
                );
                final fat = double.tryParse(
                  fatController.text.replaceAll(',', '.'),
                );
                final url = urlController.text.trim();

                if (name.isNotEmpty && carbs != null) {
                  final updated = food.copyWith(
                    name: name,
                    brand: brand,
                    carbsPer100g: carbs,
                    kcalPer100g: kcal,
                    clearKcal: kcal == null,
                    proteinsPer100g: protein,
                    clearProteins: protein == null,
                    fatsPer100g: fat,
                    clearFats: fat == null,
                    productUrl: url.isNotEmpty ? url : null,
                  );
                  await FoodRepository.updateGlobalFood(food.id, updated);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text(l10n.adminUpdated)),
                    );
                  }
                }
              },
              child: Text(l10n.adminSaveButton),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPendingRequests() {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<List<FoodRequest>>(
      stream: AdminService.watchPendingRequests(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.globalErrorFirebase('${snapshot.error}'),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Semantics(
              label: l10n.adminLoadingRequests,
              child: const CircularProgressIndicator(),
            ),
          );
        }

        final requests = snapshot.data ?? [];

        if (requests.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(l10n.adminNoRequests),
            ),
          );
        }

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];

            return Card(
              margin: AppDimens.cardMargin,
              elevation: 1,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: context.isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              ),
              child: Padding(
                padding: AppDimens.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.name.isNotEmpty
                          ? request.name
                          : l10n.adminNoName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    if (request.brand.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        request.brand,
                        style: TextStyle(
                          fontSize: 14,
                          color: context.isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      l10n.adminCarbsInfo('${request.carbsPer100g}'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (request.productUrl != null &&
                        request.productUrl!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Semantics(
                        label: l10n.adminUrlInfo(request.productUrl!),
                        child: Text(
                          l10n.adminUrlInfo(request.productUrl!),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      '${request.userId.substring(0, request.userId.length < 8 ? request.userId.length : 8)}...',
                      style: TextStyle(
                        fontSize: 11,
                        color: context.isDarkMode
                            ? Colors.grey.shade500
                            : Colors.grey.shade600,
                      ),
                    ),
                    if (request.timestamp != null)
                      Text(
                        DateFormat.yMd().add_jm().format(request.timestamp!),
                        style: TextStyle(
                          fontSize: 11,
                          color: context.isDarkMode
                              ? Colors.grey.shade500
                              : Colors.grey.shade600,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () => _rejectRequest(request.id),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.redAccent,
                          ),
                          label: Text(
                            l10n.adminRejectButton,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: () => _approveRequest(request.id, {
                            'name': request.name,
                            'brand': request.brand,
                            'carbsPer100g': request.carbsPer100g,
                            'productUrl': request.productUrl,
                          }),
                          icon: const Icon(Icons.check),
                          label: Text(l10n.adminApproveButton),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.teal.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGlobalFoods() {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<List<Food>>(
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

        final foods = snapshot.data ?? [];

        if (foods.isEmpty) {
          return Center(child: Text(l10n.adminEmptyGlobal));
        }

        return ListView.builder(
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final food = foods[index];

            return Card(
              margin: AppDimens.cardMargin,
              elevation: 1,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: context.isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.public,
                    color: Colors.teal,
                  ),
                ),
                title: Text(
                  food.displayName,
                  style: AppTextStyles.appBarTitle,
                ),
                subtitle: Text(
                  [
                    l10n.calcCarbsPer100g(food.carbsPer100g.toStringAsFixed(1)),
                    if (food.kcalPer100g != null)
                      '${l10n.foodsKcalLabel}: ${food.kcalPer100g!.toStringAsFixed(0)}',
                    if (food.proteinsPer100g != null)
                      '${l10n.foodsProteinLabel}: ${food.proteinsPer100g!.toStringAsFixed(1)}g',
                    if (food.fatsPer100g != null)
                      '${l10n.foodsFatLabel}: ${food.fatsPer100g!.toStringAsFixed(1)}g',
                  ].join('  ·  '),
                  style: TextStyle(
                    fontSize: 12,
                    color: context.isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Colors.amber.shade600,
                      ),
                      onPressed: () => _editGlobalFood(food),
                      tooltip: l10n.adminEditGlobal,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      tooltip: l10n.adminDeleteGlobal,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: Text(l10n.adminDeleteConfirm),
                            content: Text(l10n.adminDeleteWarning),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: Text(l10n.adminCancelButton),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  _deleteGlobalFood(food.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(
                                  l10n.adminDeleteButton,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.adminTitle,
            style: AppTextStyles.appBarTitle,
          ),
          backgroundColor: context.isDarkMode
              ? AppColors.scaffoldBg(context)
              : Colors.blueGrey.shade800,
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.tealAccent,
            tabs: [
              Tab(icon: const Icon(Icons.inbox), text: l10n.adminTabRequests),
              Tab(icon: const Icon(Icons.public), text: l10n.adminTabGlobal),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildPendingRequests(), _buildGlobalFoods()],
        ),
      ),
    );
  }
}
