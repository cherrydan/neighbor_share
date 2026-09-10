import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/loan_model.dart';

class ReturnTimerCard extends StatelessWidget {
  final LoanModel loan;
  final String itemName;

  const ReturnTimerCard({
    super.key,
    required this.loan,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = loan.returnDueDate.difference(now);
    final isOverdue = difference.isNegative;
    final hoursRemaining = difference.inHours;

    final Color statusColor = isOverdue ? Colors.red : Colors.amber.shade800;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
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
                    itemName,
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
      ),
    );
  }
}
