import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/item_enums.dart';
import '../models/item_model.dart';
import '../services/item_service.dart';

class ItemDetailsScreen extends StatefulWidget {
  final ItemModel item;

  const ItemDetailsScreen({
    super.key,
    required this.item,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  bool _isBorrowing = false;

  // Показываем меню выбора срока аренды
  void _showDurationPicker(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chooseDurationTitle,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildDurationOption(
                  context: bottomSheetContext,
                  label: l10n.durationHours(4),
                  duration: const Duration(hours: 4),
                  l10n: l10n,
                ),
                _buildDurationOption(
                  context: bottomSheetContext,
                  label: l10n.durationHours(12),
                  duration: const Duration(hours: 12),
                  l10n: l10n,
                ),
                _buildDurationOption(
                  context: bottomSheetContext,
                  label: l10n.durationDays(1),
                  duration: const Duration(days: 1),
                  l10n: l10n,
                ),
                _buildDurationOption(
                  context: bottomSheetContext,
                  label: l10n.durationDays(2),
                  duration: const Duration(days: 2),
                  l10n: l10n,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDurationOption({
    required BuildContext context,
    required String label,
    required Duration duration,
    required AppLocalizations l10n,
  }) {
    return ListTile(
      leading: const Icon(Icons.timer_outlined, color: Color(0xFF2ECC71)),
      title: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: () async {
        Navigator.pop(context); // Закрываем меню выбора срока
        await _borrowItem(duration);
      },
    );
  }

 Future<void> _borrowItem(Duration duration) async {
  setState(() => _isBorrowing = true);

  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not signed in');
    }

    await ItemService().borrowItem(
      item: widget.item,
      borrowerId: user.uid,
      duration: duration,
    );

    if (!mounted) return;
    Navigator.pop(context);
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ошибка: $e')),
    );
  } finally {
    if (mounted) setState(() => _isBorrowing = false);
  }
}


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isAvailable = widget.item.status == ItemStatus.available;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Изображение вещи
            Container(
              height: 240,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: widget.item.imageUrl != null
                  ? Image.network(widget.item.imageUrl!, fit: BoxFit.cover)
                  : Icon(Icons.handyman_rounded, size: 72, color: Colors.grey.shade400),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Название
                  Text(
                    widget.item.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // 3. Плашка экономии
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.savings_outlined, color: Color(0xFF2ECC71), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          l10n.savingsBadge(widget.item.estimatedValue.toStringAsFixed(0)),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2ECC71),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4. Описание
                  Text(
                    l10n.itemDescriptionTitle,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.item.description,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade800, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: isAvailable && !_isBorrowing
                ? () => _showDurationPicker(context, l10n)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2ECC71),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isBorrowing
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    isAvailable ? l10n.borrowButton : l10n.itemUnavailableButton,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }
}