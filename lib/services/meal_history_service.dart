import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_paths.dart';
import '../core/exceptions/app_exception.dart';
import '../models/food.dart';

class MealHistoryService {
  static CollectionReference<Map<String, dynamic>> _history(String uid) =>
      FirestorePaths.userHistory(uid);

  static Future<void> saveEntry(String uid, {
    required String mealType,
    required double totalCarbs,
    required double totalRations,
    required List<Map<String, dynamic>> items,
    double? totalFats,
    double? totalProteins,
    double? totalBolus,
    double? glucose,
    DateTime? timestamp,
  }) async {
    await wrapServiceCall('MealHistoryService.saveEntry', () async {
      await _history(uid).add({
        'timestamp': timestamp != null ? Timestamp.fromDate(timestamp) : FieldValue.serverTimestamp(),
        'mealType': mealType,
        'totalCarbs': totalCarbs,
        'totalRations': totalRations,
        'totalFats': totalFats,
        'totalProteins': totalProteins,
        'items': items,
        'totalBolus': totalBolus,
        'glucose': glucose,
      });
    });
  }

  static Future<void> deleteEntry(String uid, String entryId) async {
    await wrapServiceCall('MealHistoryService.deleteEntry', () async {
      await _history(uid).doc(entryId).delete();
    });
  }

  static Future<void> updateEntry(String uid, String entryId, {
    required String mealType,
    required double totalCarbs,
    required double totalRations,
    required List<Map<String, dynamic>> items,
    double? totalFats,
    double? totalProteins,
    double? totalBolus,
    double? glucose,
    DateTime? timestamp,
  }) async {
    await wrapServiceCall('MealHistoryService.updateEntry', () async {
      await _history(uid).doc(entryId).update({
        'mealType': mealType,
        'totalCarbs': totalCarbs,
        'totalRations': totalRations,
        'totalFats': totalFats,
        'totalProteins': totalProteins,
        'items': items,
        'totalBolus': totalBolus,
        'glucose': glucose,
        if (timestamp != null) 'timestamp': Timestamp.fromDate(timestamp),
      });
    });
  }

  /// Save (or replace) the AI analysis for a meal entry without touching
  /// any nutritional data — uses a partial Firestore update.
  static Future<void> saveAiAnalysis(
    String uid,
    String entryId, {
    required String aiAnalysisJson,
  }) async {
    await wrapServiceCall('MealHistoryService.saveAiAnalysis', () async {
      await _history(uid).doc(entryId).update({
        'aiAnalysis': aiAnalysisJson,
        'aiAnalysisDate': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Remove the AI analysis from a meal entry.
  static Future<void> deleteAiAnalysis(String uid, String entryId) async {
    await wrapServiceCall('MealHistoryService.deleteAiAnalysis', () async {
      await _history(uid).doc(entryId).update({
        'aiAnalysis': FieldValue.delete(),
        'aiAnalysisDate': FieldValue.delete(),
      });
    });
  }

  static Future<void> restoreEntry(String uid, MealEntry entry) async {
    await wrapServiceCall('MealHistoryService.restoreEntry', () async {
      await _history(uid).add({
        'timestamp': Timestamp.fromDate(entry.timestamp),
        'mealType': entry.mealType.rawValue,
        'totalCarbs': entry.totalCarbs,
        'totalRations': entry.totalRations,
        'totalFats': entry.totalFats,
        'totalProteins': entry.totalProteins,
        'items': entry.items.map((i) => {
          'name': i.name,
          'grams': i.grams,
          'carbs': i.carbs,
          'raciones': i.raciones,
          'fats': i.fats,
          'proteins': i.proteins,
        }).toList(),
        'totalBolus': entry.totalBolus,
        'glucose': entry.glucose,
      });
    });
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
    }).handleError((error, stack) {
      handleStreamError('MealHistoryService.watchDaily', error, stack);
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
    }).handleError((error, stack) {
      handleStreamError('MealHistoryService.watchRange', error, stack);
    });
  }

  static Future<List<MealEntry>> fetchAll(String uid) async {
    return wrapServiceCall('MealHistoryService.fetchAll', () async {
      final snapshot =
          await _history(uid).orderBy('timestamp', descending: false).get();
      return snapshot.docs
          .map((doc) => MealEntry.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }
}
