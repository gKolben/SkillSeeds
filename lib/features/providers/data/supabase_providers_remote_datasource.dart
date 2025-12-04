import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:skillseeds/features/providers/data/index.dart';

class SupabaseProvidersRemoteDatasource {
  final SupabaseClient _client;

  SupabaseProvidersRemoteDatasource(this._client);

  /// Busca a lista de providers do Supabase.
  /// Retorna uma lista de ProviderDto.
  Future<List<ProviderDto>> fetchAll() async {
    final data = await _client.from('providers').select();
    final list = data as List<dynamic>;
    return list.map((e) => ProviderDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Upsert a list of providers to Supabase (best-effort). Returns the number
  /// of rows returned by the server (may be 0) or throws on unexpected errors.
  Future<int> upsertProviders(List<ProviderDto> dtos) async {
    final payload = dtos.map((d) => d.toJson()).toList();
    if (payload.isEmpty) return 0;
    if (kDebugMode) print('SupabaseProvidersRemoteDatasource.upsertProviders: sending ${payload.length} items');
    try {
      final response = await _client.from('providers').upsert(payload).select();
      // response is typically a List<dynamic>
      final list = response as List<dynamic>;
      if (kDebugMode) print('SupabaseProvidersRemoteDatasource.upsertProviders: server returned ${list.length} items');
      return list.length;
    } catch (e) {
      if (kDebugMode) print('SupabaseProvidersRemoteDatasource.upsertProviders: error: $e');
      rethrow;
    }
  }

  /// Delete provider by id from Supabase. Returns number of rows affected.
  Future<int> deleteProvider(String id) async {
    try {
      if (kDebugMode) print('SupabaseProvidersRemoteDatasource.deleteProvider: deleting id=$id');
      final response = await _client.from('providers').delete().eq('id', id).select();
      final list = response as List<dynamic>;
      if (kDebugMode) print('SupabaseProvidersRemoteDatasource.deleteProvider: server returned ${list.length} items');
      return list.length;
    } catch (e) {
      if (kDebugMode) print('SupabaseProvidersRemoteDatasource.deleteProvider: error: $e');
      rethrow;
    }
  }
}
