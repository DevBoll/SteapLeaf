import 'package:flutter/material.dart';
import '../theme/steapleaf_theme.dart';

class TeaDetailScreen extends StatelessWidget {
  const TeaDetailScreen({super.key, required this.teaId});

  final int? teaId;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text('Tee', style: SteapLeafTextTheme.headlineMedium),
            actions: [
              IconButton(
                icon: KanjiIcon(SteapLeafKanji.edit, size: KanjiSize.icon),
                tooltip: 'Bearbeiten',
                onPressed: null,
              ),
              IconButton(
                icon: KanjiIcon(SteapLeafKanji.delete, size: KanjiSize.icon),
                tooltip: 'Löschen',
                onPressed: null,
              ),
            ],
          ),
          SliverPadding(
            padding: SteapLeafSpacing.screenPadding,
            sliver: SliverList.list(
              children: [
                // Tee-Header
                WashiCard(
                  accentCorners: true,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: SteapLeafSizes.avatarXl,
                        height: SteapLeafSizes.avatarXl,
                        color: colors.surfaceContainerHighest,
                      ),
                      const SizedBox(width: SteapLeafSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 20,
                              width: double.infinity,
                              color: colors.surfaceContainerHighest,
                            ),
                            const SizedBox(height: SteapLeafSpacing.xs),
                            Container(
                              height: 14,
                              width: 80,
                              color: colors.surfaceContainerHighest,
                            ),
                            const SizedBox(height: SteapLeafSpacing.sm),
                            Container(
                              height: 24,
                              width: 60,
                              color: colors.surfaceContainerHighest,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SteapLeafSpacing.lg),

                // Basisdaten
                KanjiLabel(
                  kanji: SteapLeafKanji.basics,
                  label: 'BASISDATEN',
                ),
                const SizedBox(height: SteapLeafSpacing.sm),
                WashiCard(
                  child: Column(
                    children: [
                      _InfoRow(colors: colors, labelWidth: 80),
                      const SizedBox(height: SteapLeafSpacing.sm),
                      _InfoRow(colors: colors, labelWidth: 64),
                      const SizedBox(height: SteapLeafSpacing.sm),
                      _InfoRow(colors: colors, labelWidth: 72),
                    ],
                  ),
                ),
                const SizedBox(height: SteapLeafSpacing.lg),

                // Brühparameter
                KanjiLabel(
                  kanji: SteapLeafKanji.sessionStart,
                  label: 'BRÜHPARAMETER',
                ),
                const SizedBox(height: SteapLeafSpacing.sm),
                WashiCard(
                  child: Column(
                    children: [
                      _InfoRow(colors: colors, labelWidth: 96),
                      const SizedBox(height: SteapLeafSpacing.sm),
                      _InfoRow(colors: colors, labelWidth: 64),
                      const SizedBox(height: SteapLeafSpacing.sm),
                      _InfoRow(colors: colors, labelWidth: 80),
                    ],
                  ),
                ),
                const SizedBox(height: SteapLeafSpacing.lg),

                // Aromaprofil
                KanjiLabel(
                  kanji: SteapLeafKanji.tasting,
                  label: 'AROMAPROFIL',
                ),
                const SizedBox(height: SteapLeafSpacing.sm),
                WashiCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: SteapLeafSpacing.xs,
                        runSpacing: SteapLeafSpacing.xs,
                        children: List.generate(
                          5,
                          (i) => Container(
                            height: 28,
                            width: 56 + i * 12.0,
                            color: colors.surfaceContainerHighest,
                          ),
                        ),
                      ),
                      const SizedBox(height: SteapLeafSpacing.sm),
                      Container(
                        height: 64,
                        color: colors.surfaceContainerHighest,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SteapLeafSpacing.lg),

                // Notizen
                KanjiLabel(
                  kanji: SteapLeafKanji.notes,
                  label: 'NOTIZEN',
                ),
                const SizedBox(height: SteapLeafSpacing.sm),
                WashiCard(
                  child: Container(
                    height: 80,
                    color: colors.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: SteapLeafSpacing.lg),

                // Sessionen
                KanjiLabel(
                  kanji: SteapLeafKanji.history,
                  label: 'SESSIONEN',
                ),
                const SizedBox(height: SteapLeafSpacing.sm),
                ...List.generate(
                  3,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: SteapLeafSpacing.sm),
                    child: WashiCard(
                      child: _InfoRow(colors: colors, labelWidth: 72),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.colors, required this.labelWidth});

  final ColorScheme colors;
  final double labelWidth;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            height: 12,
            width: labelWidth,
            color: colors.surfaceContainerHighest,
          ),
          const SizedBox(width: SteapLeafSpacing.md),
          Expanded(
            child: Container(
              height: 12,
              color: colors.surfaceContainerHighest,
            ),
          ),
        ],
      );
}
