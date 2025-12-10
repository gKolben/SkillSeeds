import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillseeds/core/providers/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:skillseeds/features/providers/presentation/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillseeds/features/providers/data/index.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skillseeds/core/repositories/providers_repository.dart';

class ProvidersPage extends ConsumerStatefulWidget {
  const ProvidersPage({super.key});

  @override
  ConsumerState<ProvidersPage> createState() => _ProvidersPageState();
}

class _ProvidersPageState extends ConsumerState<ProvidersPage> {
  bool _syncingProviders = false;

  @override
  void initState() {
    super.initState();
    // Carrega cache local ao iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Instead of blindly syncing on every start, attempt to load local cache
      // and only trigger a one-shot sync from the server if the cache is empty.
      // This minimizes network traffic on first-run and keeps UI responsive.
      _loadProviders();
    });
  }

  /// Load providers from the local DAO. If the local cache is empty, perform a
  /// one-shot sync from the remote Supabase source via the repository.
  ///
  /// Steps and rationale:
  /// 1. Obtain SharedPreferences and create the local DAO to read cached DTOs.
  /// 2. If cache is empty, build a `ProvidersRepositoryImpl` (which composes the
  ///    Supabase remote datasource and the local DAO) and call `syncProviders()`
  ///    to populate the cache. We do this only when cache is empty to avoid
  ///    surprising background updates.
  /// 3. After attempting sync (success or failure), request the notifier to
  ///    `loadProviders()` to populate UI state from the DAO.
  ///
  /// Notes: always check `mounted` before calling `setState` and wrap debug
  /// logs with `kDebugMode` to avoid polluting production logs.
  Future<void> _loadProviders() async {
    if (kDebugMode) print('ProvidersPage._loadProviders: iniciando leitura do cache local');

    try {
      final prefs = await SharedPreferences.getInstance();
      final dao = ProvidersLocalDaoSharedPrefs(prefs);

      // Read local cache first
      final cached = await dao.listAll();
      if (kDebugMode) print('ProvidersPage._loadProviders: cache contém ${cached.length} items');

      if (cached.isEmpty) {
        // No local items -> perform a one-shot sync to populate cache.
        if (kDebugMode) print('ProvidersPage._loadProviders: cache vazio, iniciando sync one-shot');
        if (mounted) setState(() => _syncingProviders = true);

        try {
          // Build repository using existing Supabase client and SharedPreferences
          final client = Supabase.instance.client;
          final repo = ProvidersRepositoryImpl(client, prefs);

          // syncProviders will fetch from remote and update local cache
          final applied = await repo.syncProviders();
          if (kDebugMode) print('ProvidersRepositoryImpl.syncProviders: aplicados ${applied.length} registros ao cache');
        } catch (e) {
          if (kDebugMode) print('ProvidersPage._loadProviders: erro ao sincronizar: $e');
        } finally {
          if (mounted) setState(() => _syncingProviders = false);
        }
      }

      // In all cases attempt to populate the UI state from repository/DAO
      // via the notifier (keeps single source-of-truth: the notifier's state).
      await ref.read(providersListProvider.notifier).loadProviders();

      // Regardless of cache contents, attempt a bidirectional sync (push then
      // pull). We do this after displaying cached data so the UI remains
      // responsive; sync runs in foreground but does not block rendering.
      if (kDebugMode) print('ProvidersPage._loadProviders: starting bidirectional sync');
      if (mounted) setState(() => _syncingProviders = true);
      try {
        final client = Supabase.instance.client;
        final repo = ProvidersRepositoryImpl(client, prefs);
        await repo.syncProviders();
        // After sync, refresh notifier state from local DAO
        await ref.read(providersListProvider.notifier).loadProviders();
        if (kDebugMode) print('ProvidersPage._loadProviders: bidirectional sync complete');
      } catch (e) {
        if (kDebugMode) print('ProvidersPage._loadProviders: sync failed: $e');
      } finally {
        if (mounted) setState(() => _syncingProviders = false);
      }
    } catch (e) {
      if (kDebugMode) print('ProvidersPage._loadProviders: falha inesperada ao carregar providers: $e');
    }
  }

  Future<void> _doOneShotSync() async {
    setState(() => _syncingProviders = true);
    try {
      await ref.read(providersListProvider.notifier).syncProviders();
      if (kDebugMode) print('ProvidersPage: sincronização completa');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sincronização concluída')));
      }
    } catch (e) {
      if (kDebugMode) print('ProvidersPage: erro ao sincronizar $e');
    } finally {
      if (mounted) setState(() => _syncingProviders = false);
    }
  }

  Future<void> _onRefresh() async {
    await _doOneShotSync();
  }

  @override
  Widget build(BuildContext context) {
    final providers = ref.watch(providersListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Providers')),
      body: Column(
        children: [
          if (_syncingProviders) const LinearProgressIndicator(minHeight: 4),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: providers.isEmpty
                  ? ListView(physics: const AlwaysScrollableScrollPhysics(), children: const [SizedBox(height: 200, child: Center(child: Text('Nenhum provider encontrado')))])
                  : ProviderListView(
                      items: providers,
                      onEdit: (item) async {
                        final updated = await showProviderFormDialog(context, initial: item);
                        if (updated != null) {
                          await ref.read(providersListProvider.notifier).updateProvider(updated);
                        }
                      },
                      onRemove: (id) async {
                        final confirm = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: const Text('Confirmar'), content: const Text('Remover provider?'), actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Não')), TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Sim'))]));
                        if (confirm == true) {
                          await ref.read(providersListProvider.notifier).removeProvider(id);
                        }
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await showProviderFormDialog(context);
          if (created != null) {
            await ref.read(providersListProvider.notifier).createProvider(created);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
