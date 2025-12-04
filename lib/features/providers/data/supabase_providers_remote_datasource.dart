import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skillseeds/features/providers/data/dtos/provider_dto.dart';

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
}
