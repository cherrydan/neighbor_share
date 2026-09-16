import 'package:flutter/material.dart';
import 'package:neighbor_share/screens/add_item_screen.dart';
import '../l10n/app_localizations.dart';
import '../models/item_enums.dart';
import '../models/item_model.dart';
import '../widgets/item_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // null означает категорию "Все"
  ItemCategory? _selectedCategory;

  // 🟢 Тестовый список соседских вещей для проверки ленты:
  final List<ItemModel> _sampleItems = [
    ItemModel(
      id: '1',
      name: 'Перфоратор Bosch PBH 2100',
      description: 'Отличный рабочий перфоратор с набором буров. Дам на пару дней соседям.',
      category: ItemCategory.tools,
      status: ItemStatus.available,
      imageUrl: 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600',
      latitude: 38.7223,
      longitude: -9.1393,
      ownerId: 'owner_1',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      estimatedValue: 110.0,
    ),
    ItemModel(
      id: '2',
      name: 'Палатка 3-местная Quechua',
      description: 'Водонепроницаемая палатка для кемпинга. Быстро собирается.',
      category: ItemCategory.camping,
      status: ItemStatus.inUse,
      imageUrl: 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=600',
      latitude: 38.7230,
      longitude: -9.1400,
      ownerId: 'owner_2',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      estimatedValue: 85.0,
    ),
    ItemModel(
      id: '3',
      name: 'Детский зимний комбинезон (рост 98)',
      description: 'Теплый, чистый комбинезон на 2-3 года. Нам стал мал, с радостью поделимся!',
      category: ItemCategory.clothes,
      status: ItemStatus.available,
      imageUrl: 'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=600',
      latitude: 38.7210,
      longitude: -9.1380,
      ownerId: 'owner_3',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      estimatedValue: 60.0,
    ),
    ItemModel(
      id: '4',
      name: 'Автомобильный компрессор 12V',
      description: 'Срочно нужен насос подкачать колесо во дворе дома №5 на 15 минут!',
      category: ItemCategory.auto,
      status: ItemStatus.requested,
      imageUrl: null, // проверим отображение без фото!
      latitude: 38.7240,
      longitude: -9.1420,
      ownerId: 'owner_4',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      estimatedValue: 45.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Фильтруем список
    final filteredItems = _selectedCategory == null
        ? _sampleItems
        : _sampleItems.where((item) => item.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.feedTab),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. Горизонтальная лента фильтра категорий
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(l10n.categoryAll),
                    selected: _selectedCategory == null,
                    onSelected: (_) => setState(() => _selectedCategory = null),
                  ),
                ),
                ...ItemCategory.values.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_getCategoryLabel(cat, l10n)),
                      selected: _selectedCategory == cat,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? cat : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(height: 1),

          // 2. Список карточек вещeй
          Expanded(
            child: filteredItems.isEmpty
                ? Center(child: Text(l10n.emptyFeedMessage))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return ItemCard(
                        item: item,
                        onTap: () {
                          // Позже здесь откроем детальный просмотр вещи!
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddItemScreen()),
    );
  },
  backgroundColor: const Color(0xFF2ECC71),
  foregroundColor: Colors.white,
  icon: const Icon(Icons.add_rounded),
  label: Text(l10n.shareItemButton),
),

    );
  }

  // Вспомогательный метод получения локализованного названия категории
  String _getCategoryLabel(ItemCategory category, AppLocalizations l10n) {
    switch (category) {
      case ItemCategory.tools:
        return l10n.categoryTools;
      case ItemCategory.clothes:
        return l10n.categoryClothes;
      case ItemCategory.camping:
        return l10n.categoryCamping;
      case ItemCategory.home:
        return l10n.categoryHome;
      case ItemCategory.kids:
        return l10n.categoryKids;
      case ItemCategory.electronics:
        return l10n.categoryElectronics;
      case ItemCategory.auto:
        return l10n.categoryAuto;
      case ItemCategory.other:
        return l10n.categoryOther;
    }
  }
}