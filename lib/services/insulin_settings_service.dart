import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/insulin_settings.dart';

class InsulinSettingsService {
  static final _firestore = FirebaseFirestore.instance;

  static DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection('users').doc(uid).collection('settings').doc('insulin');

  static Future<InsulinSettings?> getSettings(String uid) async {
    final doc = await _doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return InsulinSettings.fromFirestore(doc.data()!);
  }

  static Future<void> saveSettings(String uid, InsulinSettings settings) async {
    await _doc(uid).set(settings.toFirestore());
  }
}
