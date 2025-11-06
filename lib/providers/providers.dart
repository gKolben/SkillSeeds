import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Importações corrigidas para caminhos relativos
import '../models/track.dart';
import '../repositories/track_repository.dart';
import '../services/prefs_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/*
 * =======================================
 * Provedores de Serviços de Core
 * =======================================
 */

/// Provider para o SharedPreferences (assíncrono)
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Provider para o nosso PrefsService
/// Ele depende do sharedPreferencesProvider para obter a instância do SharedPreferences
final prefsServiceProvider = Provider<PrefsService>((ref) {
  // .watch escuta as mudanças no provider. Quando o Future for resolvido,
  // o .asData?.value terá o valor (a instância do SharedPreferences)
  final sharedPrefs = ref.watch(sharedPreferencesProvider).asData?.value;

  // Se o SharedPreferences ainda não estiver pronto, lança uma exceção.
  // Isso é útil para garantir que o app não inicie sem ele.
  if (sharedPrefs == null) {
    throw Exception("SharedPreferences not initialized");
  }

  return PrefsService(sharedPrefs);
});

/// Provider para o cliente Supabase
/// Ele é inicializado no main.dart, então aqui apenas o obtemos.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/*
 * =======================================
 * Provedores de Estado da UI (Reatividade)
 * =======================================
 */

/// Provider que guarda o estado atual do nome do usuário
/// Usado para o Drawer se atualizar automaticamente
final userNameProvider = StateProvider<String>((ref) {
  // Ouve o prefsService
  final prefs = ref.watch(prefsServiceProvider);
  // Retorna o nome salvo como estado inicial
  return prefs.getUserName();
});

/// Provider que guarda o estado atual do e-mail do usuário
/// Usado para o Drawer se atualizar automaticamente
final userEmailProvider = StateProvider<String>((ref) {
  // Ouve o prefsService
  final prefs = ref.watch(prefsServiceProvider);
  // Retorna o e-mail salvo como estado inicial
  return prefs.getUserEmail();
});

/*
 * =======================================
 * Provedores de Repositório (Dados do Supabase)
 * =======================================
 */

/// Provider para o nosso TrackRepository
/// Ele injeta o cliente Supabase no repositório.
final trackRepositoryProvider = Provider<TrackRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TrackRepository(client);
});

/// Provider que busca a lista de trilhas do Supabase
/// Este é um FutureProvider, pois é uma operação de rede (assíncrona).
final tracksProvider = FutureProvider<List<Track>>((ref) async {
  // Ouve o trackRepositoryProvider e chama o método getTracks()
  final repository = ref.watch(trackRepositoryProvider);
  return repository.getTracks();
});