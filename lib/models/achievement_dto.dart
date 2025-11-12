// Este é o DTO (espelho do Supabase)
class AchievementDTO {
  final int id;
  final String title;
  final String description;
  final String icon_url; // <-- snake_case
  final String rarity; // <-- String, não enum
  final String created_at; // <-- String ISO 8601

  AchievementDTO({
    required this.id,
    required this.title,
    required this.description,
    required this.icon_url,
    required this.rarity,
    required this.created_at,
  });

  // Construtor de fábrica para criar um DTO a partir do JSON do Supabase
  factory AchievementDTO.fromMap(Map<String, dynamic> map) {
    return AchievementDTO(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      icon_url: map['icon_url'] as String,
      rarity: map['rarity'] as String,
      created_at: map['created_at'] as String,
    );
  }

  // Método para converter o DTO de volta para um Map (para enviar ao Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_url': icon_url,
      'rarity': rarity,
      'created_at': created_at,
    };
  }
}