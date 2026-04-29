import 'package:flutter/material.dart';
import '../theme/steapleaf_theme.dart';

class TeaEditScreen extends StatelessWidget {
  const TeaEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tee erfassen', style: SteapLeafTextTheme.titleLarge),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: SteapLeafSpacing.screenPadding,
            sliver: SliverList.list(
              children: [
                KanjiLabel(
                  kanji: SteapLeafKanji.basics,
                  label: 'BASISDATEN',
                ),
                const SizedBox(height: SteapLeafSpacing.sm),
                WashiCard(
                  child: Column(
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: SteapLeafSpacing.sm,
                        ),
                        child: Container(
                          height: SteapLeafSizes.inputHeight,
                          color: colors.surfaceContainerHighest,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: SteapLeafSpacing.lg),
                KanjiLabel(
                  kanji: SteapLeafKanji.notes,
                  label: 'NOTIZEN',
                ),
                const SizedBox(height: SteapLeafSpacing.sm),
                WashiCard(
                  child: Container(
                    height: 120,
                    color: colors.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ActionBar(
        children: [
          ActionBarButton.secondary(
            label: 'Abbrechen',
            onPressed: () => Navigator.of(context).pop(),
          ),
          ActionBarButton.primary(
            label: 'Speichern',
            onPressed: null,
          ),
        ],
      ),
    );
  }
}
