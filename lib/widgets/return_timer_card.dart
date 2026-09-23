import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/loan_model.dart';
import '../services/item_service.dart';

class ReturnTimerCard extends StatefulWidget {
  final LoanModel loan;
  final String itemName;

  const ReturnTimerCard({
    super.key,
    required this.loan,
    required this.itemName,
  });

  @override
  State<ReturnTimerCard> createState() => _ReturnTimerCardState();
}

class _ReturnTimerCardState extends State<ReturnTimerCard> {
  bool _isReturning = false;

  Future<void> _handleReturn(BuildContext context, AppLocalizations l10n) async {
    setState(() => _isReturning = true);

    try {
      // 🟢 Завершаем сделку и освобождаем вещь в Firestore!
      await ItemService().returnItem(
        loanId: widget.loan.id,
        itemId: widget.loan.itemId,
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.returnSuccessMessage),
          backgroundColor: const Color(0xFF2ECC71),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка возврата: $e')),
      );
    } finally {
      if (mounted) setState(() => _isReturning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = widget.loan.returnDueDate.difference(now);
    final isOverdue = difference.isNegative;
    final hoursRemaining = difference.inHours;

    final Color statusColor = isOverdue ? Colors.red.shade700 : Colors.amber.shade800;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // Иконка статуса
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isOverdue ? Icons.warning_amber_rounded : Icons.timer_rounded,
                    color: statusColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Название вещи и таймер
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isOverdue
                            ? l10n.loanOverdueWarning
                            : l10n.returnTimeRemaining(hoursRemaining),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 🟢 Кнопка возврата вещи хозяину
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isReturning ? null : () => _handleReturn(context, l10n),
                icon: _isReturning
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.assignment_return_rounded),
                label: Text(l10n.returnItemButton),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2ECC71),
                  side: const BorderSide(color: Color(0xFF2ECC71), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}