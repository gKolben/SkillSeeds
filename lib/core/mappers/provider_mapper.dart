import 'package:skillseeds/core/models/provider_model.dart';
import 'package:skillseeds/features/providers/data/index.dart';

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
