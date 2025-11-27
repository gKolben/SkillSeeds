import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillseeds/core/config/app_routes.dart';
import 'package:skillseeds/core/providers/providers.dart';

// Comentário: A SplashScreen é um ConsumerWidget para ler os providers.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  // --- CORREÇÃO DO BUG: Lógica de Navegação ---
  // Comentário: Esta função decide para onde o usuário deve ir.
  void _navigate(BuildContext context, WidgetRef ref) {
    // Comentário: Lê o serviço de preferências.
    final prefsService = ref.read(prefsServiceProvider);

    // Comentário: ESTA É A CORREÇÃO PRINCIPAL.
    // Comentário: Verificamos se o 'onboarding' foi concluído,
    //             em vez de verificar o 'consentimento'.
    //             O 'onboarding' SÓ é concluído DEPOIS do consentimento.
    if (prefsService.isOnboardingCompleted()) {
      // Comentário: Se o onboarding foi concluído, vai para a Home.
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      // Comentário: Se não, vai para o Onboarding (que depois leva à PolicyScreen).
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Comentário: O 'ref.listen' é a forma correta de disparar uma navegação
    //             quando um provider é carregado (como o SharedPreferences).
    ref.listen<AsyncValue>(sharedPreferencesProvider, (_, state) {
      // Comentário: Só navega quando o 'state' for 'AsyncData'
      //             (ou seja, o SharedPreferences terminou de carregar).
      if (state is AsyncData) {
        // Comentário: Um pequeno atraso para a marca (logo) ser visível.
        // Protegemos a navegação contra o `context` desmontado verificando
        // `context.mounted` antes de chamar o navigator após o delay.
        Future.delayed(const Duration(seconds: 3), () {
          if (!context.mounted) return;
          _navigate(context, ref);
        });
      }
    });

    // Comentário: A UI da SplashScreen (o logo).
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_icon.png',
              height: 120,
            ),
            const SizedBox(height: 24),
            const Text(
              'SkillSeeds',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
