import 'package:flutter/material.dart';
import 'package:skillseeds/core/models/provider_model.dart' as domain;

Future<void> showProviderDetailsDialog(BuildContext context, domain.Provider item) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(item.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.imageUri != null) Image.network(item.imageUri!),
          const SizedBox(height: 8),
          Text('ID: ${item.id}'),
          if (item.distanceKm != null) Text('Distance: ${item.distanceKm} km'),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Fechar')),
      ],
    ),
  );
}
