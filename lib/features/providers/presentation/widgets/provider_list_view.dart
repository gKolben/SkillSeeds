import 'package:flutter/material.dart';
import 'package:skillseeds/features/providers/domain/index.dart' as domain;
import 'provider_list_item.dart';

class ProviderListView extends StatelessWidget {
  final List<domain.Provider> items;
  final void Function(domain.Provider)? onEdit;
  final void Function(String)? onRemove;

  const ProviderListView({super.key, required this.items, this.onEdit, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) => ProviderListItem(item: items[index], onEdit: onEdit, onRemove: onRemove),
    );
  }
}
