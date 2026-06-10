import 'package:cloud_firestore/cloud_firestore.dart';

class MealTemplate {
  final String id;
  final String name;
  final List<Map<String, dynamic>> items;
  final String? mealType;
  final DateTime createdAt;

  const MealTemplate({
    required this.id,
    required this.name,
    required this.items,
    this.mealType,
    required this.createdAt,
  });

  factory MealTemplate.fromFirestore(
      String docId, Map<String, dynamic> data) {
    return MealTemplate(
      id: docId,
      name: data['name'] ?? '',
      items: (data['items'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      mealType: data['mealType'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime(2024),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'items': items,
      if (mealType != null) 'mealType': mealType,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
