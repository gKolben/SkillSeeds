import 'package:skillseeds/core/models/lesson.dart';
import 'package:skillseeds/core/models/lesson_dto.dart';

class LessonMapper {
  static Lesson toEntity(LessonDTO dto) {
    return Lesson(
      id: dto.id,
      trackId: dto.trackId,
      title: dto.title,
      createdAt: DateTime.parse(dto.createdAt),
      lessonType: _lessonTypeFromString(dto.type),
    );
  }

  static LessonDTO toDto(Lesson entity) {
    return LessonDTO(
      id: entity.id,
      trackId: entity.trackId,
      title: entity.title,
      createdAt: entity.createdAt.toIso8601String(),
      type: _stringFromLessonType(entity.lessonType),
    );
  }

  static LessonType _lessonTypeFromString(String type) {
    switch (type) {
      case 'video':
        return LessonType.video;
      case 'quiz':
        return LessonType.quiz;
      case 'reading':
      default:
        return LessonType.reading;
    }
  }

  static String _stringFromLessonType(LessonType type) {
    return type.name;
  }
}