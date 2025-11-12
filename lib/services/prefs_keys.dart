// Comentário: Centraliza todas as chaves (strings) usadas no SharedPreferences
//             para evitar erros de digitação.
class PrefsKeys {
  // Chaves de Consentimento Principal (LGPD)
  static const String policyVersionAccepted = 'policies_version_accepted';
  static const String acceptedAt = 'accepted_at';

  // --- CORREÇÃO DO BUG ---
  // Comentário: Adiciona a chave para sabermos se o usuário completou
  //             o fluxo de onboarding/políticas pela primeira vez.
  static const String onboardingCompleted = 'onboarding_completed';
  // --- FIM DA CORREÇÃO ---

  // Chaves do Perfil do Usuário
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';

  // Chave de Consentimento Granular
  static const String marketingConsent = 'marketing_consent';

  // Chave do Cache de Trilhas
  // (Ainda não estamos usando, mas está aqui)
  static const String tracksCache = 'tracks_cache';
}