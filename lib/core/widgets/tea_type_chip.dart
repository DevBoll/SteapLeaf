import 'package:flutter/material.dart';
import 'package:steapleaf/core/models/enums.dart';

class TeaTypeChip extends StatelessWidget {
  final TeaType type;

  const TeaTypeChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Chip(
      label: Text(type.label),
      side: BorderSide(
        color: type.colors.badge.withValues(alpha: 0.7),
        width: 0.8,
      ),
      backgroundColor: Colors.transparent,
      labelStyle: textTheme.labelSmall?.copyWith(
        color: type.colors.badge,
        letterSpacing: 0.3,
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
