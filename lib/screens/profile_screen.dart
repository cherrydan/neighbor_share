import 'package:flutter/material.dart';
import 'package:neighbor_share/widgets/saved_money_card.dart';
import '../l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTab)),
      body: Center(
        child: SavedMoneyCard(totalSaved: 123.45, itemsBorrowedCount: 1),
      ),
    );
  }
}
