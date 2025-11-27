import 'package:flutter_test/flutter_test.dart';
import 'package:skillseeds/mappers/lesson_mapper.dart';
import 'package:skillseeds/core/models/lesson.dart';
import 'package:skillseeds/core/models/lesson_dto.dart';

void main() {
  group('LessonMapper', () {
    test('deve converter corretamente LessonDTO para Lesson (Entity)', () {
      final dto = LessonDTO(
        id: 1,
        trackId: 10,
        title: 'O que é um DTO?',
        type: 'quiz',
        createdAt: '2025-01-01T12:00:00.000Z',
      );

      final entity = LessonMapper.toEntity(dto);

      expect(entity.id, 1);
      expect(entity.trackId, 10);
      expect(entity.title, 'O que é um DTO?');
      expect(entity.lessonType, LessonType.quiz);
      expect(entity.createdAt,
          DateTime.parse('2025-01-01T12:00:00.000Z'));
    });

    test('deve converter corretamente Lesson (Entity) para LessonDTO', () {
      final entity = Lesson(
        id: 2,
        trackId: 20,
        title: 'O que é um Mapper?',
        lessonType: LessonType.video,
        createdAt: DateTime.parse('2025-02-02T10:00:00.000Z'),
      );

      final dto = LessonMapper.toDto(entity);

        expect(dto.id, 2);
        expect(dto.trackId, 20);
        expect(dto.title, 'O que é um Mapper?');
        expect(dto.type, 'video');
        expect(dto.createdAt,
          '2025-02-02T10:00:00.000Z');
    });
  });
}