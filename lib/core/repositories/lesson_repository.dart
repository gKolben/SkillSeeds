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

  /// Create a new lesson on Supabase. Returns the created Lesson with server id.
  Future<Lesson> createLesson(Lesson lesson) async {
    try {
      final payload = {
        'track_id': lesson.trackId,
        'title': lesson.title,
        'type': lesson.lessonType.toString().split('.').last,
        'created_at': lesson.createdAt.toIso8601String(),
      };

      final response = await _client.from('lessons').insert(payload).select();
      // Supabase may return a Map or a JSArray (Iterable). Normalize to Map<String,dynamic>.
      Map<String, dynamic> row;
      if (response is Map) {
        row = Map<String, dynamic>.from(response as Map);
      } else {
        try {
          final first = (response as dynamic)[0];
          row = Map<String, dynamic>.from(first as Map);
        } catch (e) {
          throw Exception('Unexpected response shape from Supabase on insert: $response');
        }
      }
      final dto = LessonDTO.fromMap(row);
      return LessonMapper.toEntity(dto);
    } catch (e, st) {
      developer.log('Erro ao criar lição', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Update an existing lesson on Supabase. Returns the updated Lesson.
  Future<Lesson> updateLesson(Lesson lesson) async {
    try {
      final payload = {
        'title': lesson.title,
        'type': lesson.lessonType.toString().split('.').last,
      };

        final response = await _client
            .from('lessons')
            .update(payload)
            .eq('id', lesson.id)
            .select();

        Map<String, dynamic> row;
        if (response is Map) {
          row = Map<String, dynamic>.from(response as Map);
        } else {
          try {
            final first = (response as dynamic)[0];
            row = Map<String, dynamic>.from(first as Map);
          } catch (e) {
            // Se o Supabase retornar uma lista vazia (ex: nenhum registro atualizado),
            // não vamos lançar exceção genérica — apenas logamos e retornamos a entidade original.
            developer.log('Warning: Supabase update returned empty result for lesson id=${lesson.id}');
            return lesson;
          }
        }

        final dto = LessonDTO.fromMap(row);
        return LessonMapper.toEntity(dto);
    } catch (e, st) {
      developer.log('Erro ao atualizar lição', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Remove a lesson by id from Supabase. Returns true if deleted.
  Future<bool> removeLesson(int id) async {
    try {
      await _client.from('lessons').delete().eq('id', id).select();
      // If no exception thrown, treat as success
      return true;
    } catch (e, st) {
      developer.log('Erro ao remover lição', error: e, stackTrace: st);
      return false;
    }
  }
}
