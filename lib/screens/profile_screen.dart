import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/item_enums.dart';
import '../models/loan_model.dart';
import '../widgets/return_timer_card.dart';
import '../widgets/saved_money_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Фейковая тестовая аренда на 5 часов для проверки UI
    final sampleLoan = LoanModel(
      id: 'loan_1',
      itemId: 'item_1',
      ownerId: 'owner_1',
      borrowerId: 'borrower_1',
      savedAmount: 120.0,
      returnDueDate: DateTime.now().add(const Duration(hours: 5)),
      status: LoanStatus.active,
      createdAt: DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTab)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Паспорт Экономии Денег
          const SavedMoneyCard(
            totalSaved: 123.45,
            itemsBorrowedCount: 1,
          ),
          const SizedBox(height: 16),

          // 2. Таймер Возврата Вещи
          ReturnTimerCard(
            loan: sampleLoan,
            itemName: 'Перфоратор Bosch',
          ),
        ],
      ),
    );
  }
}
