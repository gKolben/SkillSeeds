import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillseeds/config/app_routes.dart';
import 'package:skillseeds/config/app_theme.dart';
import 'package:skillseeds/screens/home_screen.dart';
import 'package:skillseeds/screens/onboarding_screen.dart';
import 'package:skillseeds/screens/policy_screen.dart';
import 'screens/profile_screen.dart';
import 'package:skillseeds/screens/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- CARREGAR O .env ---
  // (Conforme o guia, o .env deve estar na raiz do projeto e listado no pubspec.yaml)
  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  // --- VALIDAR E INICIALIZAR O SUPABASE ---
  if (supabaseUrl == null || supabaseAnonKey == null) {
    // Lança um erro claro se as chaves não estiverem no .env
    throw Exception('Faltam SUPABASE_URL ou SUPABASE_ANON_KEY no arquivo .env');
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  // --- FIM DA CONFIGURAÇÃO DO SUPABASE ---

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillSeeds',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.policy: (context) => const PolicyScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
      },
    );
  }
}