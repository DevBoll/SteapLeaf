import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steapleaf/screens/widgets/app_bar_stat.dart';
import 'package:steapleaf/screens/widgets/tea_row.dart';
import 'package:steapleaf/theme/steapleaf_theme.dart';

import '../data/models/tea.dart';
import '../provider/tea_provider.dart';
import 'tea_edit_screen.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
final _searchCtrl = TextEditingController();

  void _openEdit(BuildContext context, {Tea? tea}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TeaEditScreen()),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final provider = context.watch<TeaProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final sortedTeas = provider.teas;

    return Scaffold( 
      appBar: AppBar(
        title: Text('蔵 · Teesammlung', style: textTheme.titleLarge),
        actions: [
          AppBarStat(
            icon: Icons.local_drink_outlined,
            count: provider.teas.length,
          ),
          AppBarStat(
            icon: Icons.favorite,
            iconColor: colorScheme.primary,
            count: provider.teas.where((t) => t.isFavorite).length,
          ),
          const SizedBox(width: SteapLeafSpacing.xs),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 0.5,
            color: colorScheme.outlineVariant,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: SteapLeafSpacing.allMd,
                      child: Semantics(
                        label: 'Tee suchen',
                        child: TextField(
                          controller: _searchCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Tee suchen …',
                            prefixIcon: Icon(Icons.search, size: SteapLeafSizes.iconMd),
                          ),
                          onChanged: context.read<TeaProvider>().setSearchQuery,
                        ),
                      ),
                    ),

          // Tee-Liste
                    Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : sortedTeas.isEmpty
                    ? _EmptyState(
                        isEmpty: provider.teas.isEmpty,
                        onAdd: () => _openEdit(context),
                )
                    : ListView.separated(
                      padding: SteapLeafSpacing.listItem,                   
                        itemCount: sortedTeas.length,
                        separatorBuilder: (_, _) => const DashedDivider(),
                        itemBuilder: (_, i) => TeaRow(sortedTeas[i]),
                      ),
                    ),
                  ],
                ),
    );      
  }
  }

class _EmptyState extends StatelessWidget {
  final bool isEmpty;
  final VoidCallback onAdd;
  const _EmptyState({required this.isEmpty, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_drink_outlined,
              size: 64, color: colorScheme.outlineVariant),
          const SizedBox(height: SteapLeafSpacing.md),
          Text(
            isEmpty ? 'Deine Sammlung ist noch leer' : 'Keine Treffer',
            style: textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          if (isEmpty) ...[
            const SizedBox(height: SteapLeafSpacing.lg),
            OutlinedButton(
              onPressed: onAdd,
              child: const Text('Ersten Tee hinzufügen'),
            ),
          ],
        ],
      ),
    );
  }
}
