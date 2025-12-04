import '../../domain/models/provider.dart';
import '../dtos/provider_dto.dart';

class ProviderMapper {
  static Provider toEntity(ProviderDto dto) {
    return Provider(
      id: dto.id,
      name: dto.name,
      imageUri: dto.imageUrl,
      distanceKm: (dto.distanceKm)?.toDouble(),
    );
  }

  static ProviderDto toDto(Provider entity) {
    return ProviderDto(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUri,
      distanceKm: entity.distanceKm,
    );
  }
}
