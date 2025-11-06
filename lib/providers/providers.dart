import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/track.dart';
import '../repositories/track_repository.dart';
import '../services/prefs_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final userNameProvider = StateProvider<String>((ref) {
  final prefs = ref.watch(prefsServiceProvider);
  return prefs.getUserName();
});

final userEmailProvider = StateProvider<String>((ref) {
  final prefs = ref.watch(prefsServiceProvider);
  return prefs.getUserEmail();
});

final trackRepositoryProvider = Provider<TrackRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TrackRepository(client);
});

final tracksProvider = FutureProvider<List<Track>>((ref) async {
  final repository = ref.watch(trackRepositoryProvider);
  return repository.getTracks();
});