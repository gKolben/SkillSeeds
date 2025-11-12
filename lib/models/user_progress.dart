// Esta é a nossa Entidade (Modelo de Domínio)
// É o formato que o app (UI) vai usar.
class UserProgress {
  final int id;
  final String userId; // ID do usuário do Supabase Auth
  final int lessonId; // ID da Lição (Lesson) que foi completada
  final DateTime completedAt; // <-- Tipo forte (DateTime)
  final DateTime updatedAt;   // <-- Tipo forte (DateTime)

  UserProgress({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.completedAt,
    required this.updatedAt,
  });
}