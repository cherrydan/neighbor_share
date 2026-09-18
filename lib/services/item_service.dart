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

}
