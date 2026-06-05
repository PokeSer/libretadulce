import 'package:cloud_firestore/cloud_firestore.dart';

abstract final class FirestorePaths {
  static const globalFoods = 'global_foods';
  static const foodRequests = 'food_requests';
  static const users = 'users';

  static DocumentReference<Map<String, dynamic>> userDoc(String uid) =>
      FirebaseFirestore.instance.collection(users).doc(uid);

  static CollectionReference<Map<String, dynamic>> userFoods(String uid) =>
      userDoc(uid).collection('foods');

  static CollectionReference<Map<String, dynamic>> userHistory(String uid) =>
      userDoc(uid).collection('history');

  static DocumentReference<Map<String, dynamic>> userInsulinSettings(String uid) =>
      userDoc(uid).collection('settings').doc('insulin');

  static CollectionReference<Map<String, dynamic>> userTemplates(String uid) =>
      userDoc(uid).collection('templates');
}
