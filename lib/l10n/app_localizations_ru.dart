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

  @override
  String itemsBorrowedLabel(Object count) {
    return 'Одолжено вещей у соседей: $count 📦';
  }

  @override
  String get activeLoanTitle => 'Активная аренда вещeй ⏳';

  @override
  String returnTimeRemaining(Object hours) {
    return 'Осталось времени: $hours ч.';
  }

  @override
  String get loanOverdueWarning => 'Срок возврата истек! 🔴';

  @override
  String get conditionPassportTitle => 'Паспорт сохранности 🛡️';

  @override
  String get photoBeforeLabel => 'До передачи';

  @override
  String get photoAfterLabel => 'При возврате';

  @override
  String get aiInspectButton => 'AI Экспертиза сохранности 🤖';

  @override
  String get aiVerdictSuccess =>
      'Повреждений не обнаружено! Сохранность 100% ✅';

  @override
  String get addBothPhotosWarning =>
      'Пожалуйста, добавьте оба фото (До и После)!';

  @override
  String get categoryAll => 'Все 📦';

  @override
  String get categoryTools => 'Инструменты 🛠️';

  @override
  String get categoryClothes => 'Одежда 👕';

  @override
  String get categoryCamping => 'Туризм ⛺️';

  @override
  String get categoryHome => 'Дом и быт 🏠';

  @override
  String get categoryKids => 'Дети и игры 🧸';

  @override
  String get categoryElectronics => 'Электроника 🔌';

  @override
  String get categoryAuto => 'Авто и мото 🚗';

  @override
  String get categoryOther => 'Другое 📦';

  @override
  String get statusAvailable => 'Свободно';

  @override
  String get statusInUse => 'В аренде';

  @override
  String get statusRequested => 'Ищут';

  @override
  String savingsBadge(Object amount) {
    return 'Экономия: ~\$$amount';
  }

  @override
  String get shareItemButton => 'Поделиться вещью';

  @override
  String get emptyFeedMessage => 'В этой категории пока ничего нет 📦';
}
