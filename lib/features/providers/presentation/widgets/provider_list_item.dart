import 'package:flutter/material.dart';
import 'package:skillseeds/features/providers/domain/index.dart' as domain;

class ProviderListItem extends StatelessWidget {
  final domain.Provider item;
  final void Function(domain.Provider)? onEdit;
  final void Function(String)? onRemove;

  const ProviderListItem({super.key, required this.item, this.onEdit, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: item.imageUri != null
          ? ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.network(item.imageUri!, width: 56, height: 56, fit: BoxFit.cover))
          : const CircleAvatar(child: Text('?')),
      title: Text(item.name),
      subtitle: item.distanceKm != null ? Text('${item.distanceKm!.toStringAsFixed(1)} km') : null,
      onTap: () {
        // abrir detalhes (placeholder)
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(title: Text(item.name), content: const Text('Detalhes do provider')),
        );
      },
      trailing: PopupMenuButton<String>(
        onSelected: (v) async {
          if (v == 'edit' && onEdit != null) onEdit!(item);
          if (v == 'remove' && onRemove != null) onRemove!(item.id);
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'edit', child: Text('Editar')),
          PopupMenuItem(value: 'remove', child: Text('Remover'))
        ],
      ),
    );
  }
}
