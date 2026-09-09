import 'item_enums.dart';

class ItemModel {
  final String id;
  final String name;
  final String description;
  final ItemCategory category;
  final ItemStatus status;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  final String ownerId;
  final DateTime createdAt;

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.status,
    this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.ownerId,
    required this.createdAt,
  });

  // Convert ItemModel to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category.name,
      'status': status.name,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Factory constructor to deserialize Firestore Map to ItemModel
  factory ItemModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    return ItemModel(
      id: docId ?? map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: ItemCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => ItemCategory.other,
      ),
      status: ItemStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ItemStatus.available,
      ),
      imageUrl: map['imageUrl'],
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      ownerId: map['ownerId'] ?? 'anonymous',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'].toString())
          : DateTime.now(),
    );
  }
}
