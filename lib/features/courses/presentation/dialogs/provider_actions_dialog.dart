// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:skillseeds/core/config/app_theme.dart';
import '../../data/dtos/course_dto.dart';

typedef ProviderEditHandler = Future<void> Function(BuildContext context, CourseDto item);
typedef ProviderRemoveHandler = Future<void> Function(CourseDto item);

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
          OutlinedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              if (onEdit != null) {
                final messenger = ScaffoldMessenger.of(parentContext);
                try {
                  await onEdit(parentContext, item);
                } catch (e) {
                  messenger.showSnackBar(SnackBar(content: Text('Erro ao abrir edição: $e')));
                }
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: BorderSide(color: AppTheme.primaryColor),
            ),
            child: const Text('Editar'),
          ),
          OutlinedButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: dialogContext,
                barrierDismissible: false,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirmar remoção'),
                  content: Text('Deseja remover "${item.name}"? Esta ação não pode ser desfeita.'),
                  actions: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: BorderSide(color: AppTheme.primaryColor),
                      ),
                      child: const Text('Cancelar'),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: BorderSide(color: AppTheme.primaryColor),
                      ),
                      child: const Text('Remover'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                Navigator.of(dialogContext).pop();
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
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: BorderSide(color: AppTheme.primaryColor),
            ),
            child: const Text('Remover'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: BorderSide(color: AppTheme.primaryColor),
            ),
            child: const Text('Fechar'),
          ),
        ],
      );
    },
  );
}
