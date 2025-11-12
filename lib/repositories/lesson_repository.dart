// Comentário: Importa o Supabase e os modelos/mappers que criamos
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lesson.dart';
import '../models/lesson_dto.dart';
import '../mappers/lesson_mapper.dart';

// Comentário: Este repositório é responsável por buscar os dados das 'lessons' (lições) no Supabase.
class LessonRepository {
  final SupabaseClient _client;

  LessonRepository(this._client);

  // Comentário: Busca uma lista de lições que pertencem a uma trilha específica (trackId).
  Future<List<Lesson>> getLessonsForTrack(int trackId) async {
    try {
      // Comentário: Faz a consulta na tabela 'lessons' filtrando pelo 'track_id'.
      final data = await _client
          .from('lessons')
          .select()
          .eq('track_id', trackId)
          .order('id', ascending: true); // Ordena pelo ID (ou ordem)

      // Comentário: Converte a resposta (JSON) em uma lista de DTOs.
      final dtoList =
          (data as List).map((map) => LessonDTO.fromMap(map)).toList();

      // Comentário: Usa o Mapper para converter a lista de DTOs em uma lista de Entidades (Lesson).
      final lessonList =
          dtoList.map((dto) => LessonMapper.toEntity(dto)).toList();

      return lessonList;
    } catch (e) {
      // Comentário: Em caso de erro, imprime no console e retorna uma lista vazia.
      print('Erro ao buscar lições: $e');
      rethrow; // Propaga o erro para a UI tratar (ex: mostrar mensagem de erro)
    }
  }
}