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

  @override
  String get itemDescriptionTitle => 'Description';

  @override
  String get itemUnavailableButton => 'Unavailable';

  @override
  String get returnItemButton => 'Return Item 🔄';

  @override
  String get returnSuccessMessage => 'Item successfully returned to owner! 🎉';

  @override
  String get signInTitle => 'Welcome to NeighborShare';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get trustScoreTitle => 'Neighbor Trust 🛡️';

  @override
  String trustScorePoints(Object score) {
    return '$score points';
  }

  @override
  String get signOut => 'Sign out';

  @override
  String get loadingLabel => 'Loading…';

  @override
  String get profileInitializationError => 'Failed to load profile';

  @override
  String get returnError => 'Failed to return item';

  @override
  String get locationPickerTitle => 'Item Location on Map 📍';

  @override
  String get useCurrentLocationButton => 'Use My Current GPS Location 🎯';

  @override
  String get tapMapHint => 'Tap on the map to adjust location 🗺️';

  @override
  String get deleteItemButton => 'Delete Item 🗑️';

  @override
  String get deleteItemConfirmTitle => 'Delete Item Listing?';

  @override
  String get deleteItemConfirmBody =>
      'Are you sure you want to remove this item? The publishing bonus (+5 pts) will be reverted.';

  @override
  String get cannotDeleteInUseError =>
      'Cannot delete an item that is currently borrowed or overdue!';

  @override
  String get showItemOnMap => 'Show on map';

  @override
  String get itemDetailsButton => 'Open item details';

  @override
  String get proTitle => 'Become a PRO Neighbor! 💎';

  @override
  String get proSubtitle => 'Support your community and unlock all features';

  @override
  String get proFeatureAI => 'Unlimited AI item inspection 🤖';

  @override
  String get proFeatureUnlimited => 'Unlimited item listings 📦';

  @override
  String get proFeatureBadge => 'Golden profile frame & Elite status 👑';

  @override
  String get proPrice => '\$1.99 / month';

  @override
  String get subscribeButton => 'Start 7-day Free Trial';

  @override
  String get restorePurchases => 'Restore purchases';
}
