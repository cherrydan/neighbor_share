// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'NeighborShare';

  @override
  String get appTagline => 'Делись с соседями — экономь и помогай! 🛍️🏡';

  @override
  String get feedTab => 'Лента вещeй';

  @override
  String get mapTab => 'Карта вещeй';

  @override
  String get profileTab => 'Профиль соседа';

  @override
  String get estimatedValueLabel => 'Цена в магазине (\$)';

  @override
  String get totalSavedTitle => 'Сэкономлено денег';

  @override
  String get returnDateTitle => 'Вернуть до';
}
