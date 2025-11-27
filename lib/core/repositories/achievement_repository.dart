import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skillseeds/core/models/achievement_dto.dart';
import 'package:skillseeds/core/models/achievement.dart';
import 'package:skillseeds/core/mappers/achievement_mapper.dart';

class AchievementRepository {
  final SupabaseClient _client;

  AchievementRepository(this._client);

  Future<List<Achievement>> getAchievements() async {
    try {
      final data = await _client
          .from('achievements')
          .select()
          .order('rarity', ascending: false);

      final dtoList = (data as List).map((map) => AchievementDTO.fromMap(map)).toList();
      final achievementList = dtoList.map((dto) => AchievementMapper.toEntity(dto)).toList();
      return achievementList;
    } catch (e, st) {
      developer.log('Erro ao buscar conquistas', error: e, stackTrace: st);
      rethrow;
    }
  }
}
