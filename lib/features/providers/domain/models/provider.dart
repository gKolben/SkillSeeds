class Provider {
  final String id;
  final String name;
  final String? imageUri;
  final double? distanceKm;

  const Provider({
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

  Provider copyWith({String? id, String? name, String? imageUri, double? distanceKm}) {
    return Provider(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUri: imageUri ?? this.imageUri,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  @override
  String toString() => 'Provider(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Provider && other.id == id && other.name == name && other.imageUri == imageUri && other.distanceKm == distanceKm;
  }

  @override
  int get hashCode => Object.hash(id, name, imageUri, distanceKm);
}
