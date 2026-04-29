import 'package:flutter/material.dart';
import '../theme/steapleaf_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text('Heim', style: SteapLeafTextTheme.headlineMedium),
          ),
          SliverPadding(
            padding: SteapLeafSpacing.screenPadding,
            sliver: SliverList.list(
              children: [
                WashiCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KanjiLabel(
                        kanji: SteapLeafKanji.sessionStart,
                        label: 'AKTIVE SESSION',
                      ),
                      const SizedBox(height: SteapLeafSpacing.sm),
                      _PlaceholderBlock(color: colors.surfaceContainerHighest),
                    ],
                  ),
                ),
                const SizedBox(height: SteapLeafSpacing.md),
                WashiCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KanjiLabel(
                        kanji: SteapLeafKanji.history,
                        label: 'LETZTE SESSION',
                      ),
                      const SizedBox(height: SteapLeafSpacing.sm),
                      _PlaceholderBlock(color: colors.surfaceContainerHighest),
                    ],
                  ),
                ),
                const SizedBox(height: SteapLeafSpacing.md),
                WashiCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KanjiLabel(
                        kanji: SteapLeafKanji.overview,
                        label: 'HEUTE',
                      ),
                      const SizedBox(height: SteapLeafSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: _PlaceholderBlock(
                              color: colors.surfaceContainerHighest,
                              height: 56,
                            ),
                          ),
                          const SizedBox(width: SteapLeafSpacing.sm),
                          Expanded(
                            child: _PlaceholderBlock(
                              color: colors.surfaceContainerHighest,
                              height: 56,
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _PlaceholderBlock extends StatelessWidget {
  const _PlaceholderBlock({required this.color, this.height = 32});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      );
}
