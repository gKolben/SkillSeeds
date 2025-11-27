import '../models/lesson.dart';
import '../models/lesson_dto.dart';

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
}
