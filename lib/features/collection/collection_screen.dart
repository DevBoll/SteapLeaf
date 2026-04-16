import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/enums/enums.dart';
import '../../domain/models/tea.dart';
import 'tea_provider.dart';
import '../../theme/steapleaf_theme.dart';
import 'tea_edit_screen.dart';
import '../../shared/widgets/tea_thumb.dart';
import '../../shared/widgets/tea_type_chip.dart';
import '../../shared/widgets/star_rating.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

enum _SortMode { rating, name, type }

class _CollectionScreenState extends State<CollectionScreen> {
  final _searchCtrl = TextEditingController();
  _SortMode _sort = _SortMode.rating;

  void _cycleSort() {
    setState(() {
      _sort = _SortMode.values[(_sort.index + 1) % _SortMode.values.length];
    });
  }

  List<Tea> _sorted(List<Tea> teas) {
    final list = List<Tea>.from(teas);
    switch (_sort) {
      case _SortMode.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case _SortMode.name:
        list.sort((a, b) => a.name.compareTo(b.name));
      case _SortMode.type:
        list.sort((a, b) => a.type.index.compareTo(b.type.index));
    }
    return list;
  }

  String get _sortLabel => switch (_sort) {
        _SortMode.rating => 'nach Bewertung',
        _SortMode.name   => 'nach Name',
        _SortMode.type   => 'nach Sorte',
      };

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
    final sortedTeas = _sorted(provider.filteredTeas);

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
          const SizedBox(width: 8),
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
          // Suche
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
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

          // Filter-Chips
          _FilterRow(provider: provider),
          const SizedBox(height: 6),

          // Sort + Schnellfilter
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
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                        itemCount: sortedTeas.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          thickness: 0.5,
                          color: colorScheme.outlineVariant,
                        ),
                        itemBuilder: (_, i) => _TeaRow(sortedTeas[i]),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tee hinzufügen',
        onPressed: () => _openEdit(context),
        child: Text(
          SteapLeafKanji.newItem.character,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  void _openEdit(BuildContext context, {Tea? tea}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TeaEditScreen(tea: tea)),
    );
  }
}

// Filter-Chips

class _FilterRow extends StatelessWidget {
  final TeaProvider provider;
  const _FilterRow({required this.provider});

  bool get _noFilter =>
      provider.filterType == null &&
      !provider.filterFavorites &&
      provider.filterInStock == null;

  int _countFor(TeaType t) =>
      provider.teas.where((tea) => tea.type == t).length;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          FilterChip(
            label: Text('Alle ${provider.teas.length}'),
            selected: _noFilter,
            showCheckmark: false,
            onSelected: (_) => provider.clearFilters(),
          ),
          ...TeaType.values.map((t) {
            final count = _countFor(t);
            if (count == 0) return const SizedBox.shrink();
            final isSelected = provider.filterType == t;
            return FilterChip(
              label: Text('${t.label} $count'),
              selected: isSelected,
              showCheckmark: false,
              selectedColor: t.color.withValues(alpha: 0.2),
              side: BorderSide(
                color: isSelected ? t.color : colorScheme.outlineVariant,
                width: isSelected ? 1.0 : 0.5,
              ),
              onSelected: (_) => provider.setFilterType(
                provider.filterType == t ? null : t,
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Sort + Schnellfilter

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
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
          FilterChip(
            label: const Text('♥ Favoriten'),
            selected: favActive,
            showCheckmark: false,
            onSelected: (_) => provider.setFilterFavorites(!favActive),
          ),
          const SizedBox(width: 4),
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

// Tea-Zeile

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
        MaterialPageRoute(builder: (_) => TeaEditScreen(tea: tea)),
      ),
      child: Opacity(
        opacity: tea.inStock ? 1.0 : 0.55,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TeaThumb(tea: tea, size: 60),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(tea.name, style: textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        TeaTypeChip(type: tea.type),
                        if (tea.origin?.isNotEmpty ?? false) ...[
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              tea.origin!.toUpperCase(),
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
                  const SizedBox(height: 4),
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

// Empty State

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
          const SizedBox(height: 16),
          Text(
            isEmpty ? 'Deine Sammlung ist noch leer' : 'Keine Treffer',
            style: textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          if (isEmpty) ...[
            const SizedBox(height: 20),
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

// AppBar-Stat

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
