class LessonDTO {
  final int id;
  final int trackId;
  final String title;
  final String type;
  final String createdAt;

  LessonDTO({
    required this.id,
    required this.trackId,
    required this.title,
    required this.type,
    required this.createdAt,
  });

  factory LessonDTO.fromMap(Map<String, dynamic> map) {
    return LessonDTO(
      id: map['id'] as int,
      // map snake_case JSON fields to camelCase DTO properties
      trackId: map['track_id'] as int,
      title: map['title'] as String,
      type: map['type'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // convert back to snake_case for Supabase
      'track_id': trackId,
      'title': title,
      'type': type,
      'created_at': createdAt,
    };
  }
}