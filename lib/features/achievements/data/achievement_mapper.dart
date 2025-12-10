import 'package:skillseeds/features/achievements/domain/index.dart';
import 'package:skillseeds/core/models/achievement_dto.dart';

// O Mapper (Tradutor) para Achievement
class AchievementMapper {
  // Converte DTO (do Supabase) -> Entity (para o App/UI)
  static Achievement toEntity(AchievementDTO dto) {
    return Achievement(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      iconUrl: dto.iconUrl,
      createdAt: DateTime.parse(dto.createdAt),
      // Converte a String 'rarity' para o nosso enum 'AchievementRarity'
      rarity: _rarityFromString(dto.rarity),
    );
  }

  // Converte Entity (do App) -> DTO (para enviar ao Supabase)
  static AchievementDTO toDto(Achievement entity) {
    return AchievementDTO(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      iconUrl: entity.iconUrl,
      rarity: _stringFromRarity(entity.rarity),
      createdAt: entity.createdAt.toIso8601String(),
      // Converte o enum 'AchievementRarity' de volta para String
    );
  }

  // --- Funções de conversão privadas ---

  static AchievementRarity _rarityFromString(String rarity) {
    switch (rarity) {
      case 'rare':
        return AchievementRarity.rare;
      case 'epic':
        return AchievementRarity.epic;
      case 'common':
      default:
        return AchievementRarity.common;
    }
  }

  static String _stringFromRarity(AchievementRarity rarity) {
    return rarity.name; // ex: AchievementRarity.rare -> "rare"
  }
}
