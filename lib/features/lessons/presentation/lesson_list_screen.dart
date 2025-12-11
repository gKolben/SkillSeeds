import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillseeds/core/models/track.dart';
import 'package:skillseeds/core/providers/providers.dart';
import 'package:skillseeds/features/lessons/domain/index.dart';

// Comentário: Esta tela é um ConsumerWidget, o que nos permite "escutar" os providers.
class LessonListScreen extends ConsumerWidget {
  const LessonListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Comentário: Pega o objeto 'Track' que foi passado como argumento
    //             quando navegamos para esta tela (vindo da HomeScreen).
    final track = ModalRoute.of(context)!.settings.arguments as Track;

    // Comentário: Escuta o provider 'lessonsForTrackProvider'.
    //             Passamos o 'track.id' para que ele saiba quais lições buscar.
    //             Isso é um FutureProvider, então usamos .when() para tratar os estados.
    final lessonsAsyncValue = ref.watch(lessonsForTrackProvider(track.id));

    return Scaffold(
      appBar: AppBar(
        // Comentário: Mostra o nome da trilha (ex: "Design") como título.
        title: Text(track.name),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(lessonsForTrackProvider(track.id).future),
        child: lessonsAsyncValue.when(
          // Estado 1: Carregando
          // Comentário: Mostra um indicador de progresso enquanto busca no Supabase.
          loading: () => const Center(child: CircularProgressIndicator()),

          // Estado 2: Erro
          // Comentário: Mostra uma mensagem de erro se a busca falhar.
          error: (err, stack) => Center(child: Text('Erro: $err')),

          // Estado 3: Sucesso (Dados recebidos)
          // Comentário: Recebe a lista de 'lessons' (lições) e constrói a tela.
          data: (lessons) {
            if (lessons.isEmpty) {
              return const Center(
                  child: Text('Nenhuma lição encontrada para esta trilha.'));
            }

            // Comentário: Usa um ListView.builder para construir a lista de lições.
            return ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return LessonListTile(lesson: lesson);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLessonDialog(context, ref, track),
        tooltip: 'Adicionar Lição',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddLessonDialog(
    BuildContext context,
    WidgetRef ref,
    Track track,
  ) async {
    final titleController = TextEditingController();
    LessonType selectedType = LessonType.reading;
    bool isLoading = false;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Adicionar Lição'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título da Lição',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButton<LessonType>(
                  value: selectedType,
                  isExpanded: true,
                  items: LessonType.values
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(_getLessonTypeName(type)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedType = value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              child: const Text('Cancelar'),
            ),
            OutlinedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final title = titleController.text.trim();
                      if (title.isEmpty) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Título é obrigatório')),
                        );
                        return;
                      }

                      setState(() => isLoading = true);

                      try {
                        final repo = ref.read(lessonRepositoryProvider);
                        final newLesson = Lesson(
                          id: 0, // Supabase vai gerar automaticamente
                          trackId: track.id,
                          title: title,
                          lessonType: selectedType,
                          createdAt: DateTime.now(),
                        );

                        await repo.createLesson(newLesson);

                        if (!context.mounted) return;
                        Navigator.of(context).pop();

                        // Refresh the provider to fetch updated data
                        // ignore: unused_result
                        ref.refresh(lessonsForTrackProvider(track.id));

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Lição adicionada com sucesso')),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao adicionar: $e')),
                        );
                      }
                    },
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }

  String _getLessonTypeName(LessonType type) {
    switch (type) {
      case LessonType.reading:
        return 'Leitura';
      case LessonType.video:
        return 'Vídeo';
      case LessonType.quiz:
        return 'Quiz';
    }
  }
}

// Comentário: Widget auxiliar para exibir um item da lista de lições.
class LessonListTile extends ConsumerWidget {
  final Lesson lesson;
  const LessonListTile({super.key, required this.lesson});

  // Comentário: Função auxiliar para retornar o ícone correto baseado no tipo da lição.
  IconData _getIconForLessonType(LessonType type) {
    switch (type) {
      case LessonType.video:
        return Icons.play_circle_outline;
      case LessonType.quiz:
        return Icons.quiz_outlined;
      case LessonType.reading:
      return Icons.article_outlined;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          _getIconForLessonType(lesson.lessonType),
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          lesson.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () => _showEditLessonDialog(context, ref),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () => _showDeleteConfirmDialog(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditLessonDialog(BuildContext context, WidgetRef ref) async {
    final TextEditingController controller = TextEditingController(text: lesson.title);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Lição'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Título'),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
            child: const Text('Cancelar'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (!context.mounted) return;

    if (result == true) {
      final newTitle = controller.text.trim();
      if (newTitle.isEmpty) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Título vazio')));
        return;
      }

      final repo = ref.read(lessonRepositoryProvider);
      final updated = Lesson(
        id: lesson.id,
        trackId: lesson.trackId,
        title: newTitle,
        lessonType: lesson.lessonType,
        createdAt: lesson.createdAt,
      );

      try {
        await repo.updateLesson(updated);
        if (!context.mounted) return;
        // ignore: unused_result
        ref.refresh(lessonsForTrackProvider(lesson.trackId));
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lição atualizada')));
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao atualizar: $e')));
      }
    }
  }

  Future<void> _showDeleteConfirmDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Lição'),
        content: Text('Tem certeza que deseja remover a lição "${lesson.title}"?'),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
            child: const Text('Cancelar'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (!context.mounted) return;

    if (result == true) {
      final repo = ref.read(lessonRepositoryProvider);
      try {
        final success = await repo.removeLesson(lesson.id);
        if (!context.mounted) return;

        if (success) {
          // ignore: unused_result
          ref.refresh(lessonsForTrackProvider(lesson.trackId));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lição removida')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao remover lição')));
        }
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao remover: $e')));
      }
    }
  }
}
