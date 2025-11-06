import 'package.flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillseeds/providers/providers.dart';
import 'package:skillseeds/screens/profile_screen.dart';
import 'package:skillseeds/services/prefs_services.dart';

class MockPrefsService extends Mock implements PrefsService {}
class MockStringStateController extends Mock implements StateController<String> {}
class FakeStateController<T> extends Fake implements StateController<T> {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeStateController<String>());
  });

  late MockPrefsService mockPrefsService;
  late MockStringStateController mockUserNameController;
  late MockStringStateController mockUserEmailController;

  setUp(() {
    mockPrefsService = MockPrefsService();
    mockUserNameController = MockStringStateController();
    mockUserEmailController = MockStringStateController();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        prefsServiceProvider.overrideWithValue(mockPrefsService),

        userNameProvider.notifier.overrideWith((_) => mockUserNameController),
        userEmailProvider.notifier.overrideWith((_) => mockUserEmailController),
      ],
      child: const MaterialApp(
        home: ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen Widget Test', () {
    testWidgets('shows validation errors when fields are empty', (tester) async {
      when(() => mockPrefsService.getUserName()).thenReturn('');
      when(() => mockPrefsService.getUserEmail()).thenReturn('');
      when(() => mockUserNameController.state).thenReturn('');
      when(() => mockUserEmailController.state).thenReturn('');

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(find.text('Por favor, digite seu nome.'), findsOneWidget);
      expect(find.text('Por favor, digite seu e-mail.'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid email', (tester) async {
      when(() => mockPrefsService.getUserName()).thenReturn('');
      when(() => mockPrefsService.getUserEmail()).thenReturn('');
      when(() => mockUserNameController.state).thenReturn('');
      when(() => mockUserEmailController.state).thenReturn('');

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextFormField).first, 'Test User');
      await tester.enterText(find.byType(TextFormField).last, 'invalid-email');
      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(find.text('Por favor, digite um e-mail válido (ex: nome@dominio.com).'), findsOneWidget);
    });

    testWidgets('saves profile and shows snackbar on success', (tester) async {
      when(() => mockPrefsService.getUserName()).thenReturn('');
      when(() => mockPrefsService.getUserEmail()).thenReturn('');
      when(() => mockUserNameController.state).thenReturn('');
      when(() => mockUserEmailController.state).thenReturn('');

      when(() => mockPrefsService.saveUserProfile('Test User', 'test@email.com'))
          .thenAnswer((_) async {});
      
      when(() => mockUserNameController.state = 'Test User').thenReturn('Test User');
      when(() => mockUserEmailController.state = 'test@email.com').thenReturn('test@email.com');

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextFormField).first, 'Test User');
      await tester.enterText(find.byType(TextFormField).last, 'test@email.com');

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(find.text('Perfil salvo com sucesso!'), findsOneWidget);

      verify(() => mockPrefsService.saveUserProfile('Test User', 'test@email.com')).called(1);
      verify(() => mockUserNameController.state = 'Test User').called(1);
      verify(() => mockUserEmailController.state = 'test@email.com').called(1);
    });
  });
}