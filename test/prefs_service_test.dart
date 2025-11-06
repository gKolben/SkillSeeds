// Importa o pacote de testes do Flutter
import 'package:flutter_test/flutter_test.dart';
// Importa o pacote de mock
import 'package:mocktail/mocktail.dart';
// Importa as classes que queremos testar
import 'package:skillseeds/services/prefs_keys.dart';
import 'package:skillseeds/services/prefs_services.dart';
// Importa a dependência que vamos simular
import 'package:shared_preferences/shared_preferences.dart';

// 1. Cria um "Mock" (simulador) do SharedPreferences
// Isso nos permite testar o PrefsService sem depender do disco do dispositivo
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  // Declara as variáveis que vamos usar em todos os testes
  late PrefsService prefsService;
  late MockSharedPreferences mockPrefs;

  // 2. O 'setUp' roda antes de CADA teste
  setUp(() {
    // Cria uma nova instância do nosso mock
    mockPrefs = MockSharedPreferences();
    // Cria uma nova instância do serviço, injetando o mock
    prefsService = PrefsService(mockPrefs);
  });

  // 3. Define um grupo de testes para o perfil do usuário
  group('User Profile', () {
    // Testa o método getUserName()
    test('getUserName returns empty string when nothing is set', () {
      // Configura o mock: "quando getString('user_name') for chamado, retorne null"
      when(() => mockPrefs.getString(PrefsKeys.userName)).thenReturn(null);

      // Executa a ação
      final name = prefsService.getUserName();

      // Verifica o resultado
      expect(name, '');
    });

    test('getUserName returns saved name', () {
      // Configura o mock: "quando getString('user_name') for chamado, retorne 'Gabriela'"
      when(() => mockPrefs.getString(PrefsKeys.userName)).thenReturn('Gabriela');

      // Executa a ação
      final name = prefsService.getUserName();

      // Verifica o resultado
      expect(name, 'Gabriela');
    });

    // Testa o método saveUserProfile()
    test('saveUserProfile calls setString correctly', () async {
      // Configura o mock: "quando setString(qualquerCoisa) for chamado, retorne sucesso (true)"
      // Usamos 'any()' porque não nos importamos com o valor, apenas se foi chamado
      when(() => mockPrefs.setString(any(), any()))
          .thenAnswer((_) async => true);

      // Executa a ação
      await prefsService.saveUserProfile('Test User', 'test@email.com');

      // Verifica se os métodos foram chamados EXATAMENTE UMA VEZ com os valores corretos
      verify(() => mockPrefs.setString(PrefsKeys.userName, 'Test User'))
          .called(1);
      verify(() => mockPrefs.setString(PrefsKeys.userEmail, 'test@email.com'))
          .called(1);
    });
  });

  // 4. Define um grupo de testes para o consentimento de marketing
  group('Marketing Consent', () {
    test('getMarketingConsent returns false when nothing is set', () {
      // Configura o mock
      when(() => mockPrefs.getBool(PrefsKeys.marketingConsent)).thenReturn(null);
      // Executa e Verifica
      expect(prefsService.getMarketingConsent(), false);
    });

    test('getMarketingConsent returns true when set to true', () {
      // Configura o mock
      when(() => mockPrefs.getBool(PrefsKeys.marketingConsent)).thenReturn(true);
      // Executa e Verifica
      expect(prefsService.getMarketingConsent(), true);
    });

    test('setMarketingConsent calls setBool correctly', () async {
      // Configura o mock
      when(() => mockPrefs.setBool(any(), any()))
          .thenAnswer((_) async => true);

      // Executa
      await prefsService.setMarketingConsent(true);

      // Verifica
      verify(() => mockPrefs.setBool(PrefsKeys.marketingConsent, true))
          .called(1);
    });
  });
}