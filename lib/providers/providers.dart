import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillseeds/services/prefs_services.dart';

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final prefsServiceProvider = Provider<PrefsService>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider).asData?.value;
  if (sharedPrefs == null) {
    throw Exception("SharedPreferences not initialized");
  }
  return PrefsService(sharedPrefs);
});

final userNameProvider = StateProvider<String>((ref) {
  return ref.watch(prefsServiceProvider).getUserName();
});

final userEmailProvider = StateProvider<String>((ref) {
  return ref.watch(prefsServiceProvider).getUserEmail();
});