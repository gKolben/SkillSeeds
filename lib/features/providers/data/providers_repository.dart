import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skillseeds/features/providers/domain/models/provider.dart' as domain;
import 'package:skillseeds/features/providers/data/providers_local_dao_shared_prefs.dart';
import 'package:skillseeds/features/providers/data/supabase_providers_remote_datasource.dart';
import 'package:skillseeds/features/providers/data/mappers/provider_mapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

abstract class ProvidersRepository {
  Future<List<domain.Provider>> fetchProviders();
  Future<List<domain.Provider>> syncProviders();
  Future<void> createProvider(domain.Provider provider);
  Future<void> updateProvider(domain.Provider provider);
  Future<void> removeProvider(String id);
}

class ProvidersRepositoryImpl implements ProvidersRepository {
  final ProvidersLocalDaoSharedPrefs _localDao;
  final SupabaseProvidersRemoteDatasource _remote;
  final SharedPreferences _prefs;

  ProvidersRepositoryImpl(SupabaseClient client, SharedPreferences prefs)
      : _localDao = ProvidersLocalDaoSharedPrefs(prefs),
        _remote = SupabaseProvidersRemoteDatasource(client),
        _prefs = prefs;

  @override
  Future<List<domain.Provider>> fetchProviders() async {
    try {
      final dtos = await _localDao.listAll();
      if (kDebugMode) print('ProvidersRepositoryImpl.fetchProviders: loaded ${dtos.length} DTOs from local DAO');
      final entities = dtos.map((d) => ProviderMapper.toEntity(d)).toList();
      if (kDebugMode) print('ProvidersRepositoryImpl.fetchProviders: mapped to ${entities.length} domain entities');
      return entities;
    } catch (e, st) {
      developer.log('ProvidersRepositoryImpl.fetchProviders erro', error: e, stackTrace: st);
      return [];
    }
  }

  @override
  Future<List<domain.Provider>> syncProviders() async {
    try {
      try {
        final localDtos = await _localDao.listAll();
        if (kDebugMode) print('ProvidersRepositoryImpl.syncProviders: attempting push of ${localDtos.length} local DTOs');
        final pushed = await _remote.upsertProviders(localDtos);
        if (kDebugMode) print('ProvidersRepositoryImpl.syncProviders: pushed $pushed items to remote');
      } catch (e) {
        developer.log('ProvidersRepositoryImpl.syncProviders push error: $e');
      }

      final remoteDtos = await _remote.fetchAll();
      if (kDebugMode) print('ProvidersRepositoryImpl.syncProviders: fetched ${remoteDtos.length} DTOs from remote');

      final lastSyncStr = _prefs.getString('providers_last_sync');
      DateTime? lastSync;
      if (lastSyncStr != null) {
        lastSync = DateTime.tryParse(lastSyncStr);
      }

      final toApply = lastSync == null
          ? remoteDtos
          : remoteDtos.where((d) => d.updatedAt != null && d.updatedAt!.isAfter(lastSync!)).toList();

      if (toApply.isNotEmpty) {
        await _localDao.upsertAll(toApply);
        final latest = toApply.map((d) => d.updatedAt).where((d) => d != null).cast<DateTime?>().toList();
        if (latest.isNotEmpty) {
          latest.sort((a, b) => a!.compareTo(b!));
          final newest = latest.last!;
          await _prefs.setString('providers_last_sync', newest.toIso8601String());
          if (kDebugMode) print('ProvidersRepositoryImpl.syncProviders: updated lastSync to ${newest.toIso8601String()}');
        }
      }

      final entities = (await _localDao.listAll()).map((d) => ProviderMapper.toEntity(d)).toList();
      if (kDebugMode) developer.log('ProvidersRepositoryImpl.syncFromServer: aplicados ${entities.length} registros ao cache');
      return entities;
    } catch (e, st) {
      developer.log('ProvidersRepositoryImpl.syncProviders erro', error: e, stackTrace: st);
      return [];
    }
  }

  @override
  Future<void> createProvider(domain.Provider provider) async {
    final dto = ProviderMapper.toDto(provider);
    await _localDao.upsert(dto);
    if (kDebugMode) print('ProvidersRepositoryImpl.createProvider: created id=${provider.id} (local)');

    try {
      await _remote.upsertProviders([dto]);
      if (kDebugMode) print('ProvidersRepositoryImpl.createProvider: pushed id=${provider.id} to remote');
    } catch (e) {
      developer.log('ProvidersRepositoryImpl.createProvider push error: $e');
    }
  }

  @override
  Future<void> updateProvider(domain.Provider provider) async {
    final dto = ProviderMapper.toDto(provider);
    await _localDao.upsert(dto);
    if (kDebugMode) print('ProvidersRepositoryImpl.updateProvider: updated id=${provider.id} (local)');

    try {
      await _remote.upsertProviders([dto]);
      if (kDebugMode) print('ProvidersRepositoryImpl.updateProvider: pushed id=${provider.id} to remote');
    } catch (e) {
      developer.log('ProvidersRepositoryImpl.updateProvider push error: $e');
    }
  }

  @override
  Future<void> removeProvider(String id) async {
    await _localDao.removeById(id);
    if (kDebugMode) print('ProvidersRepositoryImpl.removeProvider: removed id=$id (local)');

    try {
      await _remote.deleteProvider(id);
      if (kDebugMode) print('ProvidersRepositoryImpl.removeProvider: deleted id=$id from remote');
    } catch (e) {
      developer.log('ProvidersRepositoryImpl.removeProvider delete error: $e');
    }
  }
}
