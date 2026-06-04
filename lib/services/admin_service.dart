import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_paths.dart';
import '../core/exceptions/app_exception.dart';
import '../models/food.dart';

class AdminService {
  static CollectionReference<Map<String, dynamic>> get _requests =>
      FirebaseFirestore.instance.collection(FirestorePaths.foodRequests);

  static Stream<List<FoodRequest>> watchPendingRequests() {
    return _requests
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      final docs = snapshot.docs.toList()
        ..sort((a, b) {
          final tA = a.data()['timestamp'] as Timestamp?;
          final tB = b.data()['timestamp'] as Timestamp?;
          if (tA == null || tB == null) return 0;
          return tA.compareTo(tB);
        });
      return docs
          .map((doc) =>
              FoodRequest.fromFirestore(doc.id, doc.data()))
          .toList();
    }).handleError((error, stack) {
      handleStreamError('AdminService.watchPendingRequests', error, stack);
    });
  }

  /// Aprueba una solicitud de alimento usando un WriteBatch para
  /// garantizar atomicidad (add a globalFoods + update del request).
  static Future<void> approveRequest(
      String requestId, Map<String, dynamic> data) async {
    await wrapServiceCall('AdminService.approveRequest', () async {
      final batch = FirebaseFirestore.instance.batch();

      final foodRef = FirebaseFirestore.instance
          .collection(FirestorePaths.globalFoods)
          .doc();
      final foodData = <String, dynamic>{
        'name': data['name'],
        'carbsPer100g': data['carbsPer100g'],
        'approvedAt': FieldValue.serverTimestamp(),
      };
      if ((data['brand'] as String?)?.isNotEmpty == true) {
        foodData['brand'] = data['brand'];
      }
      if (data['productUrl'] != null && (data['productUrl'] as String).isNotEmpty) {
        foodData['productUrl'] = data['productUrl'];
      }
      batch.set(foodRef, foodData);

      batch.update(_requests.doc(requestId), {
        'status': 'approved',
        'resolvedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    });
  }

  static Future<void> rejectRequest(String requestId) async {
    await wrapServiceCall('AdminService.rejectRequest', () async {
      await _requests.doc(requestId).update({
        'status': 'rejected',
        'resolvedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
