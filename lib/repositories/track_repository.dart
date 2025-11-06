import 'package:skillseeds/models/track_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/track_dto.dart';
import '../models/track.dart';

class TrackRepository {
  final SupabaseClient _client;

  TrackRepository(this._client);

  Future<List<Track>> getTracks() async {
    try {

      final data = await _client.from('tracks').select();

      final dtoList = (data as List)
          .map((map) => TrackDTO.fromMap(map))
          .toList();

      final trackList = dtoList
          .map((dto) => TrackMapper.toEntity(dto))
          .toList();

      return trackList;

    } catch (e) {
      print('Erro ao buscar trilhas: $e');
      return [];
    }
  }
}