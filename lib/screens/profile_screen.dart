import 'package:flutter/material.dart';
import 'package:neighbor_share/models/item_model.dart';
import '../l10n/app_localizations.dart';
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
    const currentUserId = 'danil_user'; // Наш текущий сосед

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTab)),
      body: StreamBuilder<LoanModel?>(
        // 🟢 Слушаем реальную сделку из Firebase в реальном времени!
        stream: ItemService().getActiveLoanStream(currentUserId),
        builder: (context, snapshot) {
          final activeLoan = snapshot.data;

          // Считаем сумму экономии: если есть активная аренда — берем её сумму, иначе 0
          final double totalSaved = activeLoan != null ? activeLoan.savedAmount : 0.0;
          final int borrowedCount = activeLoan != null ? 1 : 0;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 1. Паспорт Экономии Денег (живые цифры!)
              SavedMoneyCard(
                totalSaved: totalSaved,
                itemsBorrowedCount: borrowedCount,
              ),
              const SizedBox(height: 16),

              // 2. Таймер Возврата (название вещи берем прямо из Firestore!)
              if (activeLoan != null) ...[
                FutureBuilder<ItemModel?>(
                  future: ItemService().getItemById(activeLoan.itemId),
                  builder: (context, itemSnapshot) {
                    final item = itemSnapshot.data;
                    final itemName = item?.name ?? 'Загрузка...';

                    return ReturnTimerCard(
                      loan: activeLoan,
                      itemName: itemName, // 🟢 100% из базы данных!
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 16),
              

              // 3. Паспорт Сохранности вещи с AI-экспертизой
              const ItemConditionCard(),
            ],
          );
        },
      ),
    );
  }
}
