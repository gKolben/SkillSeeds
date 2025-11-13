import 'package:flutter_test/flutter_test.dart';
import 'package:skillseeds/mappers/user_progress_mapper.dart';
import 'package:skillseeds/models/user_progress.dart';
import 'package:skillseeds/models/user_progress_dto.dart';

void main() {
  group('UserProgressMapper', () {
    final testDate = DateTime.now();
    final testDateString = testDate.toIso8601String();

    // Teste 1: Converte DTO -> Entity
    test('deve converter corretamente UserProgressDTO para UserProgress (Entity)',
        () {
      // 1. Arrange
      final dto = UserProgressDTO(
        id: 1,
        userId: 'user-uuid-123',
        lessonId: 10,
        completedAt: testDateString,
        updatedAt: testDateString,
      );

      // 2. Act
      final entity = UserProgressMapper.toEntity(dto);

      // 3. Assert
      expect(entity.id, 1);
      expect(entity.userId, 'user-uuid-123');
      expect(entity.lessonId, 10);
      expect(entity.completedAt, testDate);
      expect(entity.updatedAt, testDate);
    });

    // Teste 2: Converte Entity -> DTO
    test('deve converter corretamente UserProgress (Entity) para UserProgressDTO',
        () {
      // 1. Arrange
      final entity = UserProgress(
        id: 2,
        userId: 'user-uuid-456',
        lessonId: 20,
        completedAt: testDate,
        updatedAt: testDate,
      );

      // 2. Act
      final dto = UserProgressMapper.toDto(entity);

      // 3. Assert
      expect(dto.id, 2);
      expect(dto.userId, 'user-uuid-456');
      expect(dto.lessonId, 20);
      expect(dto.completedAt, testDateString);
      expect(dto.updatedAt, testDateString);
    });
  });
}