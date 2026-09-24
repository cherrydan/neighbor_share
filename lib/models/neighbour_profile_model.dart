class NeighborProfileModel {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final int trustScore;
  final int completedLoans;
  final int overdueReturns;

  const NeighborProfileModel({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    this.trustScore = 100,
    this.completedLoans = 0,
    this.overdueReturns = 0,
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
    };
  }

  factory NeighborProfileModel.fromMap(Map<String, dynamic> map) {
    return NeighborProfileModel(
      uid: map['uid'] as String? ?? '',
      displayName: map['displayName'] as String?,
      email: map['email'] as String?,
      photoUrl: map['photoUrl'] as String?,
      trustScore: (map['trustScore'] as num?)?.toInt() ?? 100,
      completedLoans: (map['completedLoans'] as num?)?.toInt() ?? 0,
      overdueReturns: (map['overdueReturns'] as num?)?.toInt() ?? 0,
    );
  }
}
