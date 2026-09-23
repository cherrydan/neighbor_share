import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../l10n/app_localizations.dart';
import '../models/item_enums.dart';
import '../models/item_model.dart';
import '../services/item_service.dart';
import 'item_details_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Дефолтный центр карты (Лиссабон, Португалия 🇵🇹)
    const initialCenter = LatLng(38.7223, -9.1393);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mapTab),
      ),
      body: StreamBuilder<List<ItemModel>>(
        stream: ItemService().getItemsStream(),
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];

          // Генерируем маркеры для каждой вещи из базы данных
          final markers = items.map((item) {
            return Marker(
              point: LatLng(item.latitude, item.longitude),
              width: 50,
              height: 50,
              child: GestureDetector(
                onTap: () => _showItemPreview(context, item, l10n),
                child: _buildMarkerIcon(item),
              ),
            );
          }).toList();

          return FlutterMap(
            options: const MapOptions(
              initialCenter: initialCenter,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.neighbor_share',
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
      ),
    );
  }

  // Виджет красивого круглого маркера с иконкой категории и цветом статуса
  Widget _buildMarkerIcon(ItemModel item) {
    Color markerColor;
    switch (item.status) {
      case ItemStatus.available:
        markerColor = const Color(0xFF2ECC71); // Зеленый
        break;
      case ItemStatus.inUse:
        markerColor = Colors.orange; // Оранжевый
        break;
      case ItemStatus.overdue:
        markerColor = Colors.red.shade700; // Красный
        break;
      case ItemStatus.requested:
        markerColor = Colors.blue;
        break;
    }

    IconData iconData;
    switch (item.category) {
      case ItemCategory.tools:
        iconData = Icons.build_rounded;
        break;
      case ItemCategory.clothes:
        iconData = Icons.checkroom_rounded;
        break;
      case ItemCategory.camping:
        iconData = Icons.nature_people_rounded;
        break;
      case ItemCategory.home:
        iconData = Icons.home_rounded;
        break;
      case ItemCategory.kids:
        iconData = Icons.toys_rounded;
        break;
      case ItemCategory.electronics:
        iconData = Icons.electrical_services_rounded;
        break;
      case ItemCategory.auto:
        iconData = Icons.directions_car_rounded;
        break;
      case ItemCategory.other:
        iconData = Icons.inventory_2_rounded;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: markerColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Icon(iconData, color: Colors.white, size: 24),
    );
  }

  // Всплывающая плашка превью при клике на маркер
  void _showItemPreview(BuildContext context, ItemModel item, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Миниатюра фото
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey.shade200,
                    child: item.imageUrl != null
                        ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                        : const Icon(Icons.handyman_rounded, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 16),

                // Инфо
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.savingsBadge(item.estimatedValue.toStringAsFixed(0)),
                        style: const TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // Кнопка открыть детали
                IconButton.filled(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ItemDetailsScreen(item: item),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_rounded),
                  style: IconButton.styleFrom(backgroundColor: const Color(0xFF2ECC71)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}