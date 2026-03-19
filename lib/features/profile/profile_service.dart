import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  ProfileService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<bool> hasProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;
    final doc = await _firestore.collection('profiles').doc(uid).get();
    return doc.exists;
  }

  Future<void> upsertBasicProfile({
    required String name,
    required int age,
    String aboutMe = '',
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('No logged-in user.');
    }
    await _firestore.collection('profiles').doc(uid).set(
      <String, dynamic>{
        'name': name.trim(),
        'age': age,
        'aboutMe': aboutMe.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
