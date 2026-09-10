import 'item_enums.dart';

class LoanModel {
  final String id;
  final String itemId;         // ID вещeй
  final String ownerId;        // ID хозяина
  final String borrowerId;     // ID заёмщика (соседа)
  final double savedAmount;    // Сэкономленная сумма ($)
  final DateTime returnDueDate;// ⏳ Дата и время обязательного возврата
  final String? photoBeforeUrl;// 📸 Фото состояния "ДО"
  final String? photoAfterUrl; // 📸 Фото состояния "ПОСЛЕ"
  final LoanStatus status;     // active, returned, overdue
  final DateTime createdAt;

  LoanModel({
    required this.id,
    required this.itemId,
    required this.ownerId,
    required this.borrowerId,
    required this.savedAmount,
    required this.returnDueDate,
    this.photoBeforeUrl,
    this.photoAfterUrl,
    required this.status,
    required this.createdAt,
  });

  // Превращаем в Map для Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'ownerId': ownerId,
      'borrowerId': borrowerId,
      'savedAmount': savedAmount,
      'returnDueDate': returnDueDate.toIso8601String(),
      'photoBeforeUrl': photoBeforeUrl,
      'photoAfterUrl': photoAfterUrl,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Восстанавливаем из Map
  factory LoanModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    return LoanModel(
      id: docId ?? map['id'] ?? '',
      itemId: map['itemId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      borrowerId: map['borrowerId'] ?? '',
      savedAmount: (map['savedAmount'] as num?)?.toDouble() ?? 0.0,
      returnDueDate: map['returnDueDate'] != null
          ? DateTime.parse(map['returnDueDate'].toString())
          : DateTime.now().add(const Duration(days: 1)),
      photoBeforeUrl: map['photoBeforeUrl'],
      photoAfterUrl: map['photoAfterUrl'],
      status: LoanStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => LoanStatus.active,
      ),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'].toString())
          : DateTime.now(),
    );
  }
}
