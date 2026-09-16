import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class ItemService {
  final CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('items');

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
}
