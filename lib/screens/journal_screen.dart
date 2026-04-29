import 'package:flutter/material.dart';
import '../theme/steapleaf_theme.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text('Journal', style: SteapLeafTextTheme.headlineMedium),
          ),
          SliverPadding(
            padding: SteapLeafSpacing.screenPadding,
            sliver: SliverList.list(
              children: [
                // Auswertung
                KanjiLabel(
                  kanji: SteapLeafKanji.overview,
                  label: 'AUSWERTUNG',
                ),
                const SizedBox(height: SteapLeafSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: WashiCard(
                        padding: SteapLeafSpacing.allMd,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KanjiLabel(
                              kanji: SteapLeafKanji.record,
                              label: 'SESSIONS',
                            ),
                            const SizedBox(height: SteapLeafSpacing.xs),
                            Container(
                              height: 28,
                              color: colors.surfaceContainerHighest,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: SteapLeafSpacing.sm),
                    Expanded(
                      child: WashiCard(
                        padding: SteapLeafSpacing.allMd,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KanjiLabel(
                              kanji: SteapLeafKanji.tasting,
                              label: 'TEES',
                            ),
                            const SizedBox(height: SteapLeafSpacing.xs),
                            Container(
                              height: 28,
                              color: colors.surfaceContainerHighest,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SteapLeafSpacing.lg),
                // Verlauf
                KanjiLabel(
                  kanji: SteapLeafKanji.history,
                  label: 'VERLAUF',
                ),
                const SizedBox(height: SteapLeafSpacing.sm),
                ...List.generate(
                  4,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: SteapLeafSpacing.sm),
                    child: WashiCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14,
                            width: 120,
                            color: colors.surfaceContainerHighest,
                          ),
                          const SizedBox(height: SteapLeafSpacing.xs),
                          Container(
                            height: 10,
                            width: double.infinity,
                            color: colors.surfaceContainerHighest,
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
