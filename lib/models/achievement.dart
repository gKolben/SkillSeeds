// Define os tipos de raridade da conquista (tipo forte)
enum AchievementRarity {
  common,
  rare,
  epic
}

// Esta é a nossa Entidade (Modelo de Domínio)
// É o formato que o app (UI) vai usar.
class Achievement {
  final int id;
  final String title;
  final String description;
  final String iconUrl; // URL para a imagem da medalha (tipo forte, poderia ser Uri)
  final AchievementRarity rarity; // <-- Tipo forte (enum)
  final DateTime createdAt; // <-- Tipo forte (DateTime)

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.rarity,
    required this.createdAt,
  });
}