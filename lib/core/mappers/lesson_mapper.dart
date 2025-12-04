import 'package:skillseeds/features/lessons/domain/index.dart';
import 'package:skillseeds/features/lessons/data/dtos/lesson_dto.dart';

class LessonMapper {
  static Lesson toEntity(LessonDTO dto) {
    return Lesson(
      id: dto.id,
      trackId: dto.trackId,
      title: dto.title,
      lessonType: LessonType.values.firstWhere((e) => e.toString().split('.').last == dto.type, orElse: () => LessonType.reading),
      createdAt: DateTime.parse(dto.createdAt),
    );
  }

  static LessonDTO toDto(Lesson entity) {
    return LessonDTO(
      id: entity.id,
      trackId: entity.trackId,
      title: entity.title,
      type: entity.lessonType.toString().split('.').last,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}
