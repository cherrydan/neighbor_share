import 'package:flutter/material.dart';
import 'package:neighbor_share/l10n/app_localizations.dart';
import '../models/item_enums.dart';
import '../models/item_model.dart';

class ItemCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Выбираем цвет и текст для статуса
    Color statusColor;
    String statusText;
    switch (item.status) {
      case ItemStatus.available:
        statusColor = const Color(0xFF2ECC71);
        statusText = l10n.statusAvailable;
        break;
      case ItemStatus.inUse:
        statusColor = Colors.orange;
        statusText = l10n.statusInUse;
        break;
      case ItemStatus.overdue: // 🔴 Тревожный красный бейдж для просрочки!
        statusColor = Colors.red.shade700;
        statusText = l10n.statusOverdue;
        break;
      case ItemStatus.requested:
        statusColor = Colors.blue;
        statusText = l10n.statusRequested;
        break;

    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Верхняя плашка с фото или заглушкой
            Container(
              height: 140,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: item.imageUrl != null
                  ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                  : Icon(Icons.handyman_rounded, size: 48, color: Colors.grey.shade400),
            ),

            // 2. Инфо-блок
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Название
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Статус бейдж
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Описание
                  Text(
                    item.description,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Плашка экономии
                  Row(
                    children: [
                      const Icon(Icons.savings_outlined, size: 16, color: Color(0xFF2ECC71)),
                      const SizedBox(width: 4),
                      Text(
                      l10n.savingsBadge(item.estimatedValue.toStringAsFixed(0)),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2ECC71),
                      ),
                    ),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}