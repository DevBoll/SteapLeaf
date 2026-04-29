import 'package:flutter/material.dart';

import '../../theme/steapleaf_theme.dart';

class AppBarStat extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final int count;

  const AppBarStat({super.key, 
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
      padding: const EdgeInsets.symmetric(horizontal: SteapLeafSpacing.sm),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: SteapLeafSizes.iconSm, color: color),
          const SizedBox(width: SteapLeafSpacing.xs),
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
