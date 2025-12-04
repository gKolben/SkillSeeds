import 'dart:convert';

class ProviderDto {
  final String id;
  final String name;
  final String? imageUrl;
  final num? distanceKm;

  ProviderDto({
    required this.id,
    required this.name,
    this.imageUrl,
    this.distanceKm,
  });

  factory ProviderDto.fromJson(Map<String, dynamic> json) {
    return ProviderDto(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      distanceKm: json['distance_km'] as num?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'distance_km': distanceKm,
    };
  }

  static List<ProviderDto> listFromJsonString(String? encoded) {
    if (encoded == null || encoded.isEmpty) return [];
    final list = json.decode(encoded) as List<dynamic>;
    return list.map((e) => ProviderDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJsonString(List<ProviderDto> dtos) {
    final list = dtos.map((d) => d.toJson()).toList();
    return json.encode(list);
  }
}
