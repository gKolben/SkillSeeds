// backup of duplicate CoursesPage from lib/features/models
// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:skillseeds/features/courses/data/local/courses_local_dao.dart';
import 'package:skillseeds/features/courses/data/dtos/course_dto.dart';
import 'dialogs/provider_actions_dialog.dart';
import 'dialogs/course_form_dialog.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final CoursesLocalDaoJson _dao = CoursesLocalDaoJson();
  late Future<List<CourseDto>> _futureCourses;

  @override
  void initState() {
    super.initState();
    _futureCourses = _loadCourses();
  }

  Future<List<CourseDto>> _loadCourses() async {
    try {
      final list = await _dao.listAll(page: 1, pageSize: 20);
      return list;
    } catch (e) {
      rethrow;
    }
  }

  String _formatDuration(int? minutes) {
    if (minutes == null) return '-';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) return '${hours}h ${mins}m';
    return '${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CourseDto>>(
      future: _futureCourses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao carregar cursos: ${snapshot.error}')),
            );
          });
          return Center(
            child: Text('Erro ao carregar cursos.'),
          );
        }
        final courses = snapshot.data ?? [];
        if (courses.isEmpty) {
          return const Center(child: Text('Nenhum curso encontrado.'));
        }

        return SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final c = courses[index];

              return Dismissible(
                key: ValueKey(c.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  final res = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Remover curso'),
                      content: Text('Deseja remover "${c.name}"? Esta ação não pode ser desfeita.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Não')),
                        TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Sim')),
                      ],
                    ),
                  );

                  if (res == true) {
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      await _dao.remove(c.id);
                      messenger.showSnackBar(const SnackBar(content: Text('Curso removido.')));
                      setState(() {
                        _futureCourses = _loadCourses();
                      });
                      return true;
                    } catch (e) {
                      messenger.showSnackBar(SnackBar(content: Text('Erro ao remover: $e')));
                      return false;
                    }
                  }

                  return false;
                },
                child: Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () {},
                      onLongPress: () async {
                        await showProviderActionsDialog(
                          context,
                          item: c,
                          onEdit: (ctx, item) async {
                            await showDialog<void>(
                              context: ctx,
                              barrierDismissible: false,
                              builder: (ctx2) => AlertDialog(
                                title: const Text('Editar (placeholder)'),
                                content: Text('Abrir formulário de edição para: ${item.name}'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.of(ctx2).pop(), child: const Text('Fechar')),
                                ],
                              ),
                            );
                          },
                          onRemove: (item) async {},
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 64,
                              width: double.infinity,
                              child: c.imageUrl != null
                                  ? Image.network(
                                      c.imageUrl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const Center(child: CircularProgressIndicator());
                                      },
                                      errorBuilder: (context, error, stackTrace) => const Center(
                                        child: Icon(Icons.broken_image),
                                      ),
                                    )
                                  : Center(child: Icon(Icons.school, size: 48, color: Theme.of(context).primaryColor)),
                            ),
                            const SizedBox(height: 6),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.name,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c.descricao ?? '-',
                                    style: Theme.of(context).textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              tooltip: 'Editar curso',
                              icon: const Icon(Icons.edit, size: 16),
                              onPressed: () async {
                                await showCourseFormDialog(
                                  context,
                                  initial: c,
                                  onSave: (updated) async {
                                    try {
                                      await _dao.upsert(updated);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Curso atualizado com sucesso.')));
                                      setState(() {
                                        _futureCourses = _loadCourses();
                                      });
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao atualizar: $e')));
                                    }
                                  },
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 16, color: Colors.amber),
                                    const SizedBox(width: 4),
                                    Text(
                                      c.rating != null ? c.rating!.toStringAsFixed(1) : '-',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.schedule, size: 16),
                                    const SizedBox(width: 4),
                                    Text(_formatDuration(c.durationMinutes), style: Theme.of(context).textTheme.bodySmall),
                                  ],
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'info') {
                                      await showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Detalhes do curso'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 8),
                                              Text(c.descricao ?? '-'),
                                              const SizedBox(height: 8),
                                              Text('Duração: ${_formatDuration(c.durationMinutes)}'),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: const Text('Fechar'),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    if (value == 'actions') {
                                      await showProviderActionsDialog(
                                        context,
                                        item: c,
                                        onEdit: (ctx, item) async {
                                          await showDialog<void>(
                                            context: ctx,
                                            barrierDismissible: false,
                                            builder: (ctx2) => AlertDialog(
                                              title: const Text('Editar (placeholder)'),
                                              content: Text('Abrir formulário de edição para: ${item.name}'),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.of(ctx2).pop(), child: const Text('Fechar')),
                                              ],
                                            ),
                                          );
                                        },
                                        onRemove: (item) async {
                                          // Delegar remoção ao caller/DAO; implementado externamente.
                                        },
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(value: 'info', child: Text('Ver detalhes')),
                                    PopupMenuItem(value: 'actions', child: Text('Ações')),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
