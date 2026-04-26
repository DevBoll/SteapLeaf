import 'package:flutter/material.dart';
import '../../../core/models/flavor_profile.dart';
import '../../../theme/steapleaf_theme.dart';

import 'intensity_slider.dart';
import 'tag_chips.dart';

/// Vollständiger Editor für [FlavorProfile].
/// Besteht aus drei WashiCard-Blöcken: Aroma, Geschmack, Mundgefühl.
/// Kein Chart-Preview — die Rohwerte werden direkt bearbeitet.
class FlavorProfileEditor extends StatelessWidget {
  final FlavorProfile profile;
  final ValueChanged<FlavorProfile> onChanged;

  const FlavorProfileEditor({
    super.key,
    required this.profile,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return WashiCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AromaSection(profile: profile, onChanged: onChanged),
          const SizedBox(height: SteapLeafSpacing.sm),
          _TasteSection(profile: profile, onChanged: onChanged),
          const SizedBox(height: SteapLeafSpacing.sm),
          _MouthfeelSection(profile: profile, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _AromaSection extends StatelessWidget {
  final FlavorProfile profile;
  final ValueChanged<FlavorProfile> onChanged;

  const _AromaSection({required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('香 · Aroma', style: textTheme.labelSmall),
        ...profile.aroma.axes.map((entry) => IntensitySlider(
              label: entry.label,
              value: entry.axis.intensity,
              onChanged: (v) => onChanged(
                profile.copyWith(
                  aroma: profile.aroma.withAxis(
                    entry.key,
                    entry.axis.copyWith(intensity: v),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

class _TasteSection extends StatelessWidget {
  final FlavorProfile profile;
  final ValueChanged<FlavorProfile> onChanged;

  const _TasteSection({required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final t = profile.taste;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('味 · Geschmack', style: textTheme.labelSmall),
        IntensitySlider(
          label: 'Süß',
          value: t.sweet,
          onChanged: (v) =>
              onChanged(profile.copyWith(taste: t.copyWith(sweet: v))),
        ),
        IntensitySlider(
          label: 'Sauer',
          value: t.sour,
          onChanged: (v) =>
              onChanged(profile.copyWith(taste: t.copyWith(sour: v))),
        ),
        IntensitySlider(
          label: 'Bitter',
          value: t.bitter,
          onChanged: (v) =>
              onChanged(profile.copyWith(taste: t.copyWith(bitter: v))),
        ),
        IntensitySlider(
          label: 'Umami',
          value: t.umami,
          onChanged: (v) =>
              onChanged(profile.copyWith(taste: t.copyWith(umami: v))),
        ),
        IntensitySlider(
          label: 'Salzig',
          value: t.salty,
          onChanged: (v) =>
              onChanged(profile.copyWith(taste: t.copyWith(salty: v))),
        ),
      ],
    );
  }
}

class _MouthfeelSection extends StatelessWidget {
  final FlavorProfile profile;
  final ValueChanged<FlavorProfile> onChanged;

  const _MouthfeelSection({required this.profile, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final m = profile.mouthfeel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('感 · Mundgefühl', style: textTheme.labelSmall),
        IntensitySlider(
          label: 'Körper',
          value: m.body,
          startLabel: 'leicht',
          endLabel: 'voll',
          onChanged: (v) => onChanged(
            profile.copyWith(mouthfeel: m.copyWith(body: v)),
          ),
        ),
        const SizedBox(height: SteapLeafSpacing.xs),
        Text('Textur', style: textTheme.labelSmall),
        const SizedBox(height: SteapLeafSpacing.xs),
        TagChips(
          options: TastingTags.texture,
          selected: m.texture,
          onChanged: (v) => onChanged(
            profile.copyWith(mouthfeel: m.copyWith(texture: v)),
          ),
        ),
        const SizedBox(height: 10),
        IntensitySlider(
          label: 'Adstringenz',
          value: m.astringency,
          onChanged: (v) => onChanged(
            profile.copyWith(mouthfeel: m.copyWith(astringency: v)),
          ),
        ),
        const SizedBox(height: 10),
        IntensitySlider(
          label: 'Abgang',
          value: m.finishLength,
          startLabel: 'kurz',
          endLabel: 'lang',
          onChanged: (v) => onChanged(
            profile.copyWith(mouthfeel: m.copyWith(finishLength: v)),
          ),
        ),
      ],
    );
  }
}
