import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_paths.dart';
import '../core/exceptions/app_exception.dart';

/// Repository for user document operations.
/// Extracted from home_page.dart to separate Firebase concerns from UI.
class UserRepository {
  static DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      FirestorePaths.userDoc(uid);

  /// Ensures a user document exists. Creates one with defaults if missing.
  /// Returns the user's role (defaults to 'user').
  static Future<String> ensureUserDoc({
    required String uid,
    required String email,
  }) async {
    return wrapServiceCall('UserRepository.ensureUserDoc', () async {
      final doc = await _doc(uid).get();

      if (!doc.exists) {
        await _doc(uid).set({
          'email': email,
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });
        return 'user';
      }

      return (doc.data()?['role'] as String?) ?? 'user';
    });
  }

  /// Checks if a user has admin role.
  static Future<bool> isAdmin(String uid) async {
    return wrapServiceCall('UserRepository.isAdmin', () async {
      final doc = await _doc(uid).get();
      if (!doc.exists) return false;
      return doc.data()?['role'] == 'admin';
    });
  }
}
