// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:skillseeds/features/courses/data/dtos/course_dto.dart';
import 'package:skillseeds/core/widgets/item_actions_dialog.dart';

typedef ProviderEditHandler = Future<void> Function(BuildContext context, CourseDto item);
typedef ProviderRemoveHandler = Future<void> Function(CourseDto item);

/// Diálogo reutilizável com ações para um item (Editar / Remover / Fechar).
///
/// - O diálogo é não-dismissable (barrierDismissible: false).
/// - `onEdit` pode delegar para `showProviderFormDialog` quando disponível.
/// - `onRemove` deve executar a remoção (delegado ao caller/DAO).
Future<void> showProviderActionsDialog(
  BuildContext parentContext, {
  required CourseDto item,
  ProviderEditHandler? onEdit,
  ProviderRemoveHandler? onRemove,
}) async {
  final content = Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text(item.descricao ?? '-'),
    ],
  );

  final actions = <Widget>[
    TextButton(
      onPressed: () async {
        Navigator.of(parentContext).pop(); // close the caller context if needed
        if (onEdit != null) {
          final messenger = ScaffoldMessenger.of(parentContext);
          try {
            await onEdit(parentContext, item);
          } catch (e) {
            messenger.showSnackBar(SnackBar(content: Text('Erro ao abrir edição: $e')));
          }
        }
      },
      child: const Text('Editar'),
    ),
    TextButton(
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: parentContext,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirmar remoção'),
            content: Text('Deseja remover "${item.name}"? Esta ação não pode ser desfeita.'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Remover')),
            ],
          ),
        );

        if (confirm == true) {
          if (onRemove != null) {
            final messenger = ScaffoldMessenger.of(parentContext);
            try {
              await onRemove(item);
              messenger.showSnackBar(const SnackBar(content: Text('Removido com sucesso.')));
            } catch (e) {
              messenger.showSnackBar(SnackBar(content: Text('Erro ao remover: $e')));
            }
          }
        }
      },
      child: const Text('Remover'),
    ),
    TextButton(onPressed: () => Navigator.of(parentContext).pop(), child: const Text('Fechar')),
  ];

  return showItemActionsDialog(parentContext, title: 'Ações', content: content, actions: actions);
}
