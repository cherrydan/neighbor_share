import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:neighbor_share/firebase_options.dart';
import 'package:neighbor_share/screens/login_screen.dart';
import 'package:neighbor_share/services/auth_service.dart';
import 'l10n/app_localizations.dart';
import 'screens/main_tab_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 🟢 Load environment variables from .env file
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NeighborShareApp());
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const MainTabScreen();
        }

        return const LoginScreen();
      },
    );
  }
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
      home: const AuthGate(),
    );
  }
}
