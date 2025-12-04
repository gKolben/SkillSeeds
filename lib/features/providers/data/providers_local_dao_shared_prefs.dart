import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillseeds/features/providers/data/dtos/provider_dto.dart';
import 'package:flutter/foundation.dart';

class ProvidersLocalDaoSharedPrefs {
  static const _kKey = 'providers_cache_v1';
  final SharedPreferences _prefs;

  ProvidersLocalDaoSharedPrefs(this._prefs);

  Future<List<ProviderDto>> listAll() async {
    final encoded = _prefs.getString(_kKey);
    final list = ProviderDto.listFromJsonString(encoded);
    if (kDebugMode) {
      print('ProvidersLocalDaoSharedPrefs.listAll: returning ${list.length} items from cache');
    }
    return list;
  }

  Future<void> upsertAll(List<ProviderDto> dtos) async {
    final encoded = ProviderDto.listToJsonString(dtos);
    await _prefs.setString(_kKey, encoded);
    if (kDebugMode) {
      print('ProvidersLocalDaoSharedPrefs.upsertAll: wrote ${dtos.length} items to cache');
    }
  }

  Future<void> clear() async {
    await _prefs.remove(_kKey);
    if (kDebugMode) print('ProvidersLocalDaoSharedPrefs.clear: cache cleared');
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
    if (kDebugMode) print('ProvidersLocalDaoSharedPrefs.upsert: upserted id=${dto.id}');
  }

  Future<void> removeById(String id) async {
    final list = await listAll();
    list.removeWhere((e) => e.id == id);
    await upsertAll(list);
    if (kDebugMode) print('ProvidersLocalDaoSharedPrefs.removeById: removed id=$id');
  }
}
