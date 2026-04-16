import 'package:flutter/material.dart';
import '../../../domain/models/tasting_profile.dart';
import '../../../theme/steapleaf_theme.dart';
import 'spider_chart.dart';

/// Read-only-Anzeige eines [TastingProfile] mit zwei Spider-Charts
class TastingProfileView extends StatelessWidget {
  final TastingProfile profile;

  const TastingProfileView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final showAroma     = profile.aroma.isNotEmpty;
    final showTaste     = profile.taste.isNotEmpty;
    final showMouthfeel = profile.mouthfeel.isNotEmpty;

    if (!showAroma && !showTaste && !showMouthfeel) return const SizedBox.shrink();

    return WashiCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAroma) ...[
            Text('香 · Aroma', style: textTheme.labelSmall),
            const SizedBox(height: 14),
            Center(
              child: SpiderChart(
                labels: AromaProfile.axisLabels,
                values: profile.aroma.intensities,
                size: 200,
              ),
            ),
          ],

          if (showTaste) ...[
            if (showAroma) ...[
              const SizedBox(height: 16),
              DashedDivider(color: colorScheme.outlineVariant),
              const SizedBox(height: 16),
            ],
            Text('味 · Geschmack', style: textTheme.labelSmall),
            const SizedBox(height: 14),
            Center(
              child: SpiderChart(
                labels: TasteProfile.axisLabels,
                values: profile.taste.values,
                size: 200,
              ),
            ),
          ],

          if (showMouthfeel) ...[
            if (showAroma || showTaste) ...[
              const SizedBox(height: 16),
              DashedDivider(color: colorScheme.outlineVariant),
              const SizedBox(height: 16),
            ],
            Text('感 · Mundgefühl', style: textTheme.labelSmall),
            const SizedBox(height: 12),
            _MouthfeelDisplay(mouthfeel: profile.mouthfeel),
          ],
        ],
      ),
    );
  }
}

class _MouthfeelDisplay extends StatelessWidget {
  final MouthfeelProfile mouthfeel;
  const _MouthfeelDisplay({required this.mouthfeel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mouthfeel.body > 0)
          _ScaleRow(
            label: 'Körper',
            value: mouthfeel.body,
            startLabel: 'leicht',
            endLabel: 'voll',
          ),
        if (mouthfeel.texture.isNotEmpty) ...[
          const SizedBox(height: 8),
          _TagRow(label: 'Textur', tags: mouthfeel.texture),
        ],
        if (mouthfeel.astringency > 0) ...[
          const SizedBox(height: 8),
          _ScaleRow(
            label: 'Adstringenz',
            value: mouthfeel.astringency,
            startLabel: 'keine',
            endLabel: 'stark',
          ),
        ],
        if (mouthfeel.finishLength > 0) ...[
          const SizedBox(height: 8),
          _ScaleRow(
            label: 'Abgang',
            value: mouthfeel.finishLength,
            startLabel: 'kurz',
            endLabel: 'lang',
          ),
        ],
      ],
    );
  }
}

const double _kLabelWidth = 88;

class _ScaleRow extends StatelessWidget {
  final String label;
  final int value;
  final String? startLabel;
  final String? endLabel;

  const _ScaleRow({
    required this.label,
    required this.value,
    this.startLabel,
    this.endLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: _kLabelWidth,
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (startLabel != null) ...[
            Text(
              startLabel!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Row(
            children: List.generate(5, (i) {
              final filled = i < value;
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled ? colorScheme.primary : Colors.transparent,
                  border: Border.all(
                    color: filled
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
              );
            }),
          ),
          if (endLabel != null) ...[
            const SizedBox(width: 6),
            Text(
              endLabel!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TextTag extends StatelessWidget {
  final String label;
  const _TextTag({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme   = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  final String label;
  final List<String> tags;

  const _TagRow({required this.label, required this.tags});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _kLabelWidth,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: tags.map((tag) => _TextTag(label: tag)).toList(),
          ),
        ),
      ],
    );
  }
}
