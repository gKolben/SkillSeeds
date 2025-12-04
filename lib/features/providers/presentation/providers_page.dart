import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillseeds/core/providers/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:skillseeds/features/providers/presentation/widgets/provider_list_view.dart';
import 'dialogs/provider_form_dialog.dart';

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
      ref.read(providersListProvider.notifier).loadProviders();
      _doOneShotSync();
    });
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
