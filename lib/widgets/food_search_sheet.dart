import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/food.dart';
import '../services/food_repository.dart';
import '../l10n/app_localizations.dart';

class FoodSearchSheet extends StatefulWidget {
  const FoodSearchSheet({super.key});

  @override
  State<FoodSearchSheet> createState() => _FoodSearchSheetState();
}

class _FoodSearchSheetState extends State<FoodSearchSheet> {
  final User? user = FirebaseAuth.instance.currentUser;
  String _searchQuery = '';

  static List<Food> _filterAndSort(List<Food> foods, String query) {
    List<Food> filtered = query.isEmpty
        ? foods.toList()
        : foods
            .where((f) =>
                f.name.toLowerCase().contains(query) ||
                f.brand.toLowerCase().contains(query))
            .toList();

    filtered.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return a.name.compareTo(b.name);
    });
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 8, top: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.foodSearchTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    tooltip: l10n.foodSearchClose,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 8),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.foodSearchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: isDark
                      ? Colors.grey.shade800
                      : Colors.grey.shade100,
                ),
                onChanged: (val) =>
                    setState(() => _searchQuery = val.toLowerCase()),
              ),
            ),
            const Divider(),
            Expanded(
              child: StreamBuilder<List<Food>>(
                stream: FoodRepository.watchUserFoods(user!.uid),
                builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: Semantics(
                    label: l10n.foodSearchTitle,
                    child: const CircularProgressIndicator(),
                  ),
                );
              }

                  final allFoods = snapshot.data ?? [];
                  if (allFoods.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.foodSearchEmptyList,
                        style: TextStyle(
                            color: isDark ? Colors.grey.shade400 : Colors.grey),
                      ),
                    );
                  }

                  final filtered =
                      _filterAndSort(allFoods, _searchQuery);

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.foodSearchNoResults(_searchQuery),
                        style: TextStyle(
                            color: isDark ? Colors.grey.shade400 : Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final food = filtered[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: food.isFavorite
                              ? Colors.amber.withValues(alpha: 0.2)
                              : Colors.teal.withValues(alpha: 0.1),
                          child: Icon(
                            food.isFavorite
                                ? Icons.star
                                : Icons.restaurant,
                            semanticLabel: food.isFavorite
                                ? l10n.foodsFavoriteAccessibility
                                : l10n.foodsFoodAccessibility,
                            color: food.isFavorite
                                ? Colors.amber.shade600
                                : Colors.teal,
                          ),
                        ),
                        title: Text(
                          food.displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: food.isFavorite
                                ? (isDark
                                    ? Colors.amber.shade200
                                    : Colors.brown.shade800)
                                : (isDark
                                    ? Colors.white
                                    : Colors.black87),
                          ),
                        ),
                        subtitle: Text(
                          l10n.calcCarbsPer100g('${food.carbsPer100g}'),
                          style:
                              TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                        ),
                        trailing: const Icon(Icons.chevron_right,
                            color: Colors.teal),
                        onTap: () => Navigator.pop(context, food),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
