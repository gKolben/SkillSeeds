class AchievementDTO {
  final int id;
  final String title;
  final String description;
  final String iconUrl;
  final String rarity;
  final String createdAt;

  AchievementDTO({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.rarity,
    required this.createdAt,
  });

  factory AchievementDTO.fromMap(Map<String, dynamic> map) {
    return AchievementDTO(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      iconUrl: map['icon_url'] as String,
      rarity: map['rarity'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_url': iconUrl,
      'rarity': rarity,
      'created_at': createdAt,
    };
  }
}
