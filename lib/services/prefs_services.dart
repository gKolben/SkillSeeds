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
    await _prefs.setString(PrefsKeys.acceptedAt, DateTime.now().toIso8601String());
  }

  Future<void> clearConsent() async {
    await _prefs.remove(PrefsKeys.policyVersionAccepted);
    await _prefs.remove(PrefsKeys.acceptedAt);
  }
}