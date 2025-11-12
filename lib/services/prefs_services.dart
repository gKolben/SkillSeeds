// Comentário: Importa a biblioteca de persistência local (SharedPreferences).
import 'package:shared_preferences/shared_preferences.dart';
// Comentário: Importa o nosso arquivo de chaves centralizadas.
import 'package:skillseeds/services/prefs_keys.dart';

// Comentário: Esta classe é um "Service". A sua única responsabilidade
//             é ler e escrever no SharedPreferences.
class PrefsService {
  // Comentário: Uma instância privada do SharedPreferences que será injetada.
  final SharedPreferences _prefs;

  // Comentário: Construtor que recebe o SharedPreferences (Injeção de Dependência).
  PrefsService(this._prefs);

  /*
   * =======================================
   * Métodos de Consentimento (LGPD)
   * =======================================
   */

  // Comentário: Verifica se o utilizador já deu o consentimento para a versão 'v1'.
  bool isConsentGiven() {
    return _prefs.getString(PrefsKeys.policyVersionAccepted) == 'v1';
  }

  // Comentário: Guarda o consentimento principal do utilizador e a data do aceite.
  Future<void> saveConsent() async {
    await _prefs.setString(PrefsKeys.policyVersionAccepted, 'v1');
    await _prefs.setString(
        PrefsKeys.acceptedAt, DateTime.now().toIso8601String());
  }

  // Comentário: Limpa o consentimento principal (usado na função de revogação).
  Future<void> clearConsent() async {
    await _prefs.remove(PrefsKeys.policyVersionAccepted);
    await _prefs.remove(PrefsKeys.acceptedAt);
  }

  /*
   * =======================================
   * CORREÇÃO DO BUG: Métodos de Onboarding
   * =======================================
   */

  // Comentário: Guarda o status de que o utilizador completou o onboarding.
  //             Este é o método que faltava na PolicyScreen.
  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(PrefsKeys.onboardingCompleted, true);
  }

  // Comentário: Verifica se o onboarding foi concluído (usado pela SplashScreen).
  //             Retorna 'false' se a chave não existir (?? false),
  //             garantindo que o onboarding seja mostrado na primeira vez.
  bool isOnboardingCompleted() {
    return _prefs.getBool(PrefsKeys.onboardingCompleted) ?? false;
  }

  // Comentário: Limpa o status de onboarding (usado na revogação total).
  Future<void> clearOnboardingCompleted() async {
    await _prefs.remove(PrefsKeys.onboardingCompleted);
  }

  /*
   * =======================================
   * Métodos do Perfil do Utilizador
   * =======================================
   */

  // Comentário: Busca o nome do utilizador. Retorna string vazia se for nulo.
  String getUserName() {
    return _prefs.getString(PrefsKeys.userName) ?? '';
  }

  // Comentário: Busca o e-mail do utilizador. Retorna string vazia se for nulo.
  String getUserEmail() {
    return _prefs.getString(PrefsKeys.userEmail) ?? '';
  }

  // Comentário: Guarda ambos, nome e e-mail, numa única operação.
  Future<void> saveUserProfile(String name, String email) async {
    await _prefs.setString(PrefsKeys.userName, name);
    await _prefs.setString(PrefsKeys.userEmail, email);
  }

  // Comentário: Limpa os dados do perfil (usado na revogação).
  Future<void> clearUserProfile() async {
    await _prefs.remove(PrefsKeys.userName);
    await _prefs.remove(PrefsKeys.userEmail);
  }

  /*
   * =======================================
   * Métodos de Consentimento (Marketing)
   * =======================================
   */

  // Comentário: Verifica se o utilizador deu consentimento de marketing.
  //             Retorna 'false' por padrão (opt-in).
  bool getMarketingConsent() {
    return _prefs.getBool(PrefsKeys.marketingConsent) ?? false;
  }

  // Comentário: Guarda a escolha do utilizador sobre o consentimento de marketing.
  Future<void> setMarketingConsent(bool value) async {
    await _prefs.setBool(PrefsKeys.marketingConsent, value);
  }
}