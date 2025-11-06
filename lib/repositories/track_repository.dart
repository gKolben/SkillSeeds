import 'package:skillseeds/models/track.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Lida com a busca de dados de trilhas no Supabase.
class TrackRepository {
  final SupabaseClient _supabase;

  // Recebe o cliente Supabase via injeção de dependência (do provider)
  TrackRepository(this._supabase);

  /// Busca a lista de todas as trilhas no banco de dados.
  /// Esta é a função que o 'tracksProvider' (no Canvas) irá chamar.
  Future<List<Track>> getTracks() async {
    try {
      // 1. Busca os dados da tabela 'tracks', ordenando pelos mais novos
      final data = await _supabase
          .from('tracks')
          .select()
          .order('created_at', ascending: false);

      // 2. Converte a lista de mapas (JSON) em uma lista de Objetos Track
      final tracks = data.map((item) => Track.fromMap(item)).toList();

      return tracks;
    } catch (e) {
      // Em um app real, aqui teríamos um log de erro
      print('Erro ao buscar trilhas: $e');
      throw Exception('Não foi possível carregar as trilhas');
    }
  }
}