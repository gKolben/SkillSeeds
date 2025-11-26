// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../data/local/courses_local_dao.dart';
import '../data/dtos/course_dto.dart';

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
      // Carregamento inicial: primeira página com valores padrão
      final list = await _dao.listAll(page: 1, pageSize: 20);
      return list;
    } catch (e) {
      // rethrow para ser tratado no widget build
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

  // ignore: unused_element
  String _maskTaxId(String? taxId) {
    if (taxId == null || taxId.isEmpty) return '';
    // Ex: "12.345.678/0001-23" -> "12.345.*** / 0001-23"
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

  // ignore: unused_element
  String _maskPhone(String? phone) {
    if (phone == null || phone.isEmpty) return '';
    // simples: oculta parte central
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 8) {
      final start = digits.substring(0, 4);
      final end = digits.substring(digits.length - 4);
      return '$start****$end';
    }
    return phone;
  }

  // ignore: unused_element
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
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final c = courses[index];
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () {
                      // ação futura: abrir detalhes
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // imagem
                          if (c.imageUrl != null)
                            SizedBox(
                              height: 90,
                              width: double.infinity,
                              child: Image.network(
                                c.imageUrl!,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) => const Center(
                                  child: Icon(Icons.broken_image),
                                ),
                              ),
                            )
                          else
                            SizedBox(
                              height: 90,
                              child: Center(child: Icon(Icons.school, size: 48, color: Theme.of(context).primaryColor)),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            c.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            c.descricao ?? '-',
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
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
                                  // ações futuras (editar, compartilhar)
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
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(value: 'info', child: Text('Ver detalhes')),
                                ],
                              )
                            ],
                          )
                        ],
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
