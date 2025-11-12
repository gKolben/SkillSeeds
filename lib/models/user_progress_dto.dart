// Este é o DTO (espelho do Supabase)
class UserProgressDTO {
  final int id;
  final String user_id; // <-- snake_case
  final int lesson_id; // <-- snake_case
  final String completed_at; // <-- String ISO 8601
  final String updated_at;   // <-- String ISO 8601

  UserProgressDTO({
    required this.id,
    required this.user_id,
    required this.lesson_id,
    required this.completed_at,
    required this.updated_at,
  });

  // Construtor de fábrica para criar um DTO a partir do JSON do Supabase
  factory UserProgressDTO.fromMap(Map<String, dynamic> map) {
    return UserProgressDTO(
      id: map['id'] as int,
      user_id: map['user_id'] as String,
      lesson_id: map['lesson_id'] as int,
      completed_at: map['completed_at'] as String,
      updated_at: map['updated_at'] as String,
    );
  }

  // Método para converter o DTO de volta para um Map (para enviar ao Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'lesson_id': lesson_id,
      'completed_at': completed_at,
      'updated_at': updated_at,
    };
  }
}