import 'package:flutter/material.dart';

import '../../domain/enums/enums.dart';
import '../../domain/models/brew_variant.dart';
import '../../domain/models/infusion_spec.dart';
import '../../domain/models/tea.dart';
import '../../theme/steapleaf_theme.dart';

// Kanji-Zeichen für Brühstile
const _kKanjiWestern  = '法';
const _kKanjiGongfu   = '功';
const _kKanjiColdBrew = '冷';
const _kKanjiCustom   = '外';
const _kKanjiRinse    = '洗';
const _kKanjiInfusion = '煎';

// Kanji-Ziffern für Aufguss-Nummerierung
const _kKanjiDigits = ['一','二','三','四','五','六','七','八','九','十'];

/// Vollständige Brühvarianten-Karte mit Aufguss-Raster.
class BrewVariantCard extends StatefulWidget {
  final Tea tea;
  final BrewVariant variant;
  final VoidCallback onTap;
  final String ctaLabel;

  const BrewVariantCard({
    super.key,
    required this.tea,
    required this.variant,
    required this.onTap,
    this.ctaLabel = 'Mit dieser brühen →',
  });

  @override
  State<BrewVariantCard> createState() => _BrewVariantCardState();
}

class _BrewVariantCardState extends State<BrewVariantCard> {
  late bool _expanded;

  static const _styleKanji = {
    BrewStyle.western:  _kKanjiWestern,
    BrewStyle.gongfu:   _kKanjiGongfu,
    BrewStyle.coldBrew: _kKanjiColdBrew,
    BrewStyle.custom:   _kKanjiCustom,
  };

  static IconData _containerIcon(int ml) {
    if (ml < 200) return Icons.coffee;
    if (ml < 300) return Icons.local_cafe;
    if (ml < 500) return Icons.sports_bar;
    return Icons.emoji_food_beverage;
  }

