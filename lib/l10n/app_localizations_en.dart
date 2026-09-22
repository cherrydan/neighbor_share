// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NeighborShare';

  @override
  String get appTagline => 'Share with neighbors — save & help! 🛍️🏡';

  @override
  String get feedTab => 'Items Feed';

  @override
  String get mapTab => 'Items Map';

  @override
  String get profileTab => 'Neighbor Profile';

  @override
  String get estimatedValueLabel => 'Store price (\$)';

  @override
  String get totalSavedTitle => 'Money Saved';

  @override
  String get returnDateTitle => 'Return due';

  @override
  String itemsBorrowedLabel(Object count) {
    return 'Items borrowed from neighbors: $count 📦';
  }

  @override
  String get activeLoanTitle => 'Active Item Loan ⏳';

  @override
  String returnTimeRemaining(Object hours) {
    return 'Time remaining: $hours hrs';
  }

  @override
  String get loanOverdueWarning => 'Return date overdue! 🔴';

  @override
  String get conditionPassportTitle => 'Condition Passport 🛡️';

  @override
  String get photoBeforeLabel => 'Before Loan';

  @override
  String get photoAfterLabel => 'Upon Return';

  @override
  String get aiInspectButton => 'AI Condition Inspection 🤖';

  @override
  String get aiVerdictSuccess => 'No damages detected! 100% Intact ✅';

  @override
  String get addBothPhotosWarning =>
      'Please add both photos (Before and After)!';

  @override
  String get categoryAll => 'All 📦';

  @override
  String get categoryTools => 'Tools 🛠️';

  @override
  String get categoryClothes => 'Clothes 👕';

  @override
  String get categoryCamping => 'Camping ⛺️';

  @override
  String get categoryHome => 'Home 🏠';

  @override
  String get categoryKids => 'Kids 🧸';

  @override
  String get categoryElectronics => 'Electronics 🔌';

  @override
  String get categoryAuto => 'Auto 🚗';

  @override
  String get categoryOther => 'Other 📦';

  @override
  String get statusAvailable => 'Available';

  @override
  String get statusInUse => 'In Use';

  @override
  String get statusRequested => 'Requested';

  @override
  String savingsBadge(Object amount) {
    return 'Savings: ~\$$amount';
  }

  @override
  String get shareItemButton => 'Share an Item';

  @override
  String get emptyFeedMessage => 'Nothing in this category yet 📦';

  @override
  String get addItemTitle => 'Share an Item';

  @override
  String get itemNameHint => 'Item name (e.g. Drill)';

  @override
  String get itemDescHint => 'Description & loan terms';

  @override
  String get itemCategoryLabel => 'Category';

  @override
  String get itemPriceHint => 'Est. store price (\$)';

  @override
  String get saveButton => 'Publish';

  @override
  String get addPhotoLabel => 'Tap to add item photo 📷';

  @override
  String get borrowButton => 'Borrow Item 🤝';

  @override
  String get chooseDurationTitle => 'How long do you need it for?';

  @override
  String durationHours(Object count) {
    return '$count hrs';
  }

  @override
  String durationDays(Object count) {
    return '$count days';
  }

  @override
  String get confirmBorrowButton => 'Confirm';

  @override
  String get statusOverdue => 'Overdue';
}
