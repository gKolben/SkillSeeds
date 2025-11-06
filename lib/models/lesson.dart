enum LessonType {
  reading,
  video,
  quiz
}

class Lesson {
  final int id;
  final int trackId;
  final String title;
  final LessonType lessonType;
  final DateTime createdAt;

  Lesson({
    required this.id,
    required this.trackId,
    required this.title,
    required this.lessonType,
    required this.createdAt,
  });
}