  @override
  void initState() {
    super.initState();
    _expanded = widget.variant.id == widget.tea.defaultVariantId;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme   = Theme.of(context).textTheme;

    final v          = widget.variant;
    final isDefault  = v.id == widget.tea.defaultVariantId;
    final isGongFu   = v.style == BrewStyle.gongfu;
    final isColdBrew = v.style == BrewStyle.coldBrew;
    final isOther    = v.style == BrewStyle.custom;
    final hasRinse   = isGongFu && v.hasRinse && v.rinseInfusions.isNotEmpty;

    return WashiCard(
      accentCorners: isDefault,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Header: Style-Kanji + Bezeichnung + Toggle
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: 0.5,
                    ),
                  ),
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: Center(
                      child: Text(
                        _styleKanji[v.style] ?? _kKanjiCustom,
                        style: TextStyle(
                          fontFamily: SteapLeafTextTheme.serifFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    v.label.isNotEmpty ? v.label : v.style.label,
                    style: textTheme.titleSmall,
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Dosage + Wassermenge (immer sichtbar)
          if (v.dosageGrams != null || v.waterMl != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (v.dosageGrams != null) ...[
                  Icon(Icons.eco_outlined, size: 14,
                      color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    '${v.dosageGrams!.toStringAsFixed(1)} g',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (v.dosageGrams != null && v.waterMl != null)
                  const SizedBox(width: 14),
                if (v.waterMl != null) ...[
                  Icon(_containerIcon(v.waterMl!), size: 14,
                      color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    '${v.waterMl} ml',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ],

          // Detail-Bereich (eingeklappt/aufgeklappt)
          if (_expanded) ...[

            // Gong Fu: Rinse-Aufgüsse
            if (hasRinse) ...[
              const SizedBox(height: 12),
              _SectionLabel('$_kKanjiRinse · Rinse'),
              const SizedBox(height: 6),
              BrewVariantInfusionGrid(
                infusions: v.rinseInfusions,
                dimmed: true,
                secondsOnly: true,
              ),
            ],

            // Aufguss-Tabelle
            if (v.infusions.isNotEmpty) ...[
              const SizedBox(height: 12),
              _SectionLabel(
                hasRinse ? '$_kKanjiInfusion · Aufgüsse' : 'Aufgüsse',
              ),
              const SizedBox(height: 6),
              BrewVariantInfusionGrid(
                infusions: v.infusions,
                secondsOnly: isGongFu,
              ),
            ],

            // Cold Brew: Kühlschrank
            if (isColdBrew) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    v.isFridgeBrew
                        ? Icons.kitchen_outlined
                        : Icons.thermostat_outlined,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    v.isFridgeBrew ? 'Im Kühlschrank' : 'Bei Raumtemperatur',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],

            // Benutzerdefiniert: Notizen + Zusätze
            if (isOther) ...[
              if (v.customNotes != null && v.customNotes!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  v.customNotes!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ],
              if (v.additions.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: v.additions
                      .map((a) => _AdditionChip(label: a))
                      .toList(),
                ),
              ],
            ],

            // CTA
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: widget.onTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary, width: 0.5),
                  shape: const RoundedRectangleBorder(),
                  textStyle: textTheme.bodySmall?.copyWith(letterSpacing: 0.3),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(widget.ctaLabel),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.labelSmall);
}

class _AdditionChip extends StatelessWidget {
  final String label;
  const _AdditionChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          label.toUpperCase(),
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

class BrewVariantInfusionGrid extends StatefulWidget {
  final List<InfusionSpec> infusions;
  final bool dimmed;
  final bool secondsOnly;

  const BrewVariantInfusionGrid({
    super.key,
    required this.infusions,
    this.dimmed = false,
    this.secondsOnly = false,
  });

  static String _kanjiFor(int i) =>
      i < _kKanjiDigits.length ? _kKanjiDigits[i] : '${i + 1}';

  static String _fmtTime(Duration d, {bool secondsOnly = false}) {
    if (secondsOnly) return '${d.inSeconds}s';
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  State<BrewVariantInfusionGrid> createState() =>
      _BrewVariantInfusionGridState();
}

class _BrewVariantInfusionGridState extends State<BrewVariantInfusionGrid> {
  static const _kCollapsedMax = 4;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme   = Theme.of(context).textTheme;
    final color    = widget.dimmed
        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
        : colorScheme.onSurfaceVariant;
    final divColor = widget.dimmed
        ? colorScheme.outlineVariant.withValues(alpha: 0.5)
        : colorScheme.outlineVariant;

    final allInfusions  = widget.infusions;
    final collapsible   = allInfusions.length > _kCollapsedMax;
    final visible       = collapsible && !_expanded
        ? allInfusions.sublist(0, _kCollapsedMax)
        : allInfusions;

    final rows = <Widget>[];
    for (var i = 0; i < visible.length; i += 2) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 10));
      final right = i + 1 < visible.length ? visible[i + 1] : null;
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _InfusionCell(
                index: i,
                spec: visible[i],
                color: color,
                divColor: divColor,
                secondsOnly: widget.secondsOnly,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: right != null
                  ? _InfusionCell(
                      index: i + 1,
                      spec: right,
                      color: color,
                      divColor: divColor,
                      secondsOnly: widget.secondsOnly,
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      );
    }

    if (collapsible) {
      rows.add(const SizedBox(height: 8));
      rows.add(
        TextButton(
          onPressed: () => setState(() => _expanded = !_expanded),
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.onSurfaceVariant,
            textStyle: textTheme.bodySmall?.copyWith(letterSpacing: 0.2),
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            _expanded
                ? 'Weniger anzeigen ↑'
                : 'Alle ${allInfusions.length} Aufgüsse ↓',
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}

class _InfusionCell extends StatelessWidget {
  final int index;
  final InfusionSpec spec;
  final Color color;
  final Color divColor;
  final bool secondsOnly;

  const _InfusionCell({
    required this.index,
    required this.spec,
    required this.color,
    required this.divColor,
    required this.secondsOnly,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          BrewVariantInfusionGrid._kanjiFor(index),
          style: TextStyle(
            fontFamily: SteapLeafTextTheme.serifFamily,
            fontSize: 12,
            color: color,
          ),
        ),
        const SizedBox(height: 3),
        Divider(height: 1, thickness: 0.5, color: divColor),
        const SizedBox(height: 5),
        Text(
          spec.tempDisplay,
          style: textTheme.bodySmall?.copyWith(color: color),
        ),
        const SizedBox(height: 1),
        Text(
          BrewVariantInfusionGrid._fmtTime(spec.steepTime, secondsOnly: secondsOnly),
          style: textTheme.bodySmall?.copyWith(
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
