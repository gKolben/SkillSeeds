# SkillSeeds 🌱

**SkillSeeds** é uma plataforma educacional Flutter que oferece micro-aprendizado através de trilhas, lições interativas e um sistema de conquistas. O aplicativo utiliza Supabase como backend e Riverpod para gerenciamento de estado, com arquitetura feature-first seguindo princípios de Clean Architecture.

---

## 📱 Funcionalidades

### 🎯 Core Features
- **Trilhas de Aprendizado:** Conteúdo organizado por tópicos (Design, Desenvolvimento, etc.)
- **Lições Interativas:** Três tipos de lições (leitura, vídeo, quiz) com acompanhamento de progresso
- **Sistema de Conquistas:** Badges com níveis de raridade (common, rare, epic) para engajamento
- **Provedores Educacionais:** Catálogo de instituições parceiras com informações de cursos e localização

### 👤 Perfil & Personalização
- **Perfil de Usuário:** Edição de nome e e-mail com persistência local
- **Modo Escuro:** Toggle entre tema claro/escuro com persistência de preferência
- **Menu Drawer Reativo:** Atualização automática do perfil no menu lateral

### 🔐 Conformidade & Segurança
- **Onboarding Intuitivo:** Fluxo de boas-vindas para novos usuários
- **Gestão de Consentimento (LGPD):** Sistema completo de políticas com scroll obrigatório
- **Validação de Leitura:** Usuários devem rolar até o final dos termos antes de aceitar
- **Políticas Atualizadas:** Privacy Policy e Terms of Use refletindo funcionalidades atuais

### 🔄 Sincronização & Persistência
- **Sincronização Bidirecional:** Dados sincronizados entre dispositivos via Supabase
- **Armazenamento Local:** Cache offline com SharedPreferences
- **Progresso de Usuário:** Tracking de lições completadas e conquistas desbloqueadas

---

## 🏗️ Arquitetura

### Estrutura do Projeto (Feature-First)
```
lib/
├── core/                           # Código compartilhado
│   ├── config/                     # Configurações (rotas, temas)
│   ├── models/                     # Modelos de domínio compartilhados
│   ├── mappers/                    # Conversores DTO ↔ Entity
│   ├── repositories/               # Repositórios core
│   ├── services/                   # Serviços (prefs, etc.)
│   ├── providers/                  # Riverpod providers globais
│   └── widgets/                    # Widgets reutilizáveis
│
├── features/                       # Features organizadas por domínio
│   ├── achievements/
│   │   ├── domain/                 # Models e interfaces
│   │   ├── data/                   # DTOs, mappers, datasources
│   │   └── presentation/           # UI (screens, widgets)
│   ├── courses/
│   ├── lessons/
│   ├── profile/
│   └── providers/
│
└── legacy/                         # Backup de arquivos migrados
```

### Padrões Utilizados
- **DTO Pattern:** Separação entre objetos de transferência e entidades de domínio
- **Repository Pattern:** Abstração da camada de dados
- **Provider Pattern:** Injeção de dependência e gerenciamento de estado com Riverpod
- **Barrel Files:** Exports centralizados via `index.dart` para imports limpos

---

## 🛠️ Tecnologias

### Core
- **Flutter** - Framework multiplataforma
- **Dart** - Linguagem de programação
- **Riverpod** - Gerenciamento de estado e DI

### Backend & Dados
- **Supabase** - Backend-as-a-Service (PostgreSQL, RLS, Auth)
- **SharedPreferences** - Persistência local de preferências

### UI & UX
- **Flutter Markdown** - Renderização de políticas
- **Material Design 3** - Sistema de design com suporte a temas

### Qualidade
- **mocktail** - Mocking para testes
- **flutter_test** - Framework de testes unitários e de widget
- **flutter_dotenv** - Gerenciamento seguro de variáveis de ambiente

---

## 🚀 Como Começar

### Pré-requisitos
- **Flutter SDK** (versão estável mais recente)
- **Dart SDK** (incluído com Flutter)
- **VS Code** ou **Android Studio**
- **Conta Supabase** (gratuita)
- **(Opcional)** Visual Studio com **Desktop development with C++** para builds Windows

### 1. Instalação

Clone o repositório:
```bash
git clone https://github.com/gKolben/SkillSeeds.git
cd SkillSeeds
```

Instale as dependências:
```bash
flutter pub get
```

### 2. Configuração

Crie um arquivo `.env` na raiz do projeto:
```env
SUPABASE_URL=https://seu-projeto.supabase.co
SUPABASE_ANON_KEY=sua_chave_anon_key_aqui
```

> ⚠️ **Importante:** Nunca commite o arquivo `.env` com suas chaves reais!

### 3. Executar o App

**Web:**
```bash
flutter run -d chrome
# ou
flutter run -d web-server --web-port=8080
```

**Windows:**
```bash
flutter run -d windows
```

**Android/iOS:**
```bash
flutter run
```

### 4. Testes

Executar análise estática:
```bash
flutter analyze
```

Executar todos os testes:
```bash
flutter test
```

Executar testes com cobertura:
```bash
flutter test --coverage
```

---

## 📊 Status do Projeto

✅ **Funcionalidades Implementadas**
- [x] Sistema de autenticação e onboarding
- [x] Trilhas e lições dinâmicas
- [x] Sistema de conquistas
- [x] Provedores educacionais com CRUD
- [x] Modo escuro persistente
- [x] Sincronização de dados
- [x] Políticas LGPD com validação de leitura
- [x] Arquitetura feature-first completa

📈 **Métricas**
- 17 testes passando
- 0 warnings no analyzer
- Arquitetura organizada e escalável

---

## 🤝 Contribuindo

Este é um projeto educacional, mas sugestões são bem-vindas! Para contribuir:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

---

## 📝 Changelog

### [1.0.0] - 2025-12-10

#### Adicionado
- Sistema de modo escuro com persistência
- Validação obrigatória de scroll em políticas
- Sincronização bidirecional de provedores
- Sistema de conquistas com raridades
- Organização completa feature-first

#### Modificado
- Migração de arquitetura para feature/domain/data/presentation
- Atualização de políticas para refletir funcionalidades atuais
- Conversão de imports relativos para package-style
- Consolidação de duplicatas em `lib/legacy`

#### Corrigido
- Bug de onboarding não salvando estado
- Conflitos de tipos em Provider model
- Warnings de linting em variáveis locais

---

## 📄 Licença

Este projeto é de uso educacional.

---

## 👨‍💻 Autor

**gKolben**
- GitHub: [@gKolben](https://github.com/gKolben)

---

## 🙏 Agradecimentos

- Comunidade Flutter
- Equipe Supabase
- Contribuidores do Riverpod

## 🔁 Contribuições
- Abra issues para bugs ou sugestões.
- Para PRs estruturais, inclua uma descrição clara e passos para testar.

---

Desenvolvido com 💚 pela equipe SkillSeeds

```