// Este é o DTO (espelho do Supabase)
class UserProgressDTO {
  final int id;
  final String userId;
  final int lessonId;
  final String completedAt; // ISO 8601
  final String updatedAt;   // ISO 8601

  UserProgressDTO({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.completedAt,
    required this.updatedAt,
  });

  // Construtor de fábrica para criar um DTO a partir do JSON do Supabase
  factory UserProgressDTO.fromMap(Map<String, dynamic> map) {
    return UserProgressDTO(
      id: map['id'] as int,
      // mapeia snake_case JSON para camelCase do DTO
      userId: map['user_id'] as String,
      lessonId: map['lesson_id'] as int,
      completedAt: map['completed_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  // Método para converter o DTO de volta para um Map (para enviar ao Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // converte de volta para snake_case para o Supabase
      'user_id': userId,
      'lesson_id': lessonId,
      'completed_at': completedAt,
      'updated_at': updatedAt,
    };
  }
}