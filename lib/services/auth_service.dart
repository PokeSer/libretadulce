import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _initialized = false;

  static const _serverClientId =
      '719361605717-i40g4vdoa3e1cdl5i9rccq615bmt6o4s.apps.googleusercontent.com';

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await GoogleSignInPlatform.instance.init(
      const InitParameters(serverClientId: _serverClientId),
    );
    _initialized = true;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _ensureInitialized();
      final GoogleSignInAccount googleUser;
      try {
        googleUser = await _googleSignIn.authenticate();
      } on GoogleSignInException catch (e) {
        if (e.code == GoogleSignInExceptionCode.canceled) {
          return null;
        }
        rethrow;
      }

      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuth error: ${e.code} - ${e.message}');
      throw AuthException('Firebase: ${e.message ?? e.code}');
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      throw AuthException(e.toString().split('\n').first);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
