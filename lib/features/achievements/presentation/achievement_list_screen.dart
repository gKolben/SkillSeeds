// Comentário: Importa o pacote principal do Flutter (Material Design).
import 'package:flutter/material.dart';
// Comentário: Importa o Riverpod para "escutar" os nossos providers.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Comentário: Importa o provider que busca as conquistas do Supabase.
import 'package:skillseeds/core/providers/providers.dart';
// Comentário: Importa o nosso modelo de dados (Entity) de Conquista.
import 'package:skillseeds/core/models/achievement.dart';

// Comentário: A tela é um ConsumerWidget para podermos usar o 'ref.watch'.
class AchievementListScreen extends ConsumerWidget {
  const AchievementListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Comentário: Escuta o 'achievementsProvider'. O Riverpod trata
    //             automaticamente de buscar os dados e re-desenhar a tela.
    //             Usamos .when() para tratar os 3 estados possíveis.
    final achievementsAsyncValue = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Conquistas'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: achievementsAsyncValue.when(
        // Estado 1: Carregando
        // Comentário: Mostra um indicador de progresso enquanto busca no Supabase.
        loading: () => const Center(child: CircularProgressIndicator()),

        // Estado 2: Erro
        // Comentário: Mostra uma mensagem de erro clara se a busca falhar.
        error: (err, stack) => Center(child: Text('Erro ao buscar conquistas: $err')),

        // Estado 3: Sucesso (Dados recebidos)
        data: (achievements) {
          // Comentário: Verifica se a lista de conquistas está vazia.
          if (achievements.isEmpty) {
            return const Center(
              child: Text('Você ainda não desbloqueou nenhuma conquista.'),
            );
          }

          // Comentário: Usa um ListView.builder para construir a lista de conquistas.
          //             É mais eficiente do que um ListView simples para listas longas.
          return ListView.builder(
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              // Comentário: Usa um widget auxiliar para desenhar cada item da lista.
              return _AchievementListTile(achievement: achievement);
            },
          );
        },
      ),
    );
  }
}

// Comentário: Widget auxiliar para exibir um item da lista de conquistas.
class _AchievementListTile extends StatelessWidget {
  final Achievement achievement;
  const _AchievementListTile({required this.achievement});

// Comentário: Constrói o widget visual para uma conquista.
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          Icons.emoji_events_outlined,
          color: Theme.of(context).colorScheme.secondary,
          size: 32,
        ),
        title: Text(
          achievement.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(achievement.description),
        onTap: () {
          // Comentário: Ação de clique (apenas mostra um SnackBar por enquanto).
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Conquista: ${achievement.title}')),
          );
        },
      ),
    );
  }
}
