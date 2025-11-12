// Comentário: Este arquivo centraliza todas as constantes de rotas (apelidos)
//             para evitar "strings mágicas" no código de navegação.
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String policy = '/policy';
  static const String home = '/home';
  static const String profile = '/profile';

  // --- FEATURE 1: TELA DE LIÇÕES ---
  // Comentário: Adiciona a nova rota para a tela de lista de lições.
  static const String lessons = '/lessons';

  // --- FEATURE 2: TELA DE CONQUISTAS ---
  // Comentário: Adiciona a nova rota para a tela de conquistas.
  static const String achievements = '/achievements';
}