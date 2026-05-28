import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/extensions/context_extensions.dart';
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

  void _editGlobalFood(String docId, Map<String, dynamic> currentData) {
    final l10n = AppLocalizations.of(context);
    final food = Food.fromFirestore(docId, currentData);
    final nameController = TextEditingController(text: food.name);
    final carbsController = TextEditingController(
      text: food.carbsPer100g.toString(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.adminEditTitle),
          content: Column(
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
              const SizedBox(height: 16),
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.adminCancelButton),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final carbsRaw = carbsController.text.replaceAll(',', '.');
                final carbs = double.tryParse(carbsRaw);

                if (name.isNotEmpty && carbs != null) {
                  final updated = food.copyWith(name: name, carbsPer100g: carbs);
                  await FoodRepository.updateGlobalFood(docId, updated);
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
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              elevation: 1,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: context.isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                    const SizedBox(height: 8),
                    Text(
                      l10n.adminCarbsInfo('${request.carbsPer100g}'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (request.productUrl != null &&
                        request.productUrl!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Semantics(
                        label: l10n.adminUrlInfo(request.productUrl!),
                        child: Text(
                          l10n.adminUrlInfo(request.productUrl!),
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
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
                            'carbsPer100g': request.carbsPer100g,
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('global_foods')
          .orderBy('name')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Semantics(
              label: l10n.globalLoading,
              child: const CircularProgressIndicator(),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Center(child: Text(l10n.adminEmptyGlobal));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              elevation: 1,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: context.isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.public,
                    color: Colors.teal,
                    semanticLabel: l10n.adminGlobalFood,
                  ),
                ),
                title: Text(
                  data['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  l10n.calcCarbsPer100g('${data['carbsPer100g']}'),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Colors.amber.shade600,
                      ),
                      onPressed: () => _editGlobalFood(doc.id, data),
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
                                  _deleteGlobalFood(doc.id);
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: context.isDarkMode
              ? const Color(0xFF1E1E1E)
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
