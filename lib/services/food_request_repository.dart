import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_paths.dart';
import '../core/exceptions/app_exception.dart';

/// Repository for food request operations.
/// Extracted from foods_page.dart to separate Firebase concerns from UI.
class FoodRequestRepository {
  static CollectionReference<Map<String, dynamic>> get _requests =>
      FirebaseFirestore.instance.collection(FirestorePaths.foodRequests);

  /// Submit a new food request for admin review.
  /// Data written is identical to what was previously in foods_page.dart.
  static Future<void> submitRequest({
    required String name,
    required String brand,
    required double carbsPer100g,
    required String productUrl,
    required String userId,
  }) async {
    await wrapServiceCall('FoodRequestRepository.submitRequest', () async {
      await _requests.add({
        'name': name,
        'brand': brand,
        'carbsPer100g': carbsPer100g,
        'productUrl': productUrl,
        'status': 'pending',
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
  }
}
