```markdown
Title: feat(migration): Arquitetura limpa orientada a features (mover para `lib/core` + `lib/features`)

Descrição:
Este PR migra a base de código para uma organização em Clean Architecture orientada por features.

Pontos principais:
- Introduz `lib/core` para modelos compartilhados, serviços, providers, widgets e repositórios.
- Introduz `lib/features/<feature>` para a UI e código específico de cada feature.
- Substitui imports em todo o projeto para usar os caminhos `core`/`features` e removeu wrappers top-level que apenas re-exportavam arquivos.
- Corrige imports dos mappers e atualiza testes para os novos caminhos.

Arquivos removidos:
- Foram removidos wrappers top-level antigos em `lib/screens`, `lib/models`, `lib/widgets`, `lib/config`, `lib/repositories` e `lib/providers` que apenas re-exportavam arquivos de `core`/`features`.

Testes:
- `flutter analyze` → Sem problemas.
- `flutter test` → Todos os testes passaram.

Notas para revisores:
- Trata-se de uma mudança estrutural; revise imports e verifique se alguma API pública externa foi afetada.
- Recomendo executar o app localmente e validar fluxos principais (Home, Onboarding, Lessons, Achievements, Profile).

Como abrir o PR:
- Link sugerido após o push: https://github.com/gKolben/SkillSeeds/pull/new/migration/clean-architecture

```
Title: feat(migration): feature-first Clean Architecture (move to `lib/core` + `lib/features`)

Description:
This PR migrates the codebase toward a feature-first Clean Architecture layout.

Key points:
- Introduces `lib/core` for shared models, services, providers, widgets and repositories.
- Introduces `lib/features/<feature>` for feature UI and feature-specific code.
- Replaced imports across the project to use `core`/`features` paths and removed top-level re-export wrappers.
- Fixed mapper imports and updated tests to the new paths.

Files removed:
- Removed old top-level wrapper files under `lib/screens`, `lib/models`, `lib/widgets`, `lib/config`, `lib/repositories`, and `lib/providers` that only re-exported `core`/`features` files.

Testing:
- `flutter analyze` → No issues found.
- `flutter test` → All tests passed.

Notes for reviewers:
- This is a structural change; please review imports and look for any missing public APIs external tools may reference.
- I recommend running the app locally and checking key flows (Home, Onboarding, Lessons, Achievements, Profile).

How to open PR:
- GitHub suggested link after pushing: https://github.com/gKolben/SkillSeeds/pull/new/migration/clean-architecture

