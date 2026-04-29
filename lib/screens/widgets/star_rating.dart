import 'package:flutter/material.dart';

import '../../Theme/steapleaf_theme.dart';

/// Interaktive oder reine Anzeige-Sternebewertung.
class StarRating extends StatelessWidget {
  final int rating;
  final int maxRating;
  final double size;
  final ValueChanged<int>? onChanged;

  const StarRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = SteapLeafSizes.iconMd,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (i) {
        final filled = i < rating;
        final icon = filled ? Icons.star : Icons.star_border;
        final color = filled ? colorScheme.primary : colorScheme.outlineVariant;

        if (onChanged != null) {
          return IconButton(
            icon: Icon(icon, size: size, color: color),
            tooltip: '${i + 1} Stern${i == 0 ? '' : 'e'}',
            onPressed: () => onChanged!(i + 1 == rating ? 0 : i + 1),
          );
        }

        return Semantics(
          label: 'Bewertung: $rating von $maxRating Sternen',
          excludeSemantics: true,
          child: Icon(icon, size: size, color: color),
        );
      }),
    );
  }
}
