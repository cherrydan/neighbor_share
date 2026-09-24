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

  @override
  String get conditionPassportTitle => 'Passaporte de conservação 🛡️';

  @override
  String get photoBeforeLabel => 'Antes do empréstimo';

  @override
  String get photoAfterLabel => 'Na devolução';

  @override
  String get aiInspectButton => 'Inspeção IA de conservação 🤖';

  @override
  String get aiVerdictSuccess => 'Sem danos detetados! 100% intacto ✅';

  @override
  String get addBothPhotosWarning =>
      'Por favor, adicione ambas as fotos (Antes e Depois)!';

  @override
  String get categoryAll => 'Todos 📦';

  @override
  String get categoryTools => 'Ferramentas 🛠️';

  @override
  String get categoryClothes => 'Roupas 👕';

  @override
  String get categoryCamping => 'Campismo ⛺️';

  @override
  String get categoryHome => 'Casa 🏠';

  @override
  String get categoryKids => 'Crianças 🧸';

  @override
  String get categoryElectronics => 'Eletrónicos 🔌';

  @override
  String get categoryAuto => 'Auto 🚗';

  @override
  String get categoryOther => 'Outro 📦';

  @override
  String get statusAvailable => 'Disponível';

  @override
  String get statusInUse => 'Em uso';

  @override
  String get statusRequested => 'Procurado';

  @override
  String savingsBadge(Object amount) {
    return 'Poupança: ~\$$amount';
  }

  @override
  String get shareItemButton => 'Partilhar um item';

  @override
  String get emptyFeedMessage => 'Ainda nada nesta categoria 📦';

  @override
  String get addItemTitle => 'Partilhar um item';

  @override
  String get itemNameHint => 'Nome do item (ex. Berbequim)';

  @override
  String get itemDescHint => 'Descrição e termos do empréstimo';

  @override
  String get itemCategoryLabel => 'Categoria';

  @override
  String get itemPriceHint => 'Preço aprox. na loja (\$)';

  @override
  String get saveButton => 'Publicar';

  @override
  String get addPhotoLabel => 'Toque para adicionar foto do item 📷';

  @override
  String get borrowButton => 'Pedir emprestado 🤝';

  @override
  String get chooseDurationTitle => 'Por quanto tempo precisa do item?';

  @override
  String durationHours(Object count) {
    return '$count h';
  }

  @override
  String durationDays(Object count) {
    return '$count dias';
  }

  @override
  String get confirmBorrowButton => 'Confirmar';

  @override
  String get statusOverdue => 'Em atraso';

  @override
  String get itemDescriptionTitle => 'Descrição';

  @override
  String get itemUnavailableButton => 'Indisponível';

  @override
  String get returnItemButton => 'Devolver item 🔄';

  @override
  String get returnSuccessMessage => 'Item devolvido com sucesso! 🎉';

  @override
  String get signInTitle => 'Bem-vindo ao NeighborShare';

  @override
  String get signInWithGoogle => 'Entrar com o Google';
}
