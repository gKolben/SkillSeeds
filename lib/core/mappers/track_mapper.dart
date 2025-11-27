import '../models/track.dart';
import '../models/track_dto.dart';

class TrackMapper {
  static Track toEntity(TrackDTO dto) {
    return Track(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      colorHex: dto.colorHex ?? '#FFFFFF',
      createdAt: DateTime.parse(dto.createdAt),
    );
  }
}
