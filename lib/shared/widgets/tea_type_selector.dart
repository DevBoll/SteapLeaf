import 'package:flutter/material.dart';
import '../../domain/enums/enums.dart';

class TeaTypeSelector extends StatelessWidget {
  final TeaType selected;
  final ValueChanged<TeaType> onChanged;

  const TeaTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: TeaType.values.map((t) {
        final active = t == selected;

        return ChoiceChip(
          label: Text(t.label),
          selected: active,
          showCheckmark: false,
          selectedColor: t.colors.container,
          side: BorderSide(
            color: active ? t.colors.badge : colorScheme.outlineVariant,
            width: active ? 1.0 : 0.5,
          ),
          labelStyle: textTheme.bodySmall?.copyWith(
            color: active ? t.colors.onContainer : colorScheme.onSurfaceVariant,
          ),
          onSelected: (_) => onChanged(t),
        );
      }).toList(),
    );
  }
}
