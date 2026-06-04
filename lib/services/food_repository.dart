import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_paths.dart';
import '../core/exceptions/app_exception.dart';
import '../models/food.dart';

class FoodRepository {
  static CollectionReference<Map<String, dynamic>> _foods(String uid) =>
      FirestorePaths.userFoods(uid);

  static Stream<List<Food>> watchUserFoods(String uid) {
    return _foods(uid).orderBy('name').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Food.fromFirestore(doc.id, doc.data()))
          .toList();
    }).handleError((error, stack) {
      handleStreamError('FoodRepository.watchUserFoods', error, stack);
    });
  }

  static Stream<List<Food>> watchFavoriteFoods(String uid) {
    return _foods(uid)
        .where('isFavorite', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Food.fromFirestore(doc.id, doc.data()))
          .toList();
    }).handleError((error, stack) {
      handleStreamError('FoodRepository.watchFavoriteFoods', error, stack);
    });
  }

  static Future<void> addFood(String uid, Food food) async {
    await wrapServiceCall('FoodRepository.addFood', () async {
      await _foods(uid).add(food.toFirestore());
    });
  }

  static Future<void> deleteFood(String uid, String foodId) async {
    await wrapServiceCall('FoodRepository.deleteFood', () async {
      await _foods(uid).doc(foodId).delete();
    });
  }

  static Future<void> toggleFavorite(
      String uid, String foodId, bool current) async {
    await wrapServiceCall('FoodRepository.toggleFavorite', () async {
      await _foods(uid).doc(foodId).update({'isFavorite': !current});
    });
  }

  static Stream<List<Food>> watchGlobalFoods() {
    return FirebaseFirestore.instance
        .collection(FirestorePaths.globalFoods)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Food.fromFirestore(doc.id, doc.data()))
          .toList();
    }).handleError((error, stack) {
      handleStreamError('FoodRepository.watchGlobalFoods', error, stack);
    });
  }

  static Future<void> copyToUserFoods(String uid, Food food) async {
    await wrapServiceCall('FoodRepository.copyToUserFoods', () async {
      await _foods(uid).add(food.copyWith(isFavorite: false).toFirestore());
    });
  }

  static Future<void> addGlobalFood(Food food) async {
    await wrapServiceCall('FoodRepository.addGlobalFood', () async {
      await FirebaseFirestore.instance
          .collection(FirestorePaths.globalFoods)
          .add(food.toFirestore());
    });
  }

  static Future<void> updateGlobalFood(String foodId, Food food) async {
    await wrapServiceCall('FoodRepository.updateGlobalFood', () async {
      await FirebaseFirestore.instance
          .collection(FirestorePaths.globalFoods)
          .doc(foodId)
          .update(food.toFirestore());
    });
  }

  static Future<void> deleteGlobalFood(String foodId) async {
    await wrapServiceCall('FoodRepository.deleteGlobalFood', () async {
      await FirebaseFirestore.instance
          .collection(FirestorePaths.globalFoods)
          .doc(foodId)
          .delete();
    });
  }
}
