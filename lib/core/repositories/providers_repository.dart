import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skillseeds/core/models/provider_model.dart' as domain;
import 'package:skillseeds/features/providers/data/providers_local_dao_shared_prefs.dart';
import 'package:skillseeds/features/providers/data/supabase_providers_remote_datasource.dart';
import 'package:skillseeds/core/mappers/provider_mapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Abstração do repositório de Providers.
abstract class ProvidersRepository {
  Future<List<domain.Provider>> fetchProviders();
  Future<List<domain.Provider>> syncProviders();
  Future<void> createProvider(domain.Provider provider);
  Future<void> updateProvider(domain.Provider provider);
  Future<void> removeProvider(String id);
}

/// Implementação que combina datasource remoto (Supabase) com DAO local (SharedPrefs).
class ProvidersRepositoryImpl implements ProvidersRepository {
  final ProvidersLocalDaoSharedPrefs _localDao;
  final SupabaseProvidersRemoteDatasource _remote;

  ProvidersRepositoryImpl(SupabaseClient client, SharedPreferences prefs)
      : _localDao = ProvidersLocalDaoSharedPrefs(prefs),
        _remote = SupabaseProvidersRemoteDatasource(client);

  @override
  Future<List<domain.Provider>> fetchProviders() async {
    try {
      final dtos = await _localDao.listAll();
      final entities = dtos.map((d) => ProviderMapper.toEntity(d)).toList();
      return entities;
    } catch (e, st) {
      developer.log('ProvidersRepositoryImpl.fetchProviders erro', error: e, stackTrace: st);
      return [];
    }
  }

  @override
  Future<List<domain.Provider>> syncProviders() async {
    try {
      final remoteDtos = await _remote.fetchAll();
      // atualiza cache local
      await _localDao.clear();
      await _localDao.upsertAll(remoteDtos);
      final entities = remoteDtos.map((d) => ProviderMapper.toEntity(d)).toList();
      if (kDebugMode) developer.log('ProvidersRepositoryImpl.syncFromServer: aplicados ${entities.length} registros ao cache');
      return entities;
    } catch (e, st) {
      developer.log('ProvidersRepositoryImpl.syncProviders erro', error: e, stackTrace: st);
      return [];
    }
  }

  /// Cria um novo provider no cache local (domain -> dto)
  @override
  Future<void> createProvider(domain.Provider provider) async {
    final dto = ProviderMapper.toDto(provider);
    await _localDao.upsert(dto);
  }

  /// Atualiza um provider existente no cache local
  @override
  Future<void> updateProvider(domain.Provider provider) async {
    final dto = ProviderMapper.toDto(provider);
    await _localDao.upsert(dto);
  }

  /// Remove um provider do cache local
  @override
  Future<void> removeProvider(String id) async {
    await _localDao.removeById(id);
  }
}