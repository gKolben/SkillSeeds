// Comentário: Importa a biblioteca de persistência local.
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
// Comentário: Importa o nosso arquivo de chaves centralizadas.
import 'package:skillseeds/core/services/prefs_keys.dart';

class PrefsService {
  final SharedPreferences _prefs;

  PrefsService(this._prefs);

  bool isConsentGiven() {
    return _prefs.getString(PrefsKeys.policyVersionAccepted) == 'v1';
  }

  Future<void> saveConsent() async {
    await _prefs.setString(PrefsKeys.policyVersionAccepted, 'v1');
    await _prefs.setString(PrefsKeys.acceptedAt, DateTime.now().toIso8601String());
  }

  Future<void> clearConsent() async {
    await _prefs.remove(PrefsKeys.policyVersionAccepted);
    await _prefs.remove(PrefsKeys.acceptedAt);
  }

  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(PrefsKeys.onboardingCompleted, true);
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(PrefsKeys.onboardingCompleted) ?? false;
  }

  Future<void> clearOnboardingCompleted() async {
    await _prefs.remove(PrefsKeys.onboardingCompleted);
  }

  String getUserName() {
    return _prefs.getString(PrefsKeys.userName) ?? '';
  }

  String getUserEmail() {
    return _prefs.getString(PrefsKeys.userEmail) ?? '';
  }

  Future<void> saveUserProfile(String name, String email) async {
    await _prefs.setString(PrefsKeys.userName, name);
    await _prefs.setString(PrefsKeys.userEmail, email);
  }

  Future<void> clearUserProfile() async {
    await _prefs.remove(PrefsKeys.userName);
    await _prefs.remove(PrefsKeys.userEmail);
  }

  bool getMarketingConsent() {
    return _prefs.getBool(PrefsKeys.marketingConsent) ?? false;
  }

  Future<void> setMarketingConsent(bool value) async {
    await _prefs.setBool(PrefsKeys.marketingConsent, value);
  }

  // Theme mode helpers
  ThemeMode getThemeMode() {
    final s = _prefs.getString(PrefsKeys.themeMode) ?? 'light';
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final s = mode == ThemeMode.light ? 'light' : mode == ThemeMode.dark ? 'dark' : 'system';
    await _prefs.setString(PrefsKeys.themeMode, s);
  }
}
