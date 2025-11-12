// Comentário: Importa o Supabase e os modelos/mappers que criamos
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/achievement.dart';
import '../models/achievement_dto.dart';
import '../mappers/achievement_mapper.dart';

// Comentário: Este repositório é responsável por buscar os dados de 'achievements' (conquistas) no Supabase.
class AchievementRepository {
  final SupabaseClient _client;

  AchievementRepository(this._client);

  // Comentário: Busca todas as conquistas disponíveis.
  Future<List<Achievement>> getAchievements() async {
    try {
      // Comentário: Faz a consulta na tabela 'achievements'.
      final data = await _client
          .from('achievements')
          .select()
          .order('rarity', ascending: false); // Ordena por raridade

      // Comentário: Converte o JSON em uma lista de DTOs.
      final dtoList =
          (data as List).map((map) => AchievementDTO.fromMap(map)).toList();

      // Comentário: Usa o Mapper para converter DTOs em Entidades (Achievement).
      final achievementList =
          dtoList.map((dto) => AchievementMapper.toEntity(dto)).toList();

      return achievementList;
    } catch (e) {
      // Comentário: Em caso de erro, imprime no console e retorna uma lista vazia.
      print('Erro ao buscar conquistas: $e');
      rethrow; // Propaga o erro para a UI tratar
    }
  }
}