// Define os tipos de raridade da conquista (tipo forte)
enum AchievementRarity {
  common,
  rare,
  epic
}

class Achievement {
  final int id;
  final String title;
  final String description;
  final String iconUrl;
  final AchievementRarity rarity;
  final DateTime createdAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.rarity,
    required this.createdAt,
  });
}
