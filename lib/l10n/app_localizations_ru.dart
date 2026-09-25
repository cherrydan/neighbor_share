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

  @override
  String get addItemTitle => 'Поделиться вещью';

  @override
  String get itemNameHint => 'Название вещи (напр. Дрель)';

  @override
  String get itemDescHint => 'Описание и условия передачи';

  @override
  String get itemCategoryLabel => 'Категория';

  @override
  String get itemPriceHint => 'Примерная цена в магазине (\$)';

  @override
  String get saveButton => 'Опубликовать';

  @override
  String get addPhotoLabel => 'Нажмите, чтобы добавить фото вещи 📷';

  @override
  String get borrowButton => 'Одолжить вещь 🤝';

  @override
  String get chooseDurationTitle => 'На какой срок вам нужна вещь?';

  @override
  String durationHours(Object count) {
    return '$count ч.';
  }

  @override
  String durationDays(Object count) {
    return '$count дн.';
  }

  @override
  String get confirmBorrowButton => 'Подтвердить';

  @override
  String get statusOverdue => 'Просрочено';

  @override
  String get itemDescriptionTitle => 'Описание';

  @override
  String get itemUnavailableButton => 'Недоступно';

  @override
  String get returnItemButton => 'Вернуть вещь 🔄';

  @override
  String get returnSuccessMessage => 'Вещь успешно возвращена хозяину! 🎉';

  @override
  String get signInTitle => 'Добро пожаловать в NeighborShare';

  @override
  String get signInWithGoogle => 'Войти через Google';

  @override
  String get trustScoreTitle => 'Надёжность соседа 🛡️';

  @override
  String trustScorePoints(Object score) {
    return '$score баллов';
  }

  @override
  String get signOut => 'Выйти';

  @override
  String get loadingLabel => 'Загрузка…';

  @override
  String get profileInitializationError => 'Не удалось загрузить профиль';

  @override
  String get returnError => 'Не удалось вернуть вещь';
}
