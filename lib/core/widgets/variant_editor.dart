import 'package:flutter/material.dart';
import '../../theme/steapleaf_theme.dart';
import '../models/brewing_parameters.dart';
import '../models/brewing_variant.dart';
import '../models/enums.dart';
import 'toggle_row.dart';

class VariantEditor extends StatefulWidget {
  final BrewingVariant variant;
  final int index;
  final bool isDefault;
  final VoidCallback onSetDefault;
  final ValueChanged<BrewingVariant> onChanged;
  final VoidCallback onDelete;

  const VariantEditor({
    super.key,
    required this.variant,
    required this.index,
    required this.isDefault,
    required this.onSetDefault,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<VariantEditor> createState() => _VariantEditorState();
}

class _VariantEditorState extends State<VariantEditor> {
  bool _expanded = true;

  late TextEditingController _label;
  late TextEditingController _dosage;
  late TextEditingController _water;
  late TextEditingController _temp;
  late TextEditingController _cbHours;
  late TextEditingController _cbMins;
  late TextEditingController _whiskSecs;
  late TextEditingController _custNotes;

  @override
  void initState() {
    super.initState();
    final v = widget.variant;
    final p = v.parameters;
    _label = TextEditingController(
      text: v.brewingType == BrewingType.custom ? v.name : '',
    );
    _dosage = TextEditingController(
      text: p.teaGrams > 0 ? p.teaGrams.toString() : '',
    );
    _water = TextEditingController(
      text: p.waterMl > 0 ? p.waterMl.toInt().toString() : '',
    );
    _temp = TextEditingController(
      text: p.temperatureCelsius > 0 ? p.temperatureCelsius.toInt().toString() : '',
    );
    final cbSecs = p.minColdSteepSeconds ?? (8 * 3600);
    _cbHours = TextEditingController(text: (cbSecs ~/ 3600).toString());
    _cbMins = TextEditingController(text: ((cbSecs % 3600) ~/ 60).toString());
    _whiskSecs = TextEditingController(
      text: p.whiskSeconds > 0 ? p.whiskSeconds.toString() : '',
    );
    _custNotes = TextEditingController(text: v.notes);
  }

  @override
  void dispose() {
    _label.dispose();
    _dosage.dispose();
    _water.dispose();
    _temp.dispose();
    _cbHours.dispose();
    _cbMins.dispose();
    _whiskSecs.dispose();
    _custNotes.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  List<BrewingStep> _drinkSteps(BrewingVariant v) =>
      v.parameters.steps.where((s) => s.type == InfusionType.drink).toList();

  List<BrewingStep> _rinseSteps(BrewingVariant v) =>
      v.parameters.steps.where((s) => s.type == InfusionType.prep).toList();

  bool _hasRinse(BrewingVariant v) =>
      v.parameters.steps.any((s) => s.type == InfusionType.prep);

  BrewingParameters _baseParams() => widget.variant.parameters.copyWith(
        teaGrams: double.tryParse(_dosage.text) ??
            widget.variant.parameters.teaGrams,
        waterMl: double.tryParse(_water.text) ??
            widget.variant.parameters.waterMl,
        temperatureCelsius: double.tryParse(_temp.text) ??
            widget.variant.parameters.temperatureCelsius,
      );

  // ── Mutators ─────────────────────────────────────────────────────────────

  void _changeStyle(BrewingType t) {
    _label.text = '';
    BrewingParameters newParams;
    switch (t) {
      case BrewingType.coldBrew:
        _cbHours.text = '8';
        _cbMins.text = '0';
        _temp.text = '4';
        newParams = BrewingParameters(
          teaGrams: widget.variant.parameters.teaGrams,
          waterMl: widget.variant.parameters.waterMl,
          temperatureCelsius: 4,
          minColdSteepSeconds: 8 * 3600,
          coldBrewLocation: ColdBrewLocation.fridge,
        );
      case BrewingType.gongfu:
        _temp.text = '85';
        newParams = BrewingParameters(
          teaGrams: widget.variant.parameters.teaGrams,
          waterMl: widget.variant.parameters.waterMl,
          temperatureCelsius: 85,
          steps: const [BrewingStep(steepSeconds: 30, type: InfusionType.drink)],
        );
      case BrewingType.western:
        _temp.text = '80';
        newParams = BrewingParameters(
          teaGrams: widget.variant.parameters.teaGrams,
          waterMl: widget.variant.parameters.waterMl,
          temperatureCelsius: 80,
          steps: const [BrewingStep(steepSeconds: 180, type: InfusionType.drink)],
        );
      case BrewingType.matcha:
        _temp.text = '75';
        _whiskSecs.text = '30';
        newParams = BrewingParameters(
          teaGrams: widget.variant.parameters.teaGrams,
          waterMl: widget.variant.parameters.waterMl,
          temperatureCelsius: 75,
          whiskSeconds: 30,
        );
      case BrewingType.custom:
        _custNotes.text = '';
        _temp.text = '80';
        newParams = BrewingParameters(
          teaGrams: widget.variant.parameters.teaGrams,
          waterMl: widget.variant.parameters.waterMl,
          temperatureCelsius: 80,
          steps: const [BrewingStep(steepSeconds: 180, type: InfusionType.drink)],
        );
    }
    final newName = t != BrewingType.custom ? t.label : '';
    widget.onChanged(
      widget.variant.copyWith(brewingType: t, name: newName, parameters: newParams),
    );
  }

  void _updateBaseOnly() =>
      widget.onChanged(widget.variant.copyWith(parameters: _baseParams()));

  void _updateColdBrew() {
    final secs = (int.tryParse(_cbHours.text) ?? 0) * 3600 +
        (int.tryParse(_cbMins.text) ?? 0) * 60;
    widget.onChanged(widget.variant.copyWith(
      parameters: _baseParams().copyWith(minColdSteepSeconds: secs),
    ));
  }

  void _updateMatcha() {
    widget.onChanged(widget.variant.copyWith(
      parameters: _baseParams().copyWith(
        whiskSeconds: int.tryParse(_whiskSecs.text) ??
            widget.variant.parameters.whiskSeconds,
      ),
    ));
  }

  void _updateCustomNotes() => widget.onChanged(
        widget.variant.copyWith(notes: _custNotes.text.trim()),
      );

  void _setHasRinse(bool val) {
    final v = widget.variant;
    final steps = val
        ? [
            const BrewingStep(steepSeconds: 15, type: InfusionType.prep),
            ..._drinkSteps(v),
          ]
        : _drinkSteps(v);
    widget.onChanged(v.copyWith(parameters: v.parameters.copyWith(steps: steps)));
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final v = widget.variant;
    final headerLabel = v.brewingType != BrewingType.custom
        ? v.brewingType.label
        : (v.name.isEmpty ? 'Variante ${widget.index + 1}' : v.name);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: WashiCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Header
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Text(headerLabel, style: textTheme.titleSmall),
                      const Spacer(),
                      Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        size: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      Semantics(
                        label: widget.isDefault
                            ? 'Als Standard entfernen'
                            : 'Als Standard setzen',
                        button: true,
                        child: InkWell(
                          onTap: widget.onSetDefault,
                          child: SizedBox(
                            width: 44,
                            height: 44,
                            child: Icon(
                              widget.isDefault
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 20,
                              color: widget.isDefault
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: widget.onDelete,
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Expandierter Body
            if (_expanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Typ-Chips
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: BrewingType.values.map((t) {
                        final active = v.brewingType == t;
                        return ChoiceChip(
                          label: Text(t.label),
                          selected: active,
                          showCheckmark: false,
                          selectedColor: colorScheme.onSurface,
                          side: BorderSide(
                            color: active
                                ? colorScheme.onSurface
                                : colorScheme.outlineVariant,
                            width: active ? 1.0 : 0.5,
                          ),
                          labelStyle: textTheme.bodySmall?.copyWith(
                            color: active
                                ? colorScheme.surface
                                : colorScheme.onSurfaceVariant,
                          ),
                          onSelected: (_) => _changeStyle(t),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),

                    // Tee (g) + Wasser (ml) + Temperatur (°C)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _dosage,
                            decoration: const InputDecoration(labelText: 'Tee (g)'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => _updateBaseOnly(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _water,
                            decoration: const InputDecoration(labelText: 'Wasser (ml)'),
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _updateBaseOnly(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _temp,
                            decoration: const InputDecoration(labelText: '°C'),
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _updateBaseOnly(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Typ-spezifische Felder
                    if (v.brewingType == BrewingType.western) ...[
                      _InfusionSection(
                        label: 'Trink-Aufgüsse',
                        gongFu: false,
                        steps: _drinkSteps(v),
                        onChanged: (updated) => widget.onChanged(v.copyWith(
                          parameters: v.parameters.copyWith(steps: updated),
                        )),
                      ),
                    ] else if (v.brewingType == BrewingType.gongfu) ...[
                      ToggleRow(
                        label: 'Rinse (Aufwachaufguss)',
                        value: _hasRinse(v),
                        onChanged: _setHasRinse,
                      ),
                      if (_hasRinse(v)) ...[
                        const SizedBox(height: 8),
                        _InfusionSection(
                          label: 'Rinse-Aufgüsse',
                          gongFu: true,
                          steps: _rinseSteps(v),
                          onChanged: (updated) => widget.onChanged(v.copyWith(
                            parameters: v.parameters.copyWith(
                              steps: [...updated, ..._drinkSteps(v)],
                            ),
                          )),
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: colorScheme.outlineVariant,
                        ),
                      ],
                      const SizedBox(height: 8),
                      _InfusionSection(
                        label: 'Trink-Aufgüsse',
                        gongFu: true,
                        steps: _drinkSteps(v),
                        onChanged: (updated) => widget.onChanged(v.copyWith(
                          parameters: v.parameters.copyWith(
                            steps: [..._rinseSteps(v), ...updated],
                          ),
                        )),
                      ),
                    ] else if (v.brewingType == BrewingType.coldBrew) ...[
                      Text('Ziehzeit', style: textTheme.labelSmall),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _cbHours,
                              decoration: const InputDecoration(labelText: 'Stunden'),
                              keyboardType: TextInputType.number,
                              onChanged: (_) => _updateColdBrew(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _cbMins,
                              decoration: const InputDecoration(labelText: 'Minuten'),
                              keyboardType: TextInputType.number,
                              onChanged: (_) => _updateColdBrew(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ToggleRow(
                        label: 'Im Kühlschrank',
                        value: v.parameters.coldBrewLocation ==
                            ColdBrewLocation.fridge,
                        onChanged: (val) => widget.onChanged(v.copyWith(
                          parameters: v.parameters.copyWith(
                            coldBrewLocation: val
                                ? ColdBrewLocation.fridge
                                : ColdBrewLocation.room,
                          ),
                        )),
                      ),
                    ] else if (v.brewingType == BrewingType.matcha) ...[
                      TextField(
                        controller: _whiskSecs,
                        decoration:
                            const InputDecoration(labelText: 'Whisk-Zeit (Sek)'),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _updateMatcha(),
                      ),
                    ] else if (v.brewingType == BrewingType.custom) ...[
                      TextField(
                        controller: _label,
                        decoration:
                            const InputDecoration(labelText: 'Bezeichnung'),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (val) =>
                            widget.onChanged(v.copyWith(name: val.trim())),
                      ),
                      const SizedBox(height: 8),
                      _InfusionSection(
                        label: 'Trink-Aufgüsse',
                        gongFu: false,
                        steps: _drinkSteps(v),
                        onChanged: (updated) => widget.onChanged(v.copyWith(
                          parameters: v.parameters.copyWith(steps: updated),
                        )),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _custNotes,
                        decoration:
                            const InputDecoration(labelText: 'Notizen'),
                        maxLines: 3,
                        minLines: 1,
                        onChanged: (_) => _updateCustomNotes(),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Aufguss-Sektion ─────────────────────────────────────────────────────────

class _InfusionSection extends StatelessWidget {
  final String label;
  final bool gongFu;
  final List<BrewingStep> steps;
  final ValueChanged<List<BrewingStep>> onChanged;

  const _InfusionSection({
    required this.label,
    required this.gongFu,
    required this.steps,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final stepType =
        steps.isNotEmpty ? steps.first.type : InfusionType.drink;
    final defaultSecs = gongFu ? 30 : 120;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: textTheme.labelSmall),
            TextButton(
              onPressed: () {
                final lastSecs =
                    steps.isNotEmpty ? steps.last.steepSeconds : defaultSecs;
                onChanged([
                  ...steps,
                  BrewingStep(steepSeconds: lastSecs, type: stepType),
                ]);
              },
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSurfaceVariant,
                textStyle: textTheme.labelSmall,
                minimumSize: Size.zero,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('+ Aufguss'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...steps.asMap().entries.map((e) => _InfusionRow(
              key: ValueKey(e.key),
              index: e.key,
              step: e.value,
              gongFu: gongFu,
              onChanged: (s) {
                final list = List<BrewingStep>.from(steps)..[e.key] = s;
                onChanged(list);
              },
              onDelete: () {
                final list = List<BrewingStep>.from(steps)..removeAt(e.key);
                onChanged(list);
              },
            )),
      ],
    );
  }
}

// ─── Aufguss-Zeile ───────────────────────────────────────────────────────────

class _InfusionRow extends StatefulWidget {
  final int index;
  final BrewingStep step;
  final bool gongFu;
  final ValueChanged<BrewingStep> onChanged;
  final VoidCallback onDelete;

  const _InfusionRow({
    super.key,
    required this.index,
    required this.step,
    required this.gongFu,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_InfusionRow> createState() => _InfusionRowState();
}

class _InfusionRowState extends State<_InfusionRow> {
  late TextEditingController _timeSecs;
  late TextEditingController _timeMins;
  late TextEditingController _timeSecsSplit;

  @override
  void initState() {
    super.initState();
    final secs = widget.step.steepSeconds;
    _timeSecs = TextEditingController(text: secs.toString());
    _timeMins = TextEditingController(text: (secs ~/ 60).toString());
    _timeSecsSplit = TextEditingController(text: (secs % 60).toString());
  }

  @override
  void didUpdateWidget(_InfusionRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      final secs = widget.step.steepSeconds;
      _timeSecs.text = secs.toString();
      _timeMins.text = (secs ~/ 60).toString();
      _timeSecsSplit.text = (secs % 60).toString();
    }
  }

  @override
  void dispose() {
    _timeSecs.dispose();
    _timeMins.dispose();
    _timeSecsSplit.dispose();
    super.dispose();
  }

  void _update() {
    final steepSecs = widget.gongFu
        ? (int.tryParse(_timeSecs.text) ?? widget.step.steepSeconds)
        : (int.tryParse(_timeMins.text) ?? 0) * 60 +
            (int.tryParse(_timeSecsSplit.text) ?? 0);
    widget.onChanged(widget.step.copyWith(steepSeconds: steepSecs));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            '${widget.index + 1}.',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 8),
          if (widget.gongFu) ...[
            Expanded(
              child: TextField(
                controller: _timeSecs,
                decoration: const InputDecoration(
                  labelText: 'Sek',
                  contentPadding: EdgeInsets.zero,
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _update(),
              ),
            ),
          ] else ...[
            Expanded(
              child: TextField(
                controller: _timeMins,
                decoration: const InputDecoration(
                  labelText: 'Min',
                  contentPadding: EdgeInsets.zero,
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _update(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _timeSecsSplit,
                decoration: const InputDecoration(
                  labelText: 'Sek',
                  contentPadding: EdgeInsets.zero,
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _update(),
              ),
            ),
          ],
          InkWell(
            onTap: widget.onDelete,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(
                Icons.remove_circle_outline,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
