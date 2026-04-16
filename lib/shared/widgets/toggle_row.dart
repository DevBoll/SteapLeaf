import 'package:flutter/material.dart';

/// Tippbare Zeile mit Checkbox-Icon und Label.
class ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final IconData? activeIcon;
  final Color? activeColor;

  const ToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon,
    this.activeIcon,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final resolvedActiveColor = activeColor ?? colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(
                value
                    ? (activeIcon ?? Icons.check_box)
                    : (icon ?? Icons.check_box_outline_blank),
                size: 20,
                color: value ? resolvedActiveColor : colorScheme.outlineVariant,
              ),
              const SizedBox(width: 8),
              Text(label, style: textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
