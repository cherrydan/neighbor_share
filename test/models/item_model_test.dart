import 'package:flutter_test/flutter_test.dart';
import 'package:neighbor_share/models/item_enums.dart';
import 'package:neighbor_share/models/item_model.dart';

void main() {
  group('ItemModel Unit Tests', () {
    test('should correctly serialize ItemModel to Map and deserialize back from Map', () {
      // 1. Создаем тестовую вещь
      final now = DateTime.now();
      final originalItem = ItemModel(
        id: 'item_777',
        name: 'Перфоратор Bosch',
        description: 'Отличный перфоратор, даю на вечер соседям',
        category: ItemCategory.tools,
        status: ItemStatus.available,
        imageUrl: 'https://cloudinary.com/drill.jpg',
        latitude: 38.7223,  // Координаты Лиссабона 🇵🇹
        longitude: -9.1393,
        ownerId: 'user_neighbor_1',
        createdAt: now,
      );

      // 2. Конвертируем в Map
      final itemMap = originalItem.toMap();

      // 3. Восстанавливаем из Map
      final restoredItem = ItemModel.fromMap(itemMap, 'item_777');

      // 4. Проверяем равенство полей!
      expect(restoredItem.id, equals('item_777'));
      expect(restoredItem.name, equals('Перфоратор Bosch'));
      expect(restoredItem.category, equals(ItemCategory.tools));
      expect(restoredItem.status, equals(ItemStatus.available));
      expect(restoredItem.latitude, equals(38.7223));
      expect(restoredItem.longitude, equals(-9.1393));
      expect(restoredItem.ownerId, equals('user_neighbor_1'));
    });
  });
}