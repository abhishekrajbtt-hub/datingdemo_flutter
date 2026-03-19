import 'package:cloud_firestore/cloud_firestore.dart';

class DiscoverProfile {
  DiscoverProfile({
    required this.uid,
    required this.name,
    required this.age,
    required this.bio,
    required this.photoUrl,
  });

  final String uid;
  final String name;
  final int age;
  final String bio;
  final String photoUrl;

  factory DiscoverProfile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return DiscoverProfile(
      uid: doc.id,
      name: (data['name'] as String?) ?? (data['displayName'] as String?) ?? 'Unknown',
      age: (data['age'] as num?)?.toInt() ?? 18,
      bio: (data['aboutMe'] as String?) ?? '',
      photoUrl: (data['primaryPhotoUrl'] as String?) ?? '',
    );
  }
}
