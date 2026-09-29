import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../l10n/app_localizations.dart';
import '../models/item_enums.dart';
import '../models/item_model.dart';
import '../services/item_service.dart';
import 'item_details_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  bool _mapReady = false;
  LatLng? _pendingTarget;
  ItemModel? _selectedItem;

  static const LatLng _initialCenter = LatLng(
    38.7223,
    -9.1393,
  );

  /// Перемещает карту к выбранной вещи.
  ///
  /// Если карта еще не успела инициализироваться,
  /// координаты сохраняются и применяются после onMapReady.
  void moveToItem(ItemModel item) {
    final target = LatLng(
      item.latitude,
      item.longitude,
    );

    setState(() {
      _selectedItem = item;
    });

    if (!_mapReady) {
      _pendingTarget = target;
      return;
    }

    _mapController.move(target, 16.0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mapTab),
      ),
      body: StreamBuilder<List<ItemModel>>(
        stream: ItemService().getItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Map loading error: ${snapshot.error}'),
            );
          }

          final items = snapshot.data ?? [];

          final markers = items.map((item) {
            final isSelected = _selectedItem?.id == item.id;

            return Marker(
              point: LatLng(
                item.latitude,
                item.longitude,
              ),
              width: isSelected ? 62 : 50,
              height: isSelected ? 62 : 50,
              child: GestureDetector(
                onTap: () => _showItemPreview(
                  context,
                  item,
                  l10n,
                ),
                child: _buildMarkerIcon(
                  item,
                  isSelected: isSelected,
                ),
              ),
            );
          }).toList();

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 13.0,
              onMapReady: () {
                _mapReady = true;

                final target = _pendingTarget;
                if (target != null) {
                  _pendingTarget = null;
                  _mapController.move(target, 16.0);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.neighbor_share',
              ),
              MarkerLayer(
                markers: markers,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMarkerIcon(
    ItemModel item, {
    required bool isSelected,
  }) {
    final markerColor = _markerColor(item.status);
    final iconData = _categoryIcon(item.category);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: markerColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: isSelected ? 3.5 : 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: isSelected ? 10 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        iconData,
        color: Colors.white,
        size: isSelected ? 30 : 24,
      ),
    );
  }

  Color _markerColor(ItemStatus status) {
    switch (status) {
      case ItemStatus.available:
        return const Color(0xFF2ECC71);
      case ItemStatus.inUse:
        return Colors.orange;
      case ItemStatus.overdue:
        return Colors.red.shade700;
      case ItemStatus.requested:
        return Colors.blue;
    }
  }

  IconData _categoryIcon(ItemCategory category) {
    switch (category) {
      case ItemCategory.tools:
        return Icons.build_rounded;
      case ItemCategory.clothes:
        return Icons.checkroom_rounded;
      case ItemCategory.camping:
        return Icons.nature_people_rounded;
      case ItemCategory.home:
        return Icons.home_rounded;
      case ItemCategory.kids:
        return Icons.toys_rounded;
      case ItemCategory.electronics:
        return Icons.electrical_services_rounded;
      case ItemCategory.auto:
        return Icons.directions_car_rounded;
      case ItemCategory.other:
        return Icons.inventory_2_rounded;
    }
  }

  void _showItemPreview(
    BuildContext context,
    ItemModel item,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: item.imageUrl != null
                        ? Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.handyman_rounded, color: Colors.grey);
                          }

                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.handyman_rounded,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.savingsBadge(
                          item.estimatedValue.toStringAsFixed(0),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF2ECC71),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filled(
                  tooltip: l10n.itemDetailsButton,
                  onPressed: () {
                    Navigator.pop(sheetContext);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ItemDetailsScreen(item: item),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF2ECC71),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}