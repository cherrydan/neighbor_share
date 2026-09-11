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
}
