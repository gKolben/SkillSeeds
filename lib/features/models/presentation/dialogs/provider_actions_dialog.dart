// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../data/dtos/course_dto.dart';

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
  return showDialog<void>(
    context: parentContext,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Ações'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(item.descricao ?? '-'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Editar: delega para onEdit se fornecido
              Navigator.of(dialogContext).pop(); // fecha o diálogo de ações antes de abrir o form
              if (onEdit != null) {
                final messenger = ScaffoldMessenger.of(parentContext);
                try {
                  await onEdit(parentContext, item);
                } catch (e) {
                  // Mostrar erro simples usando messenger capturado
                  messenger.showSnackBar(SnackBar(content: Text('Erro ao abrir edição: $e')));
                }
              }
            },
            child: const Text('Editar'),
          ),
          TextButton(
            onPressed: () async {
              // Remover: abrir confirmação de remoção
              final confirm = await showDialog<bool>(
                context: dialogContext,
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
                Navigator.of(dialogContext).pop(); // fecha o diálogo de ações
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
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Fechar'),
          ),
        ],
      );
    },
  );
}
