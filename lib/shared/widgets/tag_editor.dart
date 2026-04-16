import 'package:flutter/material.dart';

/// Freie Tag-Eingabe mit Chip-Anzeige und Löschen-Funktion.
class TagEditor extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;

  const TagEditor({
    super.key,
    required this.tags,
    required this.onChanged,
  });

  @override
  State<TagEditor> createState() => _TagEditorState();
}

class _TagEditorState extends State<TagEditor> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final tag = value.trim();
    if (tag.isNotEmpty && tag.length <= 30 && !widget.tags.contains(tag)) {
      widget.onChanged([...widget.tags, tag]);
    }
    _controller.clear();
  }

  void _remove(String tag) {
    widget.onChanged(widget.tags.where((t) => t != tag).toList());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...widget.tags.map((tag) => InputChip(
              label: Text(tag, style: textTheme.bodySmall),
              onDeleted: () => _remove(tag),
              deleteIconColor: colorScheme.outlineVariant,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
              shape: const RoundedRectangleBorder(),
            )),
        IntrinsicWidth(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Tag hinzufügen …'),
            style: textTheme.bodySmall,
            textInputAction: TextInputAction.done,
            onSubmitted: _submit,
          ),
        ),
      ],
    );
  }
}
