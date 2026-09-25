import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';
import '../models/loan_model.dart';
import '../models/item_enums.dart';


class ItemService {
  final CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('items');
  final CollectionReference _loansCollection =
      FirebaseFirestore.instance.collection('loans');


  // 1. 🟢 Stream all items for the Feed in real-time
  Stream<List<ItemModel>> getItemsStream() {
    return _itemsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ItemModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // 2. 🟢 Add a new item to Firestore
  Future<void> addItem(ItemModel item) async {
    await _itemsCollection.doc(item.id).set(item.toMap());
  }

    // 3. 🟢 Одолжить вещь: сохраняем сделку и меняем статус вещи на inUse
  Future<void> borrowItem({
    required ItemModel item,
    required String borrowerId,
    required Duration duration,
  }) async {
    final now = DateTime.now();
    final returnDueDate = now.add(duration);
    final loanId = 'loan_${now.millisecondsSinceEpoch}';

    final loan = LoanModel(
      id: loanId,
      itemId: item.id,
      ownerId: item.ownerId,
      borrowerId: borrowerId,
      savedAmount: item.estimatedValue,
      returnDueDate: returnDueDate,
      status: LoanStatus.active,
      createdAt: now,
    );

    // Сохраняем сделку в коллекцию loans
    await _loansCollection.doc(loanId).set(loan.toMap());

    // Обновляем статус самой вещи на "inUse" (В аренде)
    await _itemsCollection.doc(item.id).update({
      'status': ItemStatus.inUse.name,
    });
  }

  // 4. 🟢 Стрим активной сделки для Профиля
  Stream<LoanModel?> getActiveLoanStream(String borrowerId) {
    return _loansCollection
        .where('borrowerId', isEqualTo: borrowerId)
        .where('status', isEqualTo: LoanStatus.active.name)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      return LoanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    });
  }

  // 5. 🟢 Получить вещь из базы по её ID
  Future<ItemModel?> getItemById(String itemId) async {
    final doc = await _itemsCollection.doc(itemId).get();
    if (!doc.exists || doc.data() == null) return null;
    return ItemModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

    // 6. 🟢 Пометить вещь как просроченную
  Future<void> markItemOverdue(String itemId) async {
    await _itemsCollection.doc(itemId).update({
      'status': ItemStatus.overdue.name,
    });
  }

    Future<void> returnItem({
  required String loanId,
  required String itemId,
}) async {
  final loanRef = _loansCollection.doc(loanId);
  final itemRef = _itemsCollection.doc(itemId);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final loanSnapshot = await transaction.get(loanRef);

    if (!loanSnapshot.exists || loanSnapshot.data() == null) {
      throw Exception('Loan not found');
    }

    final loanData = loanSnapshot.data() as Map<String, dynamic>;

    // Защита от повторного начисления рейтинга.
    if (loanData['ratingApplied'] == true ||
        loanData['status'] == LoanStatus.returned.name) {
      return;
    }

    final borrowerId = loanData['borrowerId'] as String?;
    if (borrowerId == null || borrowerId.isEmpty) {
      throw Exception('Borrower ID is missing');
    }

    final dueDate = DateTime.parse(
      loanData['returnDueDate'].toString(),
    );

    final wasOverdue = DateTime.now().isAfter(dueDate);
    final scoreChange = wasOverdue ? -20 : 10;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(borrowerId);

    transaction.update(loanRef, {
      'status': LoanStatus.returned.name,
      'returnedAt': FieldValue.serverTimestamp(),
      'ratingApplied': true,
      'wasOverdue': wasOverdue,
    });

    transaction.update(itemRef, {
      'status': ItemStatus.available.name,
    });

    transaction.set(
      userRef,
      {
        'trustScore': FieldValue.increment(scoreChange),
        'completedLoans': FieldValue.increment(1),
        if (wasOverdue) 'overdueReturns': FieldValue.increment(1),
      },
      SetOptions(merge: true),
    );
  });
}





}
