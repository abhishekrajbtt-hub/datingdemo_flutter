import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'discover_profile.dart';

class DiscoverService {
  DiscoverService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Stream<List<DiscoverProfile>> watchDiscoverProfiles() {
    final myUid = _auth.currentUser?.uid;
    return _firestore.collection('profiles').limit(100).snapshots().map((snap) {
      final all = snap.docs.map(DiscoverProfile.fromFirestore).toList();
      return all.where((item) => item.uid != myUid).toList();
    });
  }
}
