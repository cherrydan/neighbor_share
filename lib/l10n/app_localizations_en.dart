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
}
