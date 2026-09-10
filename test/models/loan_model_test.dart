import 'package:flutter_test/flutter_test.dart';
import 'package:neighbor_share/models/item_enums.dart';
import 'package:neighbor_share/models/loan_model.dart';

void main() {
  group('LoanModel Unit Tests', () {
    test('should correctly convert LoanModel to Map and back', () {
      final now = DateTime.now();
      final returnDate = now.add(const Duration(days: 2));

      final originalLoan = LoanModel(
        id: 'loan_101',
        itemId: 'item_777',
        ownerId: 'owner_alex',
        borrowerId: 'borrower_danil',
        savedAmount: 120.0,
        returnDueDate: returnDate,
        photoBeforeUrl: 'https://cloudinary.com/before.jpg',
        photoAfterUrl: null,
        status: LoanStatus.active,
        createdAt: now,
      );

      final loanMap = originalLoan.toMap();
      final restoredLoan = LoanModel.fromMap(loanMap, 'loan_101');

      expect(restoredLoan.id, equals('loan_101'));
      expect(restoredLoan.savedAmount, equals(120.0));
      expect(restoredLoan.status, equals(LoanStatus.active));
      expect(restoredLoan.photoBeforeUrl, equals('https://cloudinary.com/before.jpg'));
    });
  });
}
