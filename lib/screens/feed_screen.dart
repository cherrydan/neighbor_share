import 'package:flutter/material.dart';
import 'package:neighbor_share/screens/item_details_screen.dart';
import '../l10n/app_localizations.dart';
import '../models/item_enums.dart';
import '../models/item_model.dart';
import '../services/item_service.dart';
import '../widgets/item_card.dart';
import 'add_item_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  ItemCategory? _selectedCategory;
  final ItemService _itemService = ItemService();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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

          // 2. 🟢 Живой StreamBuilder из облачной базы Firestore!
          Expanded(
            child: StreamBuilder<List<ItemModel>>(
              stream: _itemService.getItemsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Ошибка загрузки: ${snapshot.error}'),
                  );
                }

                final items = snapshot.data ?? [];

                // Фильтруем по категории локально
                final filteredItems = _selectedCategory == null
                    ? items
                    : items.where((i) => i.category == _selectedCategory).toList();

                if (filteredItems.isEmpty) {
                  return Center(
                    child: Text(l10n.emptyFeedMessage),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return ItemCard(
                            item: item,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemDetailsScreen(item: item),
                                ),
                              );
                            },
                          );

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