import 'package:flutter/material.dart';
import 'package:steapleaf/data/models/tea.dart';
import 'package:steapleaf/screens/tea_detail_screen.dart';
import 'package:steapleaf/theme/steapleaf_theme.dart';

import 'star_rating.dart';
import 'tea_thumb.dart';
import 'tea_type_chip.dart';

class TeaRow extends StatelessWidget {
  final Tea tea;
  const TeaRow(this.tea, {super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TeaDetailScreen(teaId: tea.id)),
      ),
      child: Opacity(
        opacity: tea.isOwned ? 1.0 : 0.55,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TeaThumb(tea: tea, size: 60),
              const SizedBox(width: SteapLeafSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(tea.name, style: textTheme.titleMedium),
                    const SizedBox(height: SteapLeafSpacing.xs),
                    Row(
                      children: [
                        if (tea.type != null) TeaTypeChip(type: tea.type!),
                        if (tea.origin!.isNotEmpty) ...[
                          const SizedBox(width: SteapLeafSpacing.xs),
                          Expanded(
                            child: Text(
                              tea.origin!,
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
                  if ((tea.rating ?? 0) > 0)
                    StarRating(rating: tea.rating!.round(), size: 14)
                  else
                    const SizedBox(height: 14),
                  const SizedBox(height: SteapLeafSpacing.xxs),
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