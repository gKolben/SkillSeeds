import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillseeds/services/prefs_keys.dart';

class PrefsService {
  final SharedPreferences _prefs;

  PrefsService(this._prefs);

  bool isConsentGiven() {
    return _prefs.getString(PrefsKeys.policyVersionAccepted) == 'v1';
  }

  Future<void> saveConsent() async {
    await _prefs.setString(PrefsKeys.policyVersionAccepted, 'v1');
    await _prefs.setString(
        PrefsKeys.acceptedAt, DateTime.now().toIso8601String());
  }

  Future<void> clearConsent() async {
    await _prefs.remove(PrefsKeys.policyVersionAccepted);
    await _prefs.remove(PrefsKeys.acceptedAt);
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
}