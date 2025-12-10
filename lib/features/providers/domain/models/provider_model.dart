class Provider {
  final String id;
  final String name;
  final String? imageUri;
  final double? distanceKm;

  Provider({
    required this.id,
    required this.name,
    this.imageUri,
    this.distanceKm,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUri: json['imageUri'] as String?,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUri': imageUri,
      'distanceKm': distanceKm,
    };
  }
}
