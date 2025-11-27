# SkillSeeds 🌱

**SkillSeeds** é um aplicativo Flutter dedicado ao aprendizado contínuo através de micro-exercícios diários.  
O app ajuda usuários a desenvolverem novas habilidades em apenas **5 minutos por dia**, com conteúdo dinâmico carregado de um backend **Supabase**.

---

## 📱 Funcionalidades

- **Trilhas de Aprendizado via Supabase:** Conteúdo (Design, Dev) carregado dinamicamente do banco de dados.  
- **Perfil de Usuário:** Salve e edite nome e e-mail com persistência local.  
- **Menu Lateral (Drawer) Reativo:** O menu reflete seu nome de perfil em tempo real após a edição.  
- **Onboarding Intuitivo:** Fluxo de boas-vindas para novos usuários.  
- **Gestão de Consentimento (LGPD):** Sistema de consentimento inicial e revogação granular (separando marketing de dados pessoais).  
- **Arquitetura Limpa:** Implementação do padrão DTO (Data Transfer Object) e Mapper para separação de responsabilidades.  
- **Testes Unitários e de Widget:** Cobertura de testes para a lógica de serviços (PrefsService) e validação de UI (ProfileScreen).

---

## 🛠️ Tecnologias Utilizadas

- **Flutter**  
- **Supabase:** Backend como Serviço (Banco de Dados Postgres, RLS).  
- **Riverpod:** Gerenciamento de estado e injeção de dependência.  
- **flutter_dotenv:** Gerenciamento seguro de chaves de API (arquivo `.env`).  
- **Shared Preferences:** Persistência local de preferences, perfil e consentimentos.  
- **mocktail:** Simulação (mocking) para testes unitários e de widget.  
- **Flutter Markdown:** Renderização das políticas de privacidade.

---

## 🚀 Começando

### Pré-requisitos

- Flutter (última versão estável)  
- Uma conta gratuita no Supabase  
- VS Code (recomendado)

---

### 1. Instalação Local

Clone o repositório:

```bash
git clone https://github.com/gKolben/SkillSeeds.git
cd SkillSeeds
```

Instale as dependências:

**SkillSeeds** 🌱

SkillSeeds é um aplicativo Flutter focado em micro-aprendizado — curtas atividades diárias para aprender ou reforçar habilidades. O projeto usa Supabase como backend para conteúdo dinâmico e Riverpod para gerenciamento de estado.

**Resumo das atualizações recentes**
- Sanitização automática das variáveis `SUPABASE_URL` e `SUPABASE_ANON_KEY` em `lib/main.dart` (remove `<`/`>` e espaços) para evitar URLs inválidas.
- Correção no fluxo de consentimento em `lib/screens/policy_screen.dart` para evitar bloqueio ao salvar consentimento (tratamento de erro e loading).
- Ajustes nos testes: `test/profile_screen_test.dart` corrigido e passando localmente.

**Funcionalidades principais**
- Onboarding e fluxo de consentimento (políticas e termos).
- Perfil do usuário com persistência local (nome/e-mail).
- Conteúdo carregado via Supabase: trilhas, lições e conquistas.
- Tela de conquistas (achievements) e lista de lições.

**Tecnologias**
- Flutter
- Riverpod (state management)
- Supabase (backend)
- Shared Preferences (persistência local)
- Flutter Markdown (renderização de políticas)

## Começando (desenvolvimento)

### Pré-requisitos
- Flutter SDK (versão estável compatível)
- Dart
- VS Code ou Android Studio
- (Opcional, para build Windows) Visual Studio com workload **Desktop development with C++**

### Configurar variáveis de ambiente
Crie um arquivo `.env` na raiz (não comitar chaves privadas). Exemplo:
```text
SUPABASE_URL=https://rzkkuvydpwyhhmndyblp.supabase.co
```markdown
# SkillSeeds 🌱

**SkillSeeds** é um aplicativo Flutter focado em micro-aprendizado: pequenas atividades diárias para desenvolver hábitos de estudo. O projeto usa Supabase como backend e Riverpod para gerenciamento de estado.

## ✅ Visão geral
- Onboarding e fluxo de consentimento (LGPD).
- Perfil do usuário com persistência local (nome/e-mail).
- Conteúdo dinâmico via Supabase: trilhas, lições e conquistas.
- Arquitetura: migração para organização feature-first Clean Architecture (`lib/core` + `lib/features`).

## 🧭 Estrutura principal (atual)
- `lib/core/` — modelos compartilhados, mappers, repositórios core, serviços, providers e widgets globais.
- `lib/features/<feature>/` — código específico de cada feature (UI, data, domain).

## 🚀 Como rodar (desenvolvimento)

1. Clone o repositório e entre na pasta:

```bash
git clone https://github.com/gKolben/SkillSeeds.git
cd SkillSeeds
```

2. Instale dependências:

```powershell
flutter pub get
```

3. Configure variáveis de ambiente criando um arquivo `.env` (não comitar):

```text
SUPABASE_URL=https://<seu-projeto>.supabase.co
SUPABASE_ANON_KEY=<sua_chave_anon>
```

4. Executar localmente (web):

```powershell
flutter run -d web-server --web-port=8080
# Abra http://localhost:8080
```

5. Executar testes:

```powershell
flutter analyze
flutter test
```

## 🛠️ Notas importantes
- Para builds Windows, instale o Visual Studio com o workload **Desktop development with C++**.
- Se tiver problemas com a URL contendo `<` ou `>`, verifique o arquivo `.env`; o app sanitiza, mas é melhor manter o arquivo limpo.

## 📝 Migração para Clean Architecture
Esta branch contém uma migração estrutural para `lib/core` e `lib/features`. Os wrappers top-level que apenas re-exportavam arquivos foram removidos e os imports foram atualizados.

Se você der `git pull` da branch de migração e encontrar erros de import, rode:

```powershell
flutter clean
flutter pub get
```

## 🔁 Contribuições
- Abra issues para bugs ou sugestões.
- Para PRs estruturais, inclua uma descrição clara e passos para testar.

---

Desenvolvido com 💚 pela equipe SkillSeeds

```