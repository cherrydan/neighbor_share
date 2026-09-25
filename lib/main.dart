import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/main_tab_screen.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Загружаем переменные окружения (.env)
  await dotenv.load(fileName: ".env");

  // Инициализируем Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2ECC71),
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = snapshot.data;

        // Если пользователь авторизован
        if (user != null) {
          return FutureBuilder(
            future: UserService().getOrCreateProfile(
              uid: user.uid,
              displayName: user.displayName,
              email: user.email,
              photoUrl: user.photoURL,
            ),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (profileSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Profile initialization error: ${profileSnapshot.error}'),
                  ),
                );
              }

              // Только после успешного создания/загрузки профиля пускаем в приложение
              return const MainTabScreen();
            },
          );
        }

        // Если не авторизован — показываем экран входа
        return const LoginScreen();
      },
    );
  }
}
