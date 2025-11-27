import 'package:flutter_test/flutter_test.dart';
import 'package:skillseeds/mappers/achievement_mapper.dart';
import 'package:skillseeds/core/models/achievement.dart';
import 'package:skillseeds/core/models/achievement_dto.dart';

void main() {
  group('AchievementMapper', () {
    final testDate = DateTime.now();
    final testDateString = testDate.toIso8601String();

    // Teste 1: Converte DTO -> Entity
    test('deve converter corretamente AchievementDTO para Achievement (Entity)',
        () {
      // 1. Arrange
      final dto = AchievementDTO(
        id: 1,
        title: 'Primeira Lição',
        description: 'Você completou sua primeira lição!',
        iconUrl: 'https://icon.url/1.png',
        rarity: 'rare',
        createdAt: testDateString,
      );

      // 2. Act
      final entity = AchievementMapper.toEntity(dto);

      // 3. Assert
      expect(entity.id, 1);
      expect(entity.title, 'Primeira Lição');
      expect(entity.description, 'Você completou sua primeira lição!');
      expect(entity.iconUrl, 'https://icon.url/1.png');
      expect(entity.rarity, AchievementRarity.rare);
      expect(entity.createdAt, testDate);
    });

    // Teste 2: Converte Entity -> DTO
    test('deve converter corretamente Achievement (Entity) para AchievementDTO',
        () {
      // 1. Arrange
      final entity = Achievement(
        id: 2,
        title: 'Trilha de Design',
        description: 'Você completou a trilha de Design.',
        iconUrl: 'https://icon.url/2.png',
        rarity: AchievementRarity.epic,
        createdAt: testDate,
      );

      // 2. Act
      final dto = AchievementMapper.toDto(entity);

      // 3. Assert
      expect(dto.id, 2);
      expect(dto.title, 'Trilha de Design');
      expect(dto.description, 'Você completou a trilha de Design.');
      expect(dto.iconUrl, 'https://icon.url/2.png');
      expect(dto.rarity, 'epic');
      expect(dto.createdAt, testDateString);
    });
  });
}