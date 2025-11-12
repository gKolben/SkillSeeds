import '../models/achievement.dart';
import '../models/achievement_dto.dart';

// O Mapper (Tradutor) para Achievement
class AchievementMapper {
  // Converte DTO (do Supabase) -> Entity (para o App/UI)
  static Achievement toEntity(AchievementDTO dto) {
    return Achievement(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      iconUrl: dto.icon_url,
      createdAt: DateTime.parse(dto.created_at),
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
      icon_url: entity.iconUrl,
      created_at: entity.createdAt.toIso8601String(),
      // Converte o enum 'AchievementRarity' de volta para String
      rarity: _stringFromRarity(entity.rarity),
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