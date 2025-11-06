class LessonDTO {
  final int id;
  final int track_id;
  final String title;
  final String type;
  final String created_at;

  LessonDTO({
    required this.id,
    required this.track_id,
    required this.title,
    required this.type,
    required this.created_at,
  });

  factory LessonDTO.fromMap(Map<String, dynamic> map) {
    return LessonDTO(
      id: map['id'] as int,
      track_id: map['track_id'] as int,
      title: map['title'] as String,
      type: map['type'] as String,
      created_at: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'track_id': track_id,
      'title': title,
      'type': type,
      'created_at': created_at,
    };
  }
}