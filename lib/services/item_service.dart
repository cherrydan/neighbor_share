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

    // 7. 🟢 Завершить аренду и вернуть вещь хозяину
  Future<void> returnItem({
    required String loanId,
    required String itemId,
  }) async {
    // Меняем статус сделки на "returned"
    await _loansCollection.doc(loanId).update({
      'status': LoanStatus.returned.name,
    });

    // Возвращаем статус самой вещи на "available" (Свободно!)
    await _itemsCollection.doc(itemId).update({
      'status': ItemStatus.available.name,
    });
  }




}
