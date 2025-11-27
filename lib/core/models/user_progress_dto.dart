class UserProgressDTO {
  final int id;
  final String userId;
  final int lessonId;
  final String completedAt;
  final String updatedAt;

  UserProgressDTO({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.completedAt,
    required this.updatedAt,
  });

  factory UserProgressDTO.fromMap(Map<String, dynamic> map) {
    return UserProgressDTO(
      id: map['id'] as int,
      userId: map['user_id'] as String,
      lessonId: map['lesson_id'] as int,
      completedAt: map['completed_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'lesson_id': lessonId,
      'completed_at': completedAt,
      'updated_at': updatedAt,
    };
  }
}
