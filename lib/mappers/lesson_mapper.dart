import '../models/lesson.dart';
import '../models/lesson_dto.dart';

class LessonMapper {
  static Lesson toEntity(LessonDTO dto) {
    return Lesson(
      id: dto.id,
      trackId: dto.track_id,
      title: dto.title,
      createdAt: DateTime.parse(dto.created_at),
      lessonType: _lessonTypeFromString(dto.type),
    );
  }

  static LessonDTO toDto(Lesson entity) {
    return LessonDTO(
      id: entity.id,
      track_id: entity.trackId,
      title: entity.title,
      created_at: entity.createdAt.toIso8601String(),
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