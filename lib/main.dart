import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'screens/main_tab_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NeighborShareApp());
}

class NeighborShareApp extends StatelessWidget {
  const NeighborShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeighborShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2ECC71)),
        useMaterial3: true,
      ),
      // 🟢 Register all 4 localization delegates (RU, EN, ES, PT)
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainTabScreen(),
    );
  }
}
