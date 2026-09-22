import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/item_enums.dart';
import '../models/item_model.dart';
import '../models/loan_model.dart';
import '../services/item_service.dart';
import '../widgets/item_condition_card.dart';
import '../widgets/return_timer_card.dart';
import '../widgets/saved_money_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const currentUserId = 'danil_user';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTab)),
      body: StreamBuilder<LoanModel?>(
        stream: ItemService().getActiveLoanStream(currentUserId),
        builder: (context, snapshot) {
          final activeLoan = snapshot.data;

          final double totalSaved = activeLoan != null ? activeLoan.savedAmount : 0.0;
          final int borrowedCount = activeLoan != null ? 1 : 0;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 1. Паспорт Экономии Денег
              SavedMoneyCard(
                totalSaved: totalSaved,
                itemsBorrowedCount: borrowedCount,
              ),
              const SizedBox(height: 16),

              // 2. Блок активной аренды
              if (activeLoan != null)
                FutureBuilder<ItemModel?>(
                  future: ItemService().getItemById(activeLoan.itemId),
                  builder: (context, itemSnapshot) {
                    final item = itemSnapshot.data;
                    final itemName = item?.name ?? 'Загрузка...';
                    final itemDesc = item?.description;

                    // Авто-обновление статуса на Overdue, если срок вышел
                    final bool isOverdue = activeLoan.returnDueDate.isBefore(DateTime.now());
                    if (isOverdue && item != null && item.status != ItemStatus.overdue) {
                      ItemService().markItemOverdue(activeLoan.itemId);
                    }

                    return Column(
                      children: [
                        ReturnTimerCard(
                          loan: activeLoan,
                          itemName: itemName,
                        ),
                        const SizedBox(height: 16),
                        ItemConditionCard(
                          itemName: itemName,
                          itemDescription: itemDesc,
                        ),
                      ],
                    );
                  },
                )
              else
                const ItemConditionCard(),
            ],
          );
        },
      ),
    );
  }
}
