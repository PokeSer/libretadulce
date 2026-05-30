import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_paths.dart';
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
    });
  }

  static Future<void> approveRequest(
      String requestId, Map<String, dynamic> data) async {
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
    await FirebaseFirestore.instance
        .collection(FirestorePaths.globalFoods)
        .add(foodData);
    await _requests.doc(requestId).update({
      'status': 'approved',
      'resolvedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> rejectRequest(String requestId) async {
    await _requests.doc(requestId).update({
      'status': 'rejected',
      'resolvedAt': FieldValue.serverTimestamp(),
    });
  }
}
