import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Importações dos nossos modelos, repositórios e serviços (agora em core)
import 'package:skillseeds/core/models/track.dart';
import 'package:skillseeds/core/models/lesson.dart';
import 'package:skillseeds/core/models/achievement.dart';
import 'package:skillseeds/core/repositories/track_repository.dart';
import 'package:skillseeds/core/repositories/lesson_repository.dart';
import 'package:skillseeds/core/repositories/achievement_repository.dart';
import 'package:skillseeds/core/services/prefs_services.dart';

// Comentário: Provider para o SharedPreferences (assíncrono)
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// Comentário: Provider para o nosso PrefsService
final prefsServiceProvider = Provider<PrefsService>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider).asData?.value;
  if (sharedPrefs == null) {
    throw Exception("SharedPreferences not initialized");
  }
  return PrefsService(sharedPrefs);
});

// Comentário: Provider para o cliente Supabase
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Comentário: Provider que guarda o estado atual do nome do usuário (para o Drawer)
final userNameProvider = StateProvider<String>((ref) {
  final prefs = ref.watch(prefsServiceProvider);
  return prefs.getUserName();
});

// Comentário: Provider que guarda o estado atual do e-mail do usuário (para o Drawer)
final userEmailProvider = StateProvider<String>((ref) {
  final prefs = ref.watch(prefsServiceProvider);
  return prefs.getUserEmail();
});

// Comentário: Provider para o TrackRepository
final trackRepositoryProvider = Provider<TrackRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TrackRepository(client);
});

// Comentário: Provider para o LessonRepository
final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return LessonRepository(client);
});

// Comentário: Provider para o AchievementRepository
final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AchievementRepository(client);
});

// Comentário: Provider que busca a lista de TODAS as trilhas
final tracksProvider = FutureProvider<List<Track>>((ref) async {
  final repository = ref.watch(trackRepositoryProvider);
  return repository.getTracks();
});

// Comentário: Provider que busca as lições de UMA trilha específica.
final lessonsForTrackProvider =
    FutureProvider.family<List<Lesson>, int>((ref, trackId) async {
  final repository = ref.watch(lessonRepositoryProvider);
  return repository.getLessonsForTrack(trackId);
});

// Comentário: Provider que busca a lista de TODAS as conquistas
final achievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final repository = ref.watch(achievementRepositoryProvider);
  return repository.getAchievements();
});
