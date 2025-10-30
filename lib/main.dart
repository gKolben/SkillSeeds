import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillseeds/config/app_routes.dart';
import 'package:skillseeds/config/app_theme.dart';
import 'package:skillseeds/screens/home_screen.dart';
import 'package:skillseeds/screens/onboarding_screen.dart';
import 'package:skillseeds/screens/policy_screen.dart';
import 'package:skillseeds/screens/splash_screen.dart';
import 'package:skillseeds/screens/profile_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
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