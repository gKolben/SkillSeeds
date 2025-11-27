class TrackDTO {
  final int id;
  final String name;
  final String description;
  final String? colorHex;
  final String createdAt;

  TrackDTO({
    required this.id,
    required this.name,
    required this.description,
    this.colorHex,
    required this.createdAt,
  });

  factory TrackDTO.fromMap(Map<String, dynamic> map) {
    return TrackDTO(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      colorHex: map['color_hex'] as String?,
      createdAt: map['created_at'] as String,
    );
  }
}
