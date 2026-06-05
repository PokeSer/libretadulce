import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_paths.dart';
import '../core/exceptions/app_exception.dart';
import '../models/meal_template.dart';

class MealTemplateService {
  static CollectionReference<Map<String, dynamic>> _templates(String uid) =>
      FirestorePaths.userTemplates(uid);

  static Stream<List<MealTemplate>> watchAll(String uid) {
    return _templates(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MealTemplate.fromFirestore(doc.id, doc.data()))
            .toList())
        .handleError((error, stack) {
      handleStreamError('MealTemplateService.watchAll', error, stack);
    });
  }

  static Future<void> save(String uid, {
    required String name,
    required List<Map<String, dynamic>> items,
    String? mealType,
  }) async {
    await wrapServiceCall('MealTemplateService.save', () async {
      await _templates(uid).add({
        'name': name,
        'items': items,
        if (mealType != null) 'mealType': mealType,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  static Future<void> delete(String uid, String templateId) async {
    await wrapServiceCall('MealTemplateService.delete', () async {
      await _templates(uid).doc(templateId).delete();
    });
  }
}
