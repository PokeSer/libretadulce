import 'package:cloud_firestore/cloud_firestore.dart';
import 'meal_type.dart';

class Food {
  final String id;
  final String name;
  final String brand;
  final double carbsPer100g;
  final double? kcalPer100g;
  final double? proteinsPer100g;
  final double? fatsPer100g;
  final bool isFavorite;
  final String? productUrl;

  const Food({
    required this.id,
    required this.name,
    this.brand = '',
    required this.carbsPer100g,
    this.kcalPer100g,
    this.proteinsPer100g,
    this.fatsPer100g,
    this.isFavorite = false,
    this.productUrl,
  });

  String get displayName => brand.isEmpty ? name : '$name ($brand)';

  factory Food.fromFirestore(String docId, Map<String, dynamic> data) {
    return Food(
      id: docId,
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      carbsPer100g: (data['carbsPer100g'] as num?)?.toDouble() ?? 0.0,
      kcalPer100g: (data['kcalPer100g'] as num?)?.toDouble(),
      proteinsPer100g: (data['proteinsPer100g'] as num?)?.toDouble(),
      fatsPer100g: (data['fatsPer100g'] as num?)?.toDouble(),
      isFavorite: data['isFavorite'] ?? false,
      productUrl: data['productUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'brand': brand,
      'carbsPer100g': carbsPer100g,
      if (kcalPer100g != null) 'kcalPer100g': kcalPer100g,
      if (proteinsPer100g != null) 'proteinsPer100g': proteinsPer100g,
      if (fatsPer100g != null) 'fatsPer100g': fatsPer100g,
      'isFavorite': isFavorite,
      if (productUrl != null) 'productUrl': productUrl,
    };
  }

  Food copyWith({
    String? id,
    String? name,
    String? brand,
    double? carbsPer100g,
    double? kcalPer100g,
    bool clearKcal = false,
    double? proteinsPer100g,
    bool clearProteins = false,
    double? fatsPer100g,
    bool clearFats = false,
    bool? isFavorite,
    String? productUrl,
    bool clearProductUrl = false,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      carbsPer100g: carbsPer100g ?? this.carbsPer100g,
      kcalPer100g: clearKcal ? null : (kcalPer100g ?? this.kcalPer100g),
      proteinsPer100g:
          clearProteins ? null : (proteinsPer100g ?? this.proteinsPer100g),
      fatsPer100g: clearFats ? null : (fatsPer100g ?? this.fatsPer100g),
      isFavorite: isFavorite ?? this.isFavorite,
      productUrl:
          clearProductUrl ? null : (productUrl ?? this.productUrl),
    );
  }
}

class FoodRequest {
  final String id;
  final String name;
  final String brand;
  final double carbsPer100g;
  final String? productUrl;
  final String status;
  final String userId;
  final DateTime? timestamp;

  const FoodRequest({
    required this.id,
    required this.name,
    this.brand = '',
    required this.carbsPer100g,
    this.productUrl,
    required this.status,
    required this.userId,
    this.timestamp,
  });

  factory FoodRequest.fromFirestore(String docId, Map<String, dynamic> data) {
    final ts = data['timestamp'];
    return FoodRequest(
      id: docId,
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      carbsPer100g: (data['carbsPer100g'] as num?)?.toDouble() ?? 0.0,
      productUrl: data['productUrl'],
      status: data['status'] ?? 'pending',
      userId: data['userId'] ?? '',
      timestamp: ts is Timestamp ? ts.toDate() : null,
    );
  }
}

class MealItem {
  final String name;
  final double grams;
  final double carbs;
  final double raciones;

  const MealItem({
    required this.name,
    required this.grams,
    required this.carbs,
    required this.raciones,
  });

  factory MealItem.fromMap(Map<String, dynamic> map) {
    return MealItem(
      name: map['name'] ?? '',
      grams: (map['grams'] as num?)?.toDouble() ?? 0.0,
      carbs: (map['carbs'] as num?)?.toDouble() ?? 0.0,
      raciones: (map['raciones'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'grams': grams,
      'carbs': carbs,
      'raciones': raciones,
    };
  }
}

class MealEntry {
  final String id;
  final DateTime timestamp;
  final MealType mealType;
  final double totalCarbs;
  final double totalRations;
  final List<MealItem> items;
  final double? totalBolus;
  final double? glucose;

  const MealEntry({
    required this.id,
    required this.timestamp,
    required this.mealType,
    required this.totalCarbs,
    required this.totalRations,
    required this.items,
    this.totalBolus,
    this.glucose,
  });

  factory MealEntry.fromFirestore(String docId, Map<String, dynamic> data) {
    final ts = data['timestamp'] as Timestamp?;
    final rawItems =
        List<Map<String, dynamic>>.from(data['items'] ?? []);
    return MealEntry(
      id: docId,
      timestamp: ts?.toDate() ?? DateTime.now(),
      mealType: MealType.fromString(data['mealType'] ?? ''),
      totalCarbs: (data['totalCarbs'] as num?)?.toDouble() ?? 0.0,
      totalRations: (data['totalRations'] as num?)?.toDouble() ?? 0.0,
      totalBolus: data['totalBolus'] != null
          ? (data['totalBolus'] as num).toDouble()
          : null,
      glucose: data['glucose'] != null
          ? (data['glucose'] as num).toDouble()
          : null,
      items: rawItems.map(MealItem.fromMap).toList(),
    );
  }
}
