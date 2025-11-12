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
        user_id: 'user-uuid-123',
        lesson_id: 10,
        completed_at: testDateString,
        updated_at: testDateString,
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
      expect(dto.user_id, 'user-uuid-456');
      expect(dto.lesson_id, 20);
      expect(dto.completed_at, testDateString);
      expect(dto.updated_at, testDateString);
    });
  });
}