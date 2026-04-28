import 'package:flutter/material.dart';

/// Fixe Aktionsleiste am unteren Bildschirmrand.
class ActionBar extends StatelessWidget {
  final List<Widget> children;

  const ActionBar({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(child: children[i]),
            ],
          ],
        ),
      ),
    );
  }
}

/// Vorgefertigte Button-Varianten für die [ActionBar].
class ActionBarButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool _isPrimary;

  const ActionBarButton._({
    required this.label,
    required this.onPressed,
    required bool isPrimary,
  }) : _isPrimary = isPrimary;

  /// Sekundärer Button (z. B. Abbrechen) — dezent, kein Akzent.
  factory ActionBarButton.secondary({
    required String label,
    required VoidCallback? onPressed,
  }) => ActionBarButton._(
        label: label,
        onPressed: onPressed,
        isPrimary: false,
      );

  /// Primärer Button (z. B. Speichern) — Primary-Akzent.
  factory ActionBarButton.primary({
    required String label,
    required VoidCallback? onPressed,
  }) => ActionBarButton._(
        label: label,
        onPressed: onPressed,
        isPrimary: true,
      );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = _isPrimary ? colorScheme.primary : colorScheme.outline;
    final foregroundColor =
        _isPrimary ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor, width: 0.5),
        foregroundColor: foregroundColor,
        shape: const RoundedRectangleBorder(),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }
}
