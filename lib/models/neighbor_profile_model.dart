class NeighborProfileModel {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final int trustScore;
  final int completedLoans;
  final int overdueReturns;
  final bool isPro; // 🟢 Добавили флаг PRO!

  const NeighborProfileModel({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    this.trustScore = 100,
    this.completedLoans = 0,
    this.overdueReturns = 0,
    this.isPro = false, // 🟢 По умолчанию обычный юзер
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'trustScore': trustScore,
      'completedLoans': completedLoans,
      'overdueReturns': overdueReturns,
      'isPro': isPro, // 🟢 Пишем в Firestore
    };
  }

  factory NeighborProfileModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    return NeighborProfileModel(
      uid: docId ?? map['uid'] as String? ?? '',
      displayName: map['displayName'] as String?,
      email: map['email'] as String?,
      photoUrl: map['photoUrl'] as String?,
      trustScore: (map['trustScore'] as num?)?.toInt() ?? 100,
      completedLoans: (map['completedLoans'] as num?)?.toInt() ?? 0,
      overdueReturns: (map['overdueReturns'] as num?)?.toInt() ?? 0,
      isPro: map['isPro'] as bool? ?? false, // 🟢 Читаем из Firestore
    );
  }
}
