import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skillseeds/services/prefs_keys.dart';
import 'package:skillseeds/services/prefs_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late PrefsService prefsService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    prefsService = PrefsService(mockPrefs);
  });

  group('User Profile', () {
    test('getUserName returns empty string when nothing is set', () {
      when(() => mockPrefs.getString(PrefsKeys.userName)).thenReturn(null);

      final name = prefsService.getUserName();

      expect(name, '');
    });

    test('getUserName returns saved name', () {
      when(() => mockPrefs.getString(PrefsKeys.userName)).thenReturn('Gabriela');

      final name = prefsService.getUserName();

      expect(name, 'Gabriela');
    });

    test('saveUserProfile calls setString correctly', () async {
      when(() => mockPrefs.setString(any(), any()))
          .thenAnswer((_) async => true);

      await prefsService.saveUserProfile('Test User', 'test@email.com');

      verify(() => mockPrefs.setString(PrefsKeys.userName, 'Test User'))
          .called(1);
      verify(() => mockPrefs.setString(PrefsKeys.userEmail, 'test@email.com'))
          .called(1);
    });
  });

  group('Marketing Consent', () {
    test('getMarketingConsent returns false when nothing is set', () {
      when(() => mockPrefs.getBool(PrefsKeys.marketingConsent)).thenReturn(null);
      expect(prefsService.getMarketingConsent(), false);
    });

    test('getMarketingConsent returns true when set to true', () {
      when(() => mockPrefs.getBool(PrefsKeys.marketingConsent)).thenReturn(true);
      expect(prefsService.getMarketingConsent(), true);
    });

    test('setMarketingConsent calls setBool correctly', () async {
      when(() => mockPrefs.setBool(any(), any()))
          .thenAnswer((_) async => true);

      await prefsService.setMarketingConsent(true);

      verify(() => mockPrefs.setBool(PrefsKeys.marketingConsent, true))
          .called(1);
    });
  });
}