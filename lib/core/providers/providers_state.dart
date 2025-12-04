import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

// Importações dos nossos modelos, repositórios e serviços (agora em core)
import 'package:skillseeds/core/models/track.dart';
import 'package:skillseeds/core/models/lesson.dart';
import 'package:skillseeds/core/models/achievement.dart';
import 'package:skillseeds/core/models/provider_model.dart' as domain; // Prefixo para evitar conflitos
import 'package:skillseeds/core/repositories/track_repository.dart';
import 'package:skillseeds/core/repositories/lesson_repository.dart';
import 'package:skillseeds/core/repositories/achievement_repository.dart';
import 'package:skillseeds/core/repositories/providers_repository.dart';
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

// Comentário: Provider para o ProvidersRepository
final providersRepositoryProvider = Provider<ProvidersRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  if (prefs == null) {
    throw Exception('SharedPreferences not initialized');
  }
  return ProvidersRepositoryImpl(client, prefs);
});

// Comentário: Provider que gerencia a lista de Providers (entidade de domínio)
final providersListProvider = StateNotifierProvider<ProvidersNotifier, List<domain.Provider>>((ref) {
  final repository = ref.watch(providersRepositoryProvider);
  return ProvidersNotifier(repository);
});

// Classe responsável por gerenciar o estado da lista de Providers
class ProvidersNotifier extends StateNotifier<List<domain.Provider>> {
  final ProvidersRepository _repository;

  ProvidersNotifier(this._repository) : super([]);

  Future<void> loadProviders() async {
    try {
      final providers = await _repository.fetchProviders();
      state = providers;
    } catch (e) {
      // Log de erro para facilitar o diagnóstico
      if (kDebugMode) {
        print('Erro ao carregar Providers: $e');
      }
    }
  }

  Future<void> syncProviders() async {
    try {
      final syncedProviders = await _repository.syncProviders();
      state = syncedProviders;
      if (kDebugMode) {
        print('Sincronização concluída com sucesso.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao sincronizar Providers: $e');
      }
    }
  }

  Future<void> createProvider(domain.Provider provider) async {
    await _repository.createProvider(provider);
    // atualizar estado local
    state = [...state, provider];
  }

  Future<void> updateProvider(domain.Provider provider) async {
    await _repository.updateProvider(provider);
    state = state.map((p) => p.id == provider.id ? provider : p).toList();
  }

  Future<void> removeProvider(String id) async {
    await _repository.removeProvider(id);
    state = state.where((p) => p.id != id).toList();
  }
}

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
