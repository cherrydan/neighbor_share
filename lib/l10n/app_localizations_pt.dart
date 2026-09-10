// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'NeighborShare';

  @override
  String get appTagline => 'Partilhe com os vizinhos — poupe e ajude! 🛍️🏡';

  @override
  String get feedTab => 'Itens dos vizinhos';

  @override
  String get mapTab => 'Mapa de itens';

  @override
  String get profileTab => 'Perfil do vizinho';

  @override
  String get estimatedValueLabel => 'Preço na loja (\$)';

  @override
  String get totalSavedTitle => 'Dinheiro poupado';

  @override
  String get returnDateTitle => 'Devolver até';

  @override
  String itemsBorrowedLabel(Object count) {
    return 'Itens pedidos aos vizinhos: $count 📦';
  }

  @override
  String get activeLoanTitle => 'Empréstimo de item ativo ⏳';

  @override
  String returnTimeRemaining(Object hours) {
    return 'Tempo restante: $hours h';
  }

  @override
  String get loanOverdueWarning => 'Prazo de devolução vencido! 🔴';
}
