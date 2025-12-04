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

  // Método para conversão de JSON para Provider
  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUri: json['imageUri'] as String?,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    );
  }

  // Método para conversão de Provider para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUri': imageUri,
      'distanceKm': distanceKm,
    };
  }
}