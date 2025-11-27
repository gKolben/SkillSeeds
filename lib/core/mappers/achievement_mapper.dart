import '../models/achievement.dart';
import '../models/achievement_dto.dart';

class AchievementMapper {
  static Achievement toEntity(AchievementDTO dto) {
    return Achievement(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      iconUrl: dto.iconUrl,
      createdAt: DateTime.parse(dto.createdAt),
      rarity: _rarityFromString(dto.rarity),
    );
  }

  static AchievementDTO toDto(Achievement entity) {
    return AchievementDTO(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      iconUrl: entity.iconUrl,
      rarity: _stringFromRarity(entity.rarity),
      createdAt: entity.createdAt.toIso8601String(),
    );
  }

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
    return rarity.name;
  }
}
