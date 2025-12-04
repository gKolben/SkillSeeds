import 'package:flutter/material.dart';
import 'package:skillseeds/core/models/provider_model.dart' as domain;

/// Abre um diálogo com formulário para criar/editar um Provider.
/// Retorna o Provider criado/atualizado via Navigator.pop(context, provider)
Future<domain.Provider?> showProviderFormDialog(BuildContext context, {domain.Provider? initial}) {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController(text: initial?.name ?? '');
  final imageCtrl = TextEditingController(text: initial?.imageUri ?? '');
  final distanceCtrl = TextEditingController(text: initial?.distanceKm?.toString() ?? '');

  return showDialog<domain.Provider>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text(initial == null ? 'Criar Provider' : 'Editar Provider'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Nome obrigatório' : null,
            ),
            TextFormField(controller: imageCtrl, decoration: const InputDecoration(labelText: 'Image URL')),
            TextFormField(controller: distanceCtrl, decoration: const InputDecoration(labelText: 'Distance (km)'), keyboardType: TextInputType.number),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text('Cancelar')),
            ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final id = initial?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
              final distance = double.tryParse(distanceCtrl.text);
              final provider = domain.Provider(id: id, name: nameCtrl.text.trim(), imageUri: imageCtrl.text.trim().isEmpty ? null : imageCtrl.text.trim(), distanceKm: distance);
              Navigator.of(ctx).pop(provider);
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    ),
  );
}
 
