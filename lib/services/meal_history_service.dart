import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_paths.dart';
import '../models/food.dart';

class MealHistoryService {
  static CollectionReference<Map<String, dynamic>> _history(String uid) =>
      FirestorePaths.userHistory(uid);

  static Future<void> saveEntry(String uid, {
    required String mealType,
    required double totalCarbs,
    required double totalRations,
    required List<Map<String, dynamic>> items,
    double? totalBolus,
  }) async {
    await _history(uid).add({
      'timestamp': FieldValue.serverTimestamp(),
      'mealType': mealType,
      'totalCarbs': totalCarbs,
      'totalRations': totalRations,
      'items': items,
      'totalBolus': ?totalBolus,
    });
  }

  static Future<void> deleteEntry(String uid, String entryId) async {
    await _history(uid).doc(entryId).delete();
  }

  static Stream<List<MealEntry>> watchDaily(String uid, DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return _history(uid)
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('timestamp', isLessThan: Timestamp.fromDate(end))
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MealEntry.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }

  static Stream<List<MealEntry>> watchRange(
      String uid, DateTime from, DateTime to) {
    return _history(uid)
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('timestamp', isLessThan: Timestamp.fromDate(to))
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MealEntry.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }

  static Future<List<MealEntry>> fetchAll(String uid) async {
    final snapshot =
        await _history(uid).orderBy('timestamp', descending: false).get();
    return snapshot.docs
        .map((doc) => MealEntry.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}
