class CourseDto {
  final String id;
  final String name;
  final double? rating;
  final double? distanceKm;
  final String? imageUrl;
  final String? taxId;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? contact;
  final Map<String, dynamic>? address;
  final String? descricao;
  final int? durationMinutes;

  CourseDto({
    required this.id,
    required this.name,
    this.rating,
    this.distanceKm,
    this.imageUrl,
    this.taxId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.contact,
    this.address,
    this.descricao,
    this.durationMinutes,
  });

  factory CourseDto.fromJson(Map<String, dynamic> json) {
    return CourseDto(
      id: json['id'] as String,
      name: json['name'] as String,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      distanceKm: json['distance_km'] != null ? (json['distance_km'] as num).toDouble() : null,
      imageUrl: json['image_url'] as String?,
      taxId: json['taxId'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      contact: json['contact'] != null ? Map<String, dynamic>.from(json['contact'] as Map) : null,
      address: json['address'] != null ? Map<String, dynamic>.from(json['address'] as Map) : null,
      descricao: json['descricao'] as String?,
      durationMinutes: json['durationMinutes'] != null ? (json['durationMinutes'] as num).toInt() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rating': rating,
        'distance_km': distanceKm,
        'image_url': imageUrl,
        'taxId': taxId,
        'status': status,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'contact': contact,
        'address': address,
        'descricao': descricao,
        'durationMinutes': durationMinutes,
      };
}
