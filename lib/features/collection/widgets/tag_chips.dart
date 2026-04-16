import 'package:flutter/material.dart';

/// Wrap mit anklickbaren Tag-Chips zur Mehrfachauswahl.
class TagChips extends StatelessWidget {
  final List<String> options;
  final List<String> selected;
  final ValueChanged<List<String>>? onChanged;
  final bool readOnly;

  const TagChips({
    super.key,
    required this.options,
    required this.selected,
    this.onChanged,
    this.readOnly = false,
  });

  void _toggle(String tag) {
    final next = List<String>.from(selected);
    if (next.contains(tag)) {
      next.remove(tag);
    } else {
      next.add(tag);
    }
    onChanged!(next);
  }

  @override
  Widget build(BuildContext context) {
    final visible = readOnly ? options.where(selected.contains).toList() : options;
    if (visible.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: visible.map((tag) {
        final isSelected = selected.contains(tag);
        return FilterChip(
          label: Text(tag),
          selected: isSelected,
          showCheckmark: false,
          onSelected: readOnly ? null : (_) => _toggle(tag),
        );
      }).toList(),
    );
  }
}
