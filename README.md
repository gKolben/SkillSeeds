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
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiI... (sua chave anon)
```
- Nota: se você copiar a URL/chave do dashboard, não inclua os sinais `<` ou `>` — o app agora os remove automaticamente, mas é melhor manter o arquivo limpo.

### Instalar dependências
```powershell
flutter pub get
```

### Executar o app (web)
```powershell
flutter run -d web-server --web-port=8080
# depois abra http://localhost:8080 no navegador (Edge/Chrome)
```

### Executar o app (mobile)
```powershell
flutter run -d chrome         # web via chrome
flutter run -d emulator-5554 # Android (exemplo)
```

### Rodar testes
```powershell
flutter test                 # roda todos os testes
flutter test test/profile_screen_test.dart  # roda apenas o teste do perfil
```

## Como o Supabase deve ser configurado
- Configure um projeto no Supabase e crie as tabelas necessárias (`tracks`, `lessons`, `achievements`), conforme esperado pelas repositories em `lib/repositories/`.
- Obtenha `SUPABASE_URL` e `SUPABASE_ANON_KEY` no Dashboard → Project Settings → API.

## Estrutura do projeto (resumida)
```
lib/
├─ config/          # rotas, tema
├─ providers/       # providers do Riverpod
├─ services/        # serviços como PrefsService
├─ repositories/    # lógica de acesso a dados (Supabase)
├─ screens/         # telas (onboarding, policy, home, profile, achievements)
├─ widgets/         # componentes reutilizáveis
└─ main.dart        # entrypoint (inicializa Supabase, carrega .env)
```

## Notas de desenvolvimento e troubleshooting
- Se você receber erros de URL com `%3C` / `%3E`, verifique o `.env` e remova `<`/`>`; a sanitização já lida com isso, mas é melhor manter o arquivo correto.
- Se o app Web travar ao salvar consentimento, atualize para a versão mais recente do repositório — o `policy_screen` já tem tratamento de erro e loading.
- Para builds Windows, instale o Visual Studio com o workload "Desktop development with C++".

## Contribuições
- Abra issues para bugs/sugestões.
- Para PRs: mantenha a mensagem de commit em português e descreva claramente o que a mudança faz.

---

Desenvolvido com 💚 pela equipe SkillSeeds
├── screens/        # Telas do aplicativo
├── services/       # Serviços (PrefsService)
├── widgets/        # Widgets reutilizáveis
├── main.dart       # Ponto de entrada do aplicativo
test/               # Testes unitários e de widget
```

---

## 📄 Licença

Este projeto está sob a licença **MIT**.  
Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👥 Contribuições

Contribuições são bem-vindas!  
Sinta-se à vontade para abrir *issues* ou enviar *pull requests*.