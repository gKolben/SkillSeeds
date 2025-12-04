// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:skillseeds/core/config/app_theme.dart';
import '../data/local/courses_local_dao.dart';
import '../data/dtos/course_dto.dart';
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

  String _maskTaxId(String? taxId) {
    if (taxId == null || taxId.isEmpty) return '';
    try {
      final parts = taxId.split('/');
      if (parts.length == 2) {
        final left = parts[0];
        final right = parts[1];
        final maskedLeft = left.length > 7 ? '${left.substring(0, 7)}***' : left;
        return '$maskedLeft / $right';
      }
    } catch (_) {}
    return taxId;
  }

  String _maskPhone(String? phone) {
    if (phone == null || phone.isEmpty) return '';
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 8) {
      final start = digits.substring(0, 4);
      final end = digits.substring(digits.length - 4);
      return '$start****$end';
    }
    return phone;
  }

  Future<void> _refresh() async {
    setState(() {
      _futureCourses = _loadCourses();
    });
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
                        OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                            side: BorderSide(color: AppTheme.primaryColor),
                          ),
                          child: const Text('Não'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                          child: const Text('Sim'),
                        ),
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
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        c.imageUrl!,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const Center(child: CircularProgressIndicator());
                                        },
                                        errorBuilder: (context, error, stackTrace) => Center(
                                          child: Icon(Icons.broken_image, color: AppTheme.primaryColor),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: CircleAvatar(
                                        radius: 28,
                                        backgroundColor: AppTheme.primaryColor.withAlpha(26),
                                        child: Icon(Icons.school, size: 28, color: AppTheme.primaryColor),
                                      ),
                                    ),
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
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).textTheme.titleMedium?.color ?? Color.fromRGBO(255, 255, 255, 0.92),
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c.descricao ?? '-',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).textTheme.bodySmall?.color ?? Color.fromRGBO(255, 255, 255, 0.92),
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            // Edit button styled with project purple color
                            InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () async {
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
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: AppTheme.primaryColor,
                                child: const Icon(Icons.edit, size: 16, color: Colors.white),
                              ),
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
                                          title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, color: null)),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(c.descricao ?? '-'),
                                              const SizedBox(height: 8),
                                              Text('Duração: ${_formatDuration(c.durationMinutes)}'),
                                            ],
                                          ),
                                          actions: [
                                            OutlinedButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: AppTheme.primaryColor,
                                                side: BorderSide(color: AppTheme.primaryColor),
                                              ),
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
