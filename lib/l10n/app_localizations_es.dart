// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'NeighborShare';

  @override
  String get appTagline => '¡Comparte con tus vecinos — ahorra y ayuda! 🛍️🏡';

  @override
  String get feedTab => 'Artículos';

  @override
  String get mapTab => 'Mapa de artículos';

  @override
  String get profileTab => 'Perfil del vecino';

  @override
  String get estimatedValueLabel => 'Precio en tienda (\$)';

  @override
  String get totalSavedTitle => 'Dinero ahorrado';

  @override
  String get returnDateTitle => 'Devolver antes de';

  @override
  String itemsBorrowedLabel(Object count) {
    return 'Artículos pedidos a vecinos: $count 📦';
  }

  @override
  String get activeLoanTitle => 'Préstamo de artículo activo ⏳';

  @override
  String returnTimeRemaining(Object hours) {
    return 'Tiempo restante: $hours h';
  }

  @override
  String get loanOverdueWarning => '¡Plazo de devolución vencido! 🔴';

  @override
  String get conditionPassportTitle => 'Pasaporte de conservación 🛡️';

  @override
  String get photoBeforeLabel => 'Antes del préstamo';

  @override
  String get photoAfterLabel => 'Al devolver';

  @override
  String get aiInspectButton => 'Inspección IA de conservación 🤖';

  @override
  String get aiVerdictSuccess => '¡Sin daños detectados! 100% intacto ✅';

  @override
  String get addBothPhotosWarning =>
      '¡Por favor, añade ambas fotos (Antes y Después)!';

  @override
  String get categoryAll => 'Todos 📦';

  @override
  String get categoryTools => 'Herramientas 🛠️';

  @override
  String get categoryClothes => 'Ropa 👕';

  @override
  String get categoryCamping => 'Camping ⛺️';

  @override
  String get categoryHome => 'Hogar 🏠';

  @override
  String get categoryKids => 'Niños 🧸';

  @override
  String get categoryElectronics => 'Electrónica 🔌';

  @override
  String get categoryAuto => 'Auto 🚗';

  @override
  String get categoryOther => 'Otro 📦';

  @override
  String get statusAvailable => 'Disponible';

  @override
  String get statusInUse => 'En uso';

  @override
  String get statusRequested => 'Buscado';

  @override
  String savingsBadge(Object amount) {
    return 'Ahorro: ~\$$amount';
  }

  @override
  String get shareItemButton => 'Compartir artículo';

  @override
  String get emptyFeedMessage => 'Nada en esta categoría todavía 📦';

  @override
  String get addItemTitle => 'Compartir artículo';

  @override
  String get itemNameHint => 'Nombre del artículo (ej. Taladro)';

  @override
  String get itemDescHint => 'Descripción y condiciones';

  @override
  String get itemCategoryLabel => 'Categoría';

  @override
  String get itemPriceHint => 'Precio aprox. en tienda (\$)';

  @override
  String get saveButton => 'Publicar';

  @override
  String get addPhotoLabel => 'Toca para añadir foto del artículo 📷';

  @override
  String get borrowButton => 'Pedir prestado 🤝';

  @override
  String get chooseDurationTitle => '¿Por cuánto tiempo lo necesitas?';

  @override
  String durationHours(Object count) {
    return '$count h';
  }

  @override
  String durationDays(Object count) {
    return '$count días';
  }

  @override
  String get confirmBorrowButton => 'Confirmar';

  @override
  String get statusOverdue => 'Atrasado';

  @override
  String get itemDescriptionTitle => 'Descripción';

  @override
  String get itemUnavailableButton => 'No disponible';

  @override
  String get returnItemButton => 'Devolver artículo 🔄';

  @override
  String get returnSuccessMessage => '¡Artículo devuelto con éxito! 🎉';
}
