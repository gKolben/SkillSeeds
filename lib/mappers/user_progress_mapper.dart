import '../models/user_progress.dart';
import '../models/user_progress_dto.dart';

// O Mapper (Tradutor) para UserProgress
class UserProgressMapper {
  // Converte DTO (do Supabase) -> Entity (para o App/UI)
  static UserProgress toEntity(UserProgressDTO dto) {
    return UserProgress(
      id: dto.id,
      userId: dto.user_id,
      lessonId: dto.lesson_id,
      completedAt: DateTime.parse(dto.completed_at),
      updatedAt: DateTime.parse(dto.updated_at),
    );
  }

  // Converte Entity (do App) -> DTO (para enviar ao Supabase)
  static UserProgressDTO toDto(UserProgress entity) {
    return UserProgressDTO(
      id: entity.id,
      user_id: entity.userId,
      lesson_id: entity.lessonId,
      completed_at: entity.completedAt.toIso8601String(),
      updated_at: entity.updatedAt.toIso8601String(),
    );
  }
}