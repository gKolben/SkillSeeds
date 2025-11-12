import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Importações dos nossos modelos, repositórios e serviços
import '../models/track.dart';
import '../models/lesson.dart';
import '../models/achievement.dart';
import '../repositories/track_repository.dart';
import '../repositories/lesson_repository.dart';
import '../repositories/achievement_repository.dart';
import '../services/prefs_services.dart';

/*
 * =======================================
 * Provedores de Serviços de Core
 * =======================================
 */

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

/*
 * =======================================
 * Provedores de Estado da UI (Reatividade)
 * =======================================
 */

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

/*
 * =======================================
 * Provedores de Repositório (Lógica de Dados)
 * =======================================
 */

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

/*
 * =======================================
 * Provedores de DADOS (FutureProviders)
 * =======================================
 */

// Comentário: Provider que busca a lista de TODAS as trilhas
final tracksProvider = FutureProvider<List<Track>>((ref) async {
  final repository = ref.watch(trackRepositoryProvider);
  return repository.getTracks();
});

// Comentário: Provider que busca as lições de UMA trilha específica.
// Usamos .family para poder passar um parâmetro (o trackId).
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