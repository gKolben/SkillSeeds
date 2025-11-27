// Comentário: Centraliza todas as chaves (strings) usadas no SharedPreferences
//             para evitar erros de digitação.
class PrefsKeys {
  // Comentário: Chaves de Consentimento (LGPD)
  static const String policyVersionAccepted = 'policies_version_accepted';
  static const String acceptedAt = 'accepted_at';

  // --- CORREÇÃO DO BUG: Chave de Onboarding ---
  // Comentário: Adiciona a chave para o status do onboarding.
  static const String onboardingCompleted = 'onboarding_completed';

  // Comentário: Chaves do Perfil do Utilizador
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';

  // Comentário: Chave do Consentimento de Marketing
  static const String marketingConsent = 'marketing_consent';
}
