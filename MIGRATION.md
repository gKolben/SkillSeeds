# Migração para Clean Architecture (feature-first)

Status: concluído (parte) — branch: `migration/clean-architecture`

Resumo das mudanças:

- Estrutura adotada:
  - `lib/core/` — modelos compartilhados, mappers, repositórios core, serviços, providers e widgets globais.
  - `lib/features/<feature>/...` — apresentação (UI), data e domain específicos de cada feature.
- Arquivos que foram movidos/centralizados:
  - `models/*` → `core/models/*`
  - `mappers/*` → continuam em `lib/mappers` (alguns atualizados para usar `core/models`)
  - `repositories/*` → `core/repositories/*`
  - `providers/*` → `core/providers/*`
  - `widgets/*` → `core/widgets/*`
  - `config/*` → `core/config/*`
- Limpeza: arquivos top-level que eram apenas re-exports para `core`/`features` foram removidos para reduzir ambiguidade.

Impacto e instruções para colaboradores:

- Importante: atualize quaisquer importações externas que apontem para os arquivos removidos. Os novos caminhos são:
  - `package:skillseeds/core/...` para modelos, serviços e widgets globais
  - `package:skillseeds/features/<feature>/presentation/...` para telas
- Se você estiver com erros de import após puxar a branch, execute:

```powershell
flutter clean; flutter pub get
```

- Para executar análise e testes localmente:

```powershell
flutter analyze
flutter test
```

Arquivos removidos (exemplos principais):
- `lib/screens/*` (moved to `lib/features/*/presentation`)
- `lib/models/*` (moved to `lib/core/models/*`)
- `lib/widgets/*` (moved to `lib/core/widgets/*`)
- `lib/repositories/*` (moved to `lib/core/repositories/*`)

Risco e recomendações:
- Esta migração é destrutiva sobre os wrappers antigos — mas preserva todo o código funcional em `core`/`features`.
- Recomendo revisão por pares via PR antes de mesclar no `main`.

Próximos passos sugeridos:
1. Revisar PR e rodar CI/testes no servidor (GitHub Actions).
2. Atualizar a documentação do projeto (`README.md`) com a nova organização.
3. Gradualmente mover mappers para `core/mappers` se desejar, e consolidar provedores por feature quando necessário.

Contato:
- Autor da migração: commit recente no branch `migration/clean-architecture`.
