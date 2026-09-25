import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neighbor_share/models/neighbor_profile_model.dart';

class UserService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // 1. 🟢 Получить или создать профиль при входе пользователя
  Future<NeighborProfileModel> getOrCreateProfile({
    required String uid,
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    final doc = await _usersCollection.doc(uid).get();
    
    if (doc.exists && doc.data() != null) {
      return NeighborProfileModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }

    // Если профиля еще нет — создаем новый со стартовым рейтингом 100!
    final freshProfile = NeighborProfileModel(
      uid: uid,
      displayName: displayName,
      email: email,
      photoUrl: photoUrl,
      trustScore: 100,
      completedLoans: 0,
      overdueReturns: 0,
    );

    await _usersCollection.doc(uid).set(freshProfile.toMap());
    return freshProfile;
  }

  // 2. 🟢 Стрим профиля для реал-тайм обновления Кармы на экране
  Stream<NeighborProfileModel?> getUserProfileStream(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return NeighborProfileModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    });
  }
}
