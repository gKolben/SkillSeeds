/// Representa uma única trilha de aprendizado vinda do Supabase.
class Track {
  final int id;
  final String name;
  final String description;
  final String colorHex;
  final DateTime createdAt;

  Track({
    required this.id,
    required this.name,
    required this.description,
    required this.colorHex,
    required this.createdAt,
  });

  /// Construtor de fábrica para criar uma [Track] a partir de um mapa (JSON).
  /// Isso converte os dados do Supabase em um objeto Dart.
  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      // Valor padrão (roxo) caso a cor não venha do banco
      colorHex: (map['color_hex'] ?? '#7C3AED') as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}