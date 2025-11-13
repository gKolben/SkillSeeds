// Este é o DTO (espelho do Supabase)
class AchievementDTO {
  final int id;
  final String title;
  final String description;
  // Usamos camelCase nas propriedades Dart e mapeamos para/desde snake_case no JSON
  final String iconUrl;
  final String rarity; // <-- String, não enum
  final String createdAt; // <-- String ISO 8601

  AchievementDTO({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.rarity,
    required this.createdAt,
  });

  // Construtor de fábrica para criar um DTO a partir do JSON do Supabase
  factory AchievementDTO.fromMap(Map<String, dynamic> map) {
    return AchievementDTO(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      // Mapeia os campos snake_case vindos do Supabase para camelCase do DTO
      iconUrl: map['icon_url'] as String,
      rarity: map['rarity'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  // Método para converter o DTO de volta para um Map (para enviar ao Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      // Converte de volta para o formato esperado pelo Supabase (snake_case)
      'icon_url': iconUrl,
      'rarity': rarity,
      'created_at': createdAt,
    };
  }
}