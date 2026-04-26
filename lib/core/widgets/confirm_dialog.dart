import 'package:flutter/material.dart';

/// Generischer Bestätigungs-Dialog zum Verwerfen von Änderungen.
///
/// Gibt [true] zurück wenn der Nutzer das Verwerfen bestätigt,
/// [false] wenn er weiter bearbeiten möchte.
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Verwerfen',
    this.cancelLabel = 'Weiter bearbeiten',
  });

  /// Öffnet den Dialog und gibt das Ergebnis zurück.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Verwerfen',
    String cancelLabel = 'Weiter bearbeiten',
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => ConfirmDialog(
            title: title,
            message: message,
            confirmLabel: confirmLabel,
            cancelLabel: cancelLabel,
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text(title, style: textTheme.titleLarge),
      content: Text(
        message,
        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelLabel),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context, true),
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.error,
            side: BorderSide(color: colorScheme.error, width: 0.5),
          ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
