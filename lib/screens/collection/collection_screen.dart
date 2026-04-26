import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steapleaf/theme/steapleaf_theme.dart';

import '../../core/models/enums.dart';
import '../../core/models/tea.dart';
import '../../core/providers/tea_provider.dart';
import '../../core/widgets/star_rating.dart';
import 'tea_detail_screen.dart';
import 'tea_edit_screen.dart';
import '../../core/widgets/tea_thumb.dart';
import '../../core/widgets/tea_type_chip.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
final _searchCtrl = TextEditingController();

  String get _sortLabel => context.read<TeaProvider>().sortOrder.label;

  void _cycleSort() {
    final provider = context.read<TeaProvider>();
    final values = TeaSortOrder.values;
    final next = values[(provider.sortOrder.index + 1) % values.length];
    provider.setSortOrder(next);
  }

  void _openEdit(BuildContext context, {Tea? tea}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TeaEditScreen(tea: tea)),
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
          _AppBarStat(
            icon: Icons.local_drink_outlined,
            count: provider.teas.length,
          ),
          _AppBarStat(
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
                      padding: const EdgeInsets.fromLTRB(
                          SteapLeafSpacing.md, SteapLeafSpacing.sm,
                          SteapLeafSpacing.md, SteapLeafSpacing.xs,
                        ),
                      child: Semantics(
                        label: 'Tee suchen',
                        child: TextField(
                          controller: _searchCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Tee suchen …',
                            prefixIcon: Icon(Icons.search, size: 20),
                          ),
                          onChanged: context.read<TeaProvider>().setSearch,
                        ),
                      ),
                    ),
                    _SortRow(
                      provider: provider,
                      sortLabel: _sortLabel,
                      onCycleSort: _cycleSort,
                    ),

          // Tee-Liste
                    Expanded(
            child: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : sortedTeas.isEmpty
                    ? _EmptyState(
                        isEmpty: provider.teas.isEmpty,
                        onAdd: () => _openEdit(context),
                )
                    : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                          SteapLeafSpacing.md, SteapLeafSpacing.tiny,
                          SteapLeafSpacing.md,
                          SteapLeafSpacing.xxl + SteapLeafSpacing.fabSize,
                        ),
                        itemCount: sortedTeas.length,
                        separatorBuilder: (_, _) => const DashedDivider(),
                        itemBuilder: (_, i) => _TeaRow(sortedTeas[i]),
                      ),
                    ),
                  ],
                ),
    );      
  }
  }

class _SortRow extends StatelessWidget {
  final TeaProvider provider;
  final String sortLabel;
  final VoidCallback onCycleSort;

  const _SortRow({
    required this.provider,
    required this.sortLabel,
    required this.onCycleSort,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final stockActive = provider.filterInStock == true;
    final favActive = provider.filterFavorites;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SteapLeafSpacing.md),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: onCycleSort,
            icon: const Icon(Icons.arrow_downward, size: 11),
            label: Text(sortLabel),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
              textStyle: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const Spacer(),
          _TypeFilterDropdown(provider: provider),
          const SizedBox(width: SteapLeafSpacing.tiny),
          FilterChip(
            label: const Text('♥ Favoriten'),
            selected: favActive,
            showCheckmark: false,
            onSelected: (_) => provider.setFilterFavorites(!favActive),
          ),
          const SizedBox(width: SteapLeafSpacing.tiny),
          FilterChip(
            label: const Text('Im Besitz'),
            selected: stockActive,
            showCheckmark: false,
            onSelected: (_) =>
                provider.setFilterInStock(stockActive ? null : true),
          ),
        ],
      ),
    );
  }
}
  
class _TypeFilterDropdown extends StatelessWidget {
  final TeaProvider provider;
  const _TypeFilterDropdown({required this.provider});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme   = Theme.of(context).textTheme;
    final selected    = provider.filterType;
    final isActive    = selected != null;

    final availableTypes = TeaType.values
        .where((t) => provider.teas.any((tea) => tea.type == t))
        .toList();

    return PopupMenuButton<TeaType?>(
      initialValue: selected,
      onSelected: (type) => provider.setFilterType(
        provider.filterType == type ? null : type,
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: null,
          onTap: () => provider.setFilterType(null),
          child: Text(
            'Alle Sorten',
            style: textTheme.bodySmall?.copyWith(
              color: selected == null
                  ? colorScheme.primary
                  : colorScheme.onSurface,
            ),
          ),
        ),
        ...availableTypes.map((t) => PopupMenuItem(
              value: t,
              child: Text(
                t.label,
                style: textTheme.bodySmall?.copyWith(
                  color: selected == t ? t.color : colorScheme.onSurface,
                ),
              ),
            )),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? selected.color.withValues(alpha: 0.15)
              : colorScheme.surfaceContainerHigh,
          border: Border.all(
            color: isActive ? selected.color : colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isActive ? selected.label : 'Sorte',
              style: textTheme.labelMedium?.copyWith(
                color: isActive ? selected.color : colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: isActive ? selected.color : colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBarStat extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final int count;

  const _AppBarStat({
    required this.icon,
    required this.count,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = iconColor ?? colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 3),
          Text(
            '$count',
            style: textTheme.bodySmall
                ?.copyWith(color: colorScheme.onSurfaceVariant),
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

class _TeaRow extends StatelessWidget {
  final Tea tea;
  const _TeaRow(this.tea);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TeaDetailScreen(tea: tea, teaId: tea.id,)),
      ),
      child: Opacity(
        opacity: tea.isOwned ? 1.0 : 0.55,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TeaThumb(tea: tea, size: 60),
              const SizedBox(width: SteapLeafSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(tea.name, style: textTheme.titleMedium),
                    const SizedBox(height: SteapLeafSpacing.tiny),
                    Row(
                      children: [
                        TeaTypeChip(type: tea.type),
                        if (tea.origin?.isNotEmpty ?? false) ...[
                          const SizedBox(width: SteapLeafSpacing.tiny),
                          Expanded(
                            child: Text(
                              tea.origin ?? '',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                letterSpacing: 1.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tea.rating > 0)
                    StarRating(rating: tea.rating, size: 14)
                  else
                    const SizedBox(height: 14),
                  const SizedBox(height: SteapLeafSpacing.tiny),
                  Icon(
                    tea.isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 14,
                    color: tea.isFavorite
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}