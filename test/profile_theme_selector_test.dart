import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillseeds/core/services/prefs_services.dart';
import 'package:skillseeds/core/providers/providers_state.dart' show prefsServiceProvider;
import 'package:skillseeds/features/profile/presentation/profile_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Profile theme selector persists selection', (WidgetTester tester) async {
    // Setup mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final prefsService = PrefsService(prefs);

    // Pump the ProfileScreen inside ProviderScope with prefs override
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          prefsServiceProvider.overrideWithValue(prefsService),
        ],
        child: const MaterialApp(
          home: ProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Open the dropdown
    final dropdownFinder = find.byType(DropdownButton<ThemeMode>);
    expect(dropdownFinder, findsOneWidget);
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    // Tap the 'Escuro' option
    final darkOption = find.text('Escuro').last;
    expect(darkOption, findsOneWidget);
    await tester.tap(darkOption);
    await tester.pumpAndSettle();

    // Assert persistence
    final stored = prefs.getString('theme_mode');
    expect(stored, 'dark');
  });
}
