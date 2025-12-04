# Providers Sync — Verificação e Troubleshooting

Este documento descreve como validar localmente a sincronização de `Providers` (push/pull) e os logs esperados.

Pré-requisitos
- Ter `flutter` instalado e configurado.
- Ter as variáveis de ambiente `SUPABASE_URL` e `SUPABASE_ANON_KEY` configuradas se for validar o push/pull contra Supabase.

Comportamento implementado
- Persistência local: o DAO `ProvidersLocalDaoSharedPrefs` grava JSON em `SharedPreferences`.
- Sincronização bidirecional: `ProvidersRepositoryImpl.syncProviders()` faz um `push` best-effort (envia cache local via `upsert`) e depois um `pull` (aplica deltas remotos desde `providers_last_sync`).
- Push imediato: operações `createProvider`, `updateProvider` e `removeProvider` tentam enviar a alteração ao Supabase imediatamente (best-effort).
- UI trigger: `ProvidersPage` carrega cache local imediatamente e, em seguida, executa a sincronização bidirecional, exibindo um `LinearProgressIndicator` durante o processo.

Passos para validar localmente (sem Supabase)
1. Abra o app localmente: `flutter run -d edge` (ou `-d windows`).
2. Na tela de Providers, crie um provider. Isso chamará `ProvidersNotifier.createProvider` → `ProvidersRepositoryImpl.createProvider`:
   - O item será gravado no `SharedPreferences` imediatamente.
   - O repositório tentará empurrar para o Supabase (se configurado); em ambiente sem Supabase isso falhará, mas o item permanecerá local.
3. Feche o app completamente e abra novamente.
   - A UI deve exibir o provider criado (persistência local OK).
4. Para forçar sincronização manual (quando Supabase configurado), puxe para atualizar (`RefreshIndicator`).

Passos para validar com Supabase (remoto)
1. Defina `SUPABASE_URL` e `SUPABASE_ANON_KEY` no ambiente ou inicialize `Supabase` no `main.dart` com as credenciais.
2. Abra o app: `flutter run -d edge`.
3. Crie/edite um provider localmente. Observe logs no console.
4. Após a operação, verifique no dashboard do Supabase (ou em outro dispositivo) se o item aparece.
5. Para testar convergência: crie um item em outro cliente (ou no dashboard) e então puxe a lista no app.

Logs esperados (modo debug)
- Ao carregar cache local:
```
ProvidersPage._loadProviders: iniciando leitura do cache local
ProvidersPage._loadProviders: cache contém 0 items
```
- Ao iniciar push:
```
ProvidersRepositoryImpl.syncProviders: attempting push of 2 local DTOs
SupabaseProvidersRemoteDatasource.upsertProviders: sending 2 items
SupabaseProvidersRemoteDatasource.upsertProviders: server returned 2 items
ProvidersRepositoryImpl.syncProviders: pushed 2 items to remote
```
- Ao aplicar pull e atualizar lastSync:
```
ProvidersRepositoryImpl.syncProviders: fetched 3 DTOs from remote
ProvidersRepositoryImpl.syncProviders: updated lastSync to 2025-12-04T12:34:56Z
ProvidersRepositoryImpl.syncFromServer: aplicados 3 registros ao cache
```
- Ao criar/atualizar/remover com push imediato:
```
ProvidersRepositoryImpl.createProvider: created id=p5 (local)
ProvidersRepositoryImpl.createProvider: pushed id=p5 to remote
ProvidersRepositoryImpl.removeProvider: removed id=p5 (local)
ProvidersRepositoryImpl.removeProvider: deleted id=p5 from remote
```

Checklist de troubleshooting
- `ProviderDto.updatedAt` aparece como `null` no servidor: verifique se a tabela `providers` possui coluna `updated_at` e se o PostgREST/Supabase retorna `updated_at` em formato ISO8601.
- `response.error` no Supabase: verifique políticas RLS e role `anon` ou use uma role com permissões para debug.
- Push falha mas item gravado localmente: o fluxo é best-effort; o item ficará local e será re-enviado no próximo sync.

Comandos úteis
```powershell
flutter analyze
flutter test
flutter run -d edge
```

Se quiser, eu executo o app no Edge agora e mostro os logs ao vivo (vou rodar o comando no terminal).