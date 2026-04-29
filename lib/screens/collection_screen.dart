import 'package:flutter/material.dart';
import '../theme/steapleaf_theme.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text('Sammlung', style: SteapLeafTextTheme.headlineMedium),
          ),
          SliverPadding(
            padding: SteapLeafSpacing.screenPadding,
            sliver: SliverList.list(
              children: [
                // Suchleiste Platzhalter
                Container(
                  height: SteapLeafSizes.inputHeight,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colors.outline,
                      width: 0.5,
                    ),
                    color: colors.surfaceContainerLow,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: SteapLeafSpacing.lg,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tee suchen …',
                    style: SteapLeafTextTheme.bodyMedium.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: SteapLeafSpacing.lg),
                KanjiLabel(
                  kanji: SteapLeafKanji.collection,
                  label: 'ALLE TEES',
                ),
                const SizedBox(height: SteapLeafSpacing.sm),
                ...List.generate(
                  4,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: SteapLeafSpacing.sm),
                    child: WashiCard(
                      child: Row(
                        children: [
                          Container(
                            width: SteapLeafSizes.avatarMd,
                            height: SteapLeafSizes.avatarMd,
                            color: colors.surfaceContainerHighest,
                          ),
                          const SizedBox(width: SteapLeafSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 14,
                                  width: double.infinity,
                                  color: colors.surfaceContainerHighest,
                                ),
                                const SizedBox(height: SteapLeafSpacing.xs),
                                Container(
                                  height: 10,
                                  width: 80,
                                  color: colors.surfaceContainerHighest,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
