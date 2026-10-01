import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:neighbor_share/screens/paywall_screen.dart';
import 'package:neighbor_share/services/user_service.dart';

import '../l10n/app_localizations.dart';
import '../models/item_enums.dart';
import '../models/item_model.dart';
import '../services/cloudinary_service.dart';
import '../services/item_service.dart';
import '../services/location_service.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();

  ItemCategory _selectedCategory = ItemCategory.tools;
  Uint8List? _imageBytes;
  bool _isSaving = false;

  // 🟢 Текущая выбранная геопозиция (по умолчанию Лиссабон)
  LatLng _selectedLocation = const LatLng(38.7223, -9.1393);
  final MapController _mapController = MapController();
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    // 🟢 При входе автоматически запрашиваем реальный GPS
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    final pos = await LocationService.getCurrentLocation();
    if (!mounted) return;
    setState(() {
      _selectedLocation = pos;
      _isLoadingLocation = false;
    });
    _mapController.move(pos, 14.0);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

    Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка: войдите в аккаунт!')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // 🟢 1. Проверяем лимиты бесплатного тарифа
      final int activeItemsCount = await ItemService().getUserItemsCount(user.uid);
      final profile = await UserService().getOrCreateProfile(uid: user.uid);

      if (activeItemsCount >= 2 && !profile.isPro) {
        // Если вещей уже 2 или больше, и юзер не PRO — отменяем сохранение и шлем на Пейволл!
        setState(() => _isSaving = false);
        if (!mounted) return;
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaywallScreen()),
        );
        return;
      }

      // 🟢 2. Если лимиты не превышены — идет стандартная публикация...
      String? uploadedUrl;
      if (_imageBytes != null) {
        uploadedUrl = await CloudinaryService.uploadImage(_imageBytes!);
      }

      final double price = double.tryParse(_priceController.text) ?? 0.0;

      final newItem = ItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        category: _selectedCategory,
        status: ItemStatus.available,
        imageUrl: uploadedUrl,
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
        ownerId: user.uid,
        createdAt: DateTime.now(),
        estimatedValue: price,
      );

      await ItemService().addItem(newItem);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сохранения: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addItemTitle),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 0. Слот для добавления Фотографии
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                ),
                child: _imageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.memory(_imageBytes!, fit: BoxFit.cover, width: double.infinity),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_rounded, size: 42, color: Colors.grey.shade500),
                          const SizedBox(height: 8),
                          Text(
                            l10n.addPhotoLabel,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // 1. Название
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.itemNameHint,
                border: const OutlineInputBorder(),
              ),
              validator: (val) => val == null || val.isEmpty ? 'Заполните название' : null,
            ),
            const SizedBox(height: 16),

            // 2. Описание
            TextFormField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.itemDescHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Выбор Категории
            DropdownButtonFormField<ItemCategory>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: l10n.itemCategoryLabel,
                border: const OutlineInputBorder(),
              ),
              items: ItemCategory.values.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
            const SizedBox(height: 16),

            // 4. Примерная цена
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.itemPriceHint,
                border: const OutlineInputBorder(),
                prefixText: '\$ ',
              ),
            ),
            const SizedBox(height: 24),

            // 🟢 5. Блок выбора местоположения на карте
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.locationPickerTitle,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: _isLoadingLocation ? null : _fetchCurrentLocation,
                      icon: _isLoadingLocation
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location_rounded, size: 18),
                      label: Text(
                        l10n.useCurrentLocationButton,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),

            Text(
              l10n.tapMapHint,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),

            // Мини-карта с интерактивным тапом!
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              clipBehavior: Clip.antiAlias,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _selectedLocation,
                  initialZoom: 14.0,
                  // 🟢 Клик по карте перемещает маркер!
                  onTap: (tapPosition, point) {
                    setState(() {
                      _selectedLocation = point;
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.neighbor_share',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Colors.red,
                          size: 38,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 6. Кнопка сохранения
            ElevatedButton(
              onPressed: _isSaving ? null : _saveItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(l10n.saveButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}