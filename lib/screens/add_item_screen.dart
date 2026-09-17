import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neighbor_share/services/cloudinary_service.dart';
import '../l10n/app_localizations.dart';
import '../models/item_enums.dart';
import '../models/item_model.dart';
import '../services/item_service.dart';

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
  Uint8List? _imageBytes; // 🟢 Байты выбранной картинки
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // 🟢 Метод выбора фото из галереи/камеры
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

    // 🟢 1. СРАЗУ включаем крутилку загрузки:
    setState(() => _isSaving = true);

    try {
      // 🟢 2. Грузим фото, если оно выбрано
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
        latitude: 38.7223,
        longitude: -9.1393,
        ownerId: 'danil_user',
        createdAt: DateTime.now(),
        estimatedValue: price,
      );

      // 🟢 3. Пишем в Firestore
      await ItemService().addItem(newItem);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
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
            // 🟢 0. Слот для добавления Фотографии (в самом верху!)
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

            // 5. Кнопка сохранения
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