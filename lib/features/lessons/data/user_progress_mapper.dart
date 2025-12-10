import 'package:skillseeds/core/models/user_progress.dart';
import 'package:skillseeds/core/models/user_progress_dto.dart';

// O Mapper (Tradutor) para UserProgress
class UserProgressMapper {
  // Converte DTO (do Supabase) -> Entity (para o App/UI)
  static UserProgress toEntity(UserProgressDTO dto) {
    return UserProgress(
      id: dto.id,
      userId: dto.userId,
      lessonId: dto.lessonId,
      completedAt: DateTime.parse(dto.completedAt),
      updatedAt: DateTime.parse(dto.updatedAt),
    );
  }

  // Converte Entity (do App) -> DTO (para enviar ao Supabase)
  static UserProgressDTO toDto(UserProgress entity) {
    return UserProgressDTO(
      id: entity.id,
      userId: entity.userId,
      lessonId: entity.lessonId,
      completedAt: entity.completedAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }
}
