// Comentário: Importa os pacotes principais do Flutter e Riverpod
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Comentário: Importa nossas classes de Tema, Modelos, Providers e Widgets
import 'package:skillseeds/core/config/app_theme.dart';
import 'package:skillseeds/core/models/track.dart';
import 'package:skillseeds/core/providers/providers.dart';
import 'package:skillseeds/core/providers/theme_mode_provider.dart';
import 'package:skillseeds/core/widgets/privacy_dialog.dart';
// Comentário: Importa as rotas para podermos navegar
import 'package:skillseeds/core/config/app_routes.dart';
import 'package:skillseeds/features/courses/presentation/index.dart';

// Comentário: A HomeScreen é um ConsumerWidget para poder "escutar" os providers
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Comentário: Usamos ref.watch para que o Drawer atualize
    //             automaticamente quando o nome/email mudar (Reatividade).
    final userName = ref.watch(userNameProvider);
    final userEmail = ref.watch(userEmailProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SkillSeeds'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      // --- DRAWER (MENU LATERAL) ATUALIZADO ---
      drawer: Drawer(
        child: Column(
          // Comentário: Usamos Column para organizar os itens do menu
          children: [
            // Comentário: O cabeçalho bonito que mostra os dados do usuário
            UserAccountsDrawerHeader(
              accountName: Text(
                userName.isEmpty ? 'Usuário SkillSeeds' : userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              accountEmail: Text(
                userEmail.isEmpty ? 'Complete seu perfil' : userEmail,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                // Reutilizamos o ícone do app
                child: Image.asset(
                  'assets/images/app_icon.png',
                  height: 45,
                  fit: BoxFit.contain,
                ),
              ),
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
              ),
            ),
            // Comentário: Item de navegação para o Perfil do Usuário
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Editar Perfil'),
              onTap: () {
                Navigator.of(context).pop(); // Fecha o drawer
                // Comentário: Navega para a tela de Perfil
                Navigator.of(context).pushNamed(AppRoutes.profile);
              },
            ),

            // --- FEATURE 2: TELA DE CONQUISTAS ---
            // Comentário: Adiciona o novo item de navegação para a tela de Conquistas.
            ListTile(
              leading: const Icon(Icons.emoji_events_outlined), // Ícone de troféu
              title: const Text('Minhas Conquistas'),
              onTap: () {
                Navigator.of(context).pop(); // Fecha o drawer
                // Comentário: Navega para a nova rota que registramos (AppRoutes.achievements).
                Navigator.of(context).pushNamed(AppRoutes.achievements);
              },
            ),

            // Comentário: Spacer() é um widget flexível que "empurra"
            //             os itens seguintes para o final do menu.
            const Spacer(),
            const Divider(), // Uma linha visual para separar

            // Comentário: Item de navegação para Privacidade (agora no final).
            // Theme toggle
            Consumer(builder: (context, ref, _) {
              final mode = ref.watch(themeModeProvider);
              final isDark = mode == ThemeMode.dark;
              final actionIcon = isDark ? Icons.lightbulb_outline : Icons.nightlight_round;
              return SwitchListTile.adaptive(
                value: isDark,
                secondary: Icon(actionIcon),
                title: const Text('Modo Escuro'),
                onChanged: (v) {
                  ref.read(themeModeProvider.notifier).setThemeMode(v ? ThemeMode.dark : ThemeMode.light);
                },
              );
            }),

            ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: const Text('Privacidade & Consentimentos'),
              onTap: () {
                Navigator.of(context).pop(); // Fecha o drawer
                // Comentário: Mostra o diálogo de privacidade que criamos
                showDialog(
                  context: context,
                  builder: (context) => const PrivacyDialog(),
                );
              },
            ),
            // Comentário: Um pequeno espaço para não colar na borda inferior
            const SizedBox(height: 20),
          ],
        ),
      ),
      // --- FIM DO DRAWER ---

      // --- BODY (Lista de Trilhas) ---
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de Cursos (horizontal) adicionada acima das trilhas
            Text('Cursos recomendados:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            SizedBox(
              height: 240,
              child: CoursesPage(),
            ),
            const SizedBox(height: 16),
            Text('Escolha sua trilha de aprendizado:',
                style: Theme.of(context).textTheme.titleLarge),
            Expanded(
              // Comentário: Usamos o 'tracksProvider' para buscar os dados do Supabase.
              // O .when() trata os 3 estados: loading, error, e data.
              child: ref.watch(tracksProvider).when(
                    // Estado 1: Carregando
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    // Estado 2: Erro
                    error: (error, stackTrace) => Center(
                      child: Text(
                        'Erro ao carregar trilhas:\n$error',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Estado 3: Sucesso (Dados recebidos)
                    data: (tracks) {
                      if (tracks.isEmpty) {
                        return const Center(
                          child: Text('Nenhuma trilha encontrada.'),
                        );
                      }
                      // Comentário: Constrói a lista de trilhas
                      return ListView.builder(
                        itemCount: tracks.length,
                        itemBuilder: (context, index) {
                          final track = tracks[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _TrackCard(track: track),
                          );
                        },
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// Comentário: Função auxiliar para converter o Hex da cor (do Supabase) em um objeto Color.
Color _colorFromHex(String hexString) {
  // Remove o '#' se ele existir
  final hexCode = hexString.replaceAll('#', '');
  try {
    // Converte a string hexadecimal para um inteiro e retorna a Cor
    // 'FF' é adicionado para opacidade total
    return Color(int.parse('FF$hexCode', radix: 16));
  } catch (e) {
    // Comentário: Se o Hex for inválido (nulo ou mal formatado),
    //             retorna a cor primária como padrão.
    return AppTheme.primaryColor;
  }
}

// Comentário: O Card que representa uma Trilha.
class _TrackCard extends StatelessWidget {
  final Track track;
  const _TrackCard({required this.track});

  @override
  Widget build(BuildContext context) {
    // Comentário: Usa a cor vinda do Supabase através da função auxiliar
    final cardColor = _colorFromHex(track.colorHex);

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // Comentário: Define a borda do card com a cor da trilha
        side: BorderSide(color: cardColor, width: 1.5),
      ),
      child: InkWell(
        // --- AÇÃO ATUALIZADA ---
        onTap: () {
          // Comentário: Navega para a nova tela de Lições (AppRoutes.lessons)
          //             e passa o objeto 'track' como argumento, para que
          //             a próxima tela saiba quais lições buscar.
          Navigator.of(context).pushNamed(
            AppRoutes.lessons,
            arguments: track,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                track.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      // Comentário: Usa a cor da trilha no título
                      color: cardColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(track.description,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
