import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillseeds/features/providers/data/dtos/provider_dto.dart';

class ProvidersLocalDaoSharedPrefs {
  static const _kKey = 'providers_cache_v1';
  final SharedPreferences _prefs;

  ProvidersLocalDaoSharedPrefs(this._prefs);

  Future<List<ProviderDto>> listAll() async {
    final encoded = _prefs.getString(_kKey);
    return ProviderDto.listFromJsonString(encoded);
  }

  Future<void> upsertAll(List<ProviderDto> dtos) async {
    final encoded = ProviderDto.listToJsonString(dtos);
    await _prefs.setString(_kKey, encoded);
  }

  Future<void> clear() async {
    await _prefs.remove(_kKey);
  }

  Future<void> upsert(ProviderDto dto) async {
    final list = await listAll();
    final idx = list.indexWhere((e) => e.id == dto.id);
    if (idx >= 0) {
      list[idx] = dto;
    } else {
      list.add(dto);
    }
    await upsertAll(list);
  }

  Future<void> removeById(String id) async {
    final list = await listAll();
    list.removeWhere((e) => e.id == id);
    await upsertAll(list);
  }
}
