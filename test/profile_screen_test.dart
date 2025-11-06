// Importa os pacotes de teste e mock
import 'package.flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillseeds/providers/providers.dart';
import 'package:skillseeds/screens/profile_screen.dart';
import 'package:skillseeds/services/prefs_services.dart';

// 1. Cria os "Mocks" (Simuladores)
class MockPrefsService extends Mock implements PrefsService {}
class MockStringStateController extends Mock implements StateController<String> {}

// Necessário para o mocktail funcionar com classes genéricas
class FakeStateController<T> extends Fake implements StateController<T> {}

void main() {
  // Registra o fallback para o StateController
  setUpAll(() {
    registerFallbackValue(FakeStateController<String>());
  });

  // Declara as variáveis de mock
  late MockPrefsService mockPrefsService;
  late MockStringStateController mockUserNameController;
  late MockStringStateController mockUserEmailController;

  // 2. O 'setUp' roda antes de CADA teste
  setUp(() {
    mockPrefsService = MockPrefsService();
    mockUserNameController = MockStringStateController();
    mockUserEmailController = MockStringStateController();
  });

  // Helper para criar o widget em um ambiente de teste com providers
  Widget createWidgetUnderTest() {
    return ProviderScope(
      // 3. Sobrescreve os providers que a tela usa com nossos mocks
      overrides: [
        prefsServiceProvider.overrideWithValue(mockPrefsService),

        // --- CORREÇÃO AQUI ---
        // Nós sobrescrevemos o ".notifier" (o controlador)
        // em vez do provider principal.
        userNameProvider.notifier.overrideWith((_) => mockUserNameController),
        userEmailProvider.notifier.overrideWith((_) => mockUserEmailController),
      ],
      // Precisamos do MaterialApp para o SnackBar e navegação
      child: const MaterialApp(
        home: ProfileScreen(),
      ),
    );
  }

  // 4. Define o grupo de testes
  group('ProfileScreen Widget Test', () {
    // Teste 1: Validação de campos vazios
    testWidgets('shows validation errors when fields are empty', (tester) async {
      // Configura os mocks para o estado inicial
      when(() => mockPrefsService.getUserName()).thenReturn('');
      when(() => mockPrefsService.getUserEmail()).thenReturn('');
      // Precisamos mockar o getter do .state que o build() usa
      when(() => mockUserNameController.state).thenReturn('');
      when(() => mockUserEmailController.state).thenReturn('');

      // Carrega o widget
      await tester.pumpWidget(createWidgetUnderTest());

      // Tenta salvar sem preencher
      await tester.tap(find.text('Salvar'));
      // Aguarda a UI reconstruir com as mensagens de erro
      await tester.pump();

      // Verifica se as mensagens de erro apareceram
      expect(find.text('Por favor, digite seu nome.'), findsOneWidget);
      expect(find.text('Por favor, digite seu e-mail.'), findsOneWidget);
    });

    // Teste 2: Validação de e-mail inválido
    testWidgets('shows validation error for invalid email', (tester) async {
      // Configura os mocks
      when(() => mockPrefsService.getUserName()).thenReturn('');
      when(() => mockPrefsService.getUserEmail()).thenReturn('');
      when(() => mockUserNameController.state).thenReturn('');
      when(() => mockUserEmailController.state).thenReturn('');

      // Carrega o widget
      await tester.pumpWidget(createWidgetUnderTest());

      // Preenche os campos (com e-mail inválido)
      await tester.enterText(find.byType(TextFormField).first, 'Test User');
      await tester.enterText(find.byType(TextFormField).last, 'invalid-email');

      // Tenta salvar
      await tester.tap(find.text('Salvar'));
      await tester.pump();

      // Verifica se a mensagem de erro específica do e-mail apareceu
      expect(find.text('Por favor, digite um e-mail válido (ex: nome@dominio.com).'), findsOneWidget);
    });

    // Teste 3: Salvamento com sucesso
    testWidgets('saves profile and shows snackbar on success', (tester) async {
      // Configura os mocks para o estado inicial
      when(() => mockPrefsService.getUserName()).thenReturn('');
      when(() => mockPrefsService.getUserEmail()).thenReturn('');
      when(() => mockUserNameController.state).thenReturn('');
      when(() => mockUserEmailController.state).thenReturn('');

      // Configura os mocks para a AÇÃO de salvar
      when(() => mockPrefsService.saveUserProfile('Test User', 'test@email.com'))
          .thenAnswer((_) async {});
      
      // Configura o mock do setter do .state
      when(() => mockUserNameController.state = 'Test User').thenReturn('Test User');
      when(() => mockUserEmailController.state = 'test@email.com').thenReturn('test@email.com');

      // Carrega o widget
      await tester.pumpWidget(createWidgetUnderTest());

      // Preenche os campos com dados válidos
      await tester.enterText(find.byType(TextFormField).first, 'Test User');
      await tester.enterText(find.byType(TextFormField).last, 'test@email.com');

      // Tenta salvar
      await tester.tap(find.text('Salvar'));
      // Aguarda as animações (SnackBar, navegação) terminarem
      await tester.pumpAndSettle();

      // Verifica se o SnackBar de sucesso apareceu
      expect(find.text('Perfil salvo com sucesso!'), findsOneWidget);

      // Verifica se os métodos corretos foram chamados nos mocks
      verify(() => mockPrefsService.saveUserProfile('Test User', 'test@email.com')).called(1);
      verify(() => mockUserNameController.state = 'Test User').called(1);
      verify(() => mockUserEmailController.state = 'test@email.com').called(1);
    });
  });
}