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

```bash
flutter pub get
```

---

### 2. Configuração do Backend (Supabase)

Este projeto precisa de um backend Supabase para buscar as trilhas de aprendizado.

**Crie seu projeto:** Vá ao Supabase e crie um novo projeto.

**Crie as tabelas:** No *SQL Editor* do seu projeto Supabase, execute o script abaixo para criar e popular a tabela `tracks`:

```sql
-- 1. Cria a tabela para nossas "Trilhas"
create table if not exists public.tracks (
  id bigserial primary key,
  name text not null,
  description text not null,
  color_hex varchar(9) null, -- Para a cor do card
  created_at timestamptz not null default now()
);

-- 2. Insere as duas trilhas que já temos no app
insert into public.tracks (name, description, color_hex)
values
  ('Design', 'Atalhos de ferramentas e conceitos de UI/UX.', '#7C3AED'),
  ('Desenvolvimento', 'Domine atalhos do VS Code, Git e terminal.', '#10B981');
```

**Habilite o Acesso (RLS):** Execute este segundo script para permitir que o app leia a tabela:

```sql
-- Habilita o RLS (Segurança em Nível de Linha)
alter table public.tracks enable row level security;

-- Cria a política que permite que QUALQUER UM (anon) leia a tabela "tracks"
create policy "public read tracks"
on public.tracks
for select
to anon
using (true);
```

---

### 3. Configuração das Chaves de API (Obrigatório)

O aplicativo usa um arquivo `.env` para se conectar ao Supabase com segurança.

**Encontre suas chaves:** No Dashboard do Supabase, vá em *Project Settings (Engrenagem)* → *API*.  
**Crie o arquivo `.env`:** Na raiz do seu projeto Flutter (mesma pasta do `pubspec.yaml`), crie um arquivo chamado `.env`.  
**Copie o molde:** Copie o conteúdo de `.env.example` e cole no seu `.env`.  
**Preencha as chaves:** Cole sua URL e sua chave anon public do Supabase no arquivo `.env`.

```env
SUPABASE_URL=https://<seu-projeto-id>.supabase.co
SUPABASE_ANON_KEY=<sua-chave-anon-aqui>
```

---

### 4. Execute o Aplicativo

Com o `.env` preenchido e as dependências instaladas, rode o app (recomenda-se o Chrome para testes rápidos):

```bash
flutter run -d chrome
```

---

## 🏗️ Estrutura do Projeto

```
lib/
├── config/         # Configurações do app (rotas, temas)
├── mappers/        # Conversores (DTO -> Entity)
├── models/         # Modelos de dados (Entity e DTO)
├── providers/      # Providers Riverpod
├── repositories/   # Lógica de busca de dados (Supabase)
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