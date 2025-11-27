class UserProgress {
  final int id;
  final String userId;
  final int lessonId;
  final DateTime completedAt;
  final DateTime updatedAt;

  UserProgress({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.completedAt,
    required this.updatedAt,
  });
}
