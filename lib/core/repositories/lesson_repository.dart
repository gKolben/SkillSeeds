import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lesson_dto.dart';
import '../models/lesson.dart';
import '../mappers/lesson_mapper.dart';

class LessonRepository {
  final SupabaseClient _client;

  LessonRepository(this._client);

  Future<List<Lesson>> getLessonsForTrack(int trackId) async {
    try {
      final data = await _client
          .from('lessons')
          .select()
          .eq('track_id', trackId)
          .order('id', ascending: true);

      final dtoList = (data as List).map((map) => LessonDTO.fromMap(map)).toList();
      final lessonList = dtoList.map((dto) => LessonMapper.toEntity(dto)).toList();
      return lessonList;
    } catch (e, st) {
      developer.log('Erro ao buscar lições', error: e, stackTrace: st);
      rethrow;
    }
  }
}
