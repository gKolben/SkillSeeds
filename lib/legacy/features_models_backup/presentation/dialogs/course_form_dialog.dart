import 'package:flutter/material.dart';
import 'package:skillseeds/features/courses/data/dtos/course_dto.dart';

typedef CourseSaveHandler = Future<void> Function(CourseDto updated);

Future<void> showCourseFormDialog(
  BuildContext context, {
  required CourseDto initial,
  required CourseSaveHandler onSave,
}) async {
  final formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController(text: initial.name);
  final descricaoCtrl = TextEditingController(text: initial.descricao ?? '');
  final taxCtrl = TextEditingController(text: initial.taxId ?? '');
  final imageCtrl = TextEditingController(text: initial.imageUrl ?? '');
  final emailCtrl = TextEditingController(text: initial.contact?['email'] ?? '');
  final phoneCtrl = TextEditingController(text: initial.contact?['phone'] ?? '');
  final streetCtrl = TextEditingController(text: initial.address?['street'] ?? '');
  final cityCtrl = TextEditingController(text: initial.address?['city'] ?? '');
  final stateCtrl = TextEditingController(text: initial.address?['state'] ?? '');
  final zipCtrl = TextEditingController(text: initial.address?['zip'] ?? '');
  final durationCtrl = TextEditingController(text: initial.durationMinutes?.toString() ?? '');

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Editar curso'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nome'), validator: (v) => (v == null || v.isEmpty) ? 'Nome é obrigatório' : null),
                TextFormField(controller: descricaoCtrl, decoration: const InputDecoration(labelText: 'Descrição'), maxLines: 3),
                TextFormField(controller: durationCtrl, decoration: const InputDecoration(labelText: 'Duração (minutos)'), keyboardType: TextInputType.number),
                TextFormField(controller: taxCtrl, decoration: const InputDecoration(labelText: 'Tax ID')),
                TextFormField(controller: imageCtrl, decoration: const InputDecoration(labelText: 'URL da imagem')),
                const SizedBox(height: 8),
                const Align(alignment: Alignment.centerLeft, child: Text('Contato', style: TextStyle(fontWeight: FontWeight.bold))),
                TextFormField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'E-mail')),
                TextFormField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Telefone')),
                const SizedBox(height: 8),
                const Align(alignment: Alignment.centerLeft, child: Text('Endereço', style: TextStyle(fontWeight: FontWeight.bold))),
                TextFormField(controller: streetCtrl, decoration: const InputDecoration(labelText: 'Rua')),
                TextFormField(controller: cityCtrl, decoration: const InputDecoration(labelText: 'Cidade')),
                TextFormField(controller: stateCtrl, decoration: const InputDecoration(labelText: 'Estado')),
                TextFormField(controller: zipCtrl, decoration: const InputDecoration(labelText: 'CEP')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final updated = CourseDto(
                id: initial.id,
                name: nameCtrl.text.trim(),
                descricao: descricaoCtrl.text.trim(),
                durationMinutes: durationCtrl.text.isNotEmpty ? int.tryParse(durationCtrl.text) : null,
                taxId: taxCtrl.text.trim().isEmpty ? null : taxCtrl.text.trim(),
                imageUrl: imageCtrl.text.trim().isEmpty ? null : imageCtrl.text.trim(),
                contact: {
                  'email': emailCtrl.text.trim(),
                  'phone': phoneCtrl.text.trim(),
                },
                address: {
                  'street': streetCtrl.text.trim(),
                  'city': cityCtrl.text.trim(),
                  'state': stateCtrl.text.trim(),
                  'zip': zipCtrl.text.trim(),
                },
                rating: initial.rating,
                distanceKm: initial.distanceKm,
                status: initial.status,
                createdAt: initial.createdAt,
                updatedAt: DateTime.now(),
              );

              Navigator.of(ctx).pop();
              final messenger = ScaffoldMessenger.of(context);
              try {
                await onSave(updated);
              } catch (e) {
                messenger.showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      );
    },
  );
}
