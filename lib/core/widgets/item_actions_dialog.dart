import 'package:flutter/material.dart';

/// Mostra um AlertDialog genérico com título, conteúdo e ações fornecidas.
///
/// - `parentContext` é utilizado para retornar SnackBars ou referências ao Scaffold
/// - `content` é o corpo do diálogo (normalmente Column com detalhes do item)
/// - `actions` são os botões já prontos (Widgets) que serão renderizados na área de ações
Future<void> showItemActionsDialog(
  BuildContext parentContext, {
  required String title,
  required Widget content,
  required List<Widget> actions,
}) async {
  return showDialog<void>(
    context: parentContext,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: content,
        actions: actions,
      );
    },
  );
}
