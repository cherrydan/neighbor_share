import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class SavedMoneyCard extends StatelessWidget {
  final double totalSaved;
  final int itemsBorrowedCount;

  const SavedMoneyCard({
    super.key,
    required this.totalSaved,
    required this.itemsBorrowedCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2ECC71).withValues(alpha: 0.20),
              Colors.green.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF2ECC71), size: 28),
                const SizedBox(width: 8),
                Text(
                  l10n.totalSavedTitle,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 🟢 Показываем точные центы через toStringAsFixed(2)!
            Text(
              '\$${totalSaved.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2ECC71),
              ),
            ),
            const SizedBox(height: 12),

            // 🟢 Крупный, чёткий и жирный текст локализации!
            Text(
              l10n.itemsBorrowedLabel(itemsBorrowedCount),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600, // 🟢 Пожирнее!
                color: Colors.black87,       // 🟢 Контрастнее!
              ),
            ),
          ],
        ),
      ),
    );
  }
}
