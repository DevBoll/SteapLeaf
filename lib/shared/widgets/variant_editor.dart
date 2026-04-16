import 'package:flutter/material.dart';
import 'package:steapleaf/domain/enums/enums.dart';
import 'package:steapleaf/domain/models/brew_variant.dart';
import 'package:steapleaf/domain/models/infusion_spec.dart';
import '../../theme/steapleaf_theme.dart';
import 'toggle_row.dart';

class VariantEditor extends StatefulWidget {
  final BrewVariant variant;
  final int index;
  final bool isDefault;
  final VoidCallback onSetDefault;
  final ValueChanged<BrewVariant> onChanged;
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
  late TextEditingController _cbHours;
  late TextEditingController _cbMins;
  late TextEditingController _custNotes;

  @override
  void initState() {
    super.initState();
    final v = widget.variant;
    _label = TextEditingController(
      text: v.style == BrewStyle.custom ? v.label : '',
    );
    _dosage = TextEditingController(text: v.dosageGrams?.toString() ?? '');
    _water = TextEditingController(text: v.waterMl?.toString() ?? '');

    final firstInf = v.infusions.isNotEmpty ? v.infusions.first : null;
    final cbSteep = firstInf?.steepTime ?? const Duration(hours: 8);
    _cbHours = TextEditingController(text: cbSteep.inHours.toString());
    _cbMins = TextEditingController(text: (cbSteep.inMinutes % 60).toString());
    _custNotes = TextEditingController(text: v.customNotes ?? '');
  }

  @override
  void dispose() {
    _label.dispose();
    _dosage.dispose();
    _water.dispose();
    _cbHours.dispose();
    _cbMins.dispose();
    _custNotes.dispose();
    super.dispose();
  }

  void _changeStyle(BrewStyle s) {
    _label.text = '';
    List<InfusionSpec> newInf;
    switch (s) {
      case BrewStyle.coldBrew:
        _cbHours.text = '8';
        _cbMins.text = '0';
        newInf = [InfusionSpec(tempMin: 4, steepTime: const Duration(hours: 8))];
      case BrewStyle.gongfu:
        newInf = [InfusionSpec(tempMin: 85, steepTime: const Duration(seconds: 30))];
      case BrewStyle.western:
        newInf = [InfusionSpec(tempMin: 80, steepTime: const Duration(minutes: 3))];
      case BrewStyle.custom:
        _custNotes.text = '';
        newInf = [InfusionSpec(tempMin: 80, steepTime: const Duration(minutes: 3))];
    }
    final newLabel = s != BrewStyle.custom ? s.label : '';
    widget.onChanged(
      widget.variant.copyWith(style: s, label: newLabel, infusions: newInf),
    );
  }

  void _updateBaseOnly() => widget.onChanged(widget.variant.copyWith(
        dosageGrams: double.tryParse(_dosage.text),
        waterMl: int.tryParse(_water.text),
      ));

  void _updateColdBrew() {
    final steep = Duration(
      hours: int.tryParse(_cbHours.text) ?? 0,
      minutes: int.tryParse(_cbMins.text) ?? 0,
    );
    final inf = widget.variant.infusions.isNotEmpty
        ? widget.variant.infusions.first.copyWith(steepTime: steep)
        : InfusionSpec(tempMin: 4, steepTime: steep);
    widget.onChanged(widget.variant.copyWith(
      dosageGrams: double.tryParse(_dosage.text),
      waterMl: int.tryParse(_water.text),
      infusions: [inf],
    ));
  }

  void _updateCustomNotes() {
    final notes = _custNotes.text.trim();
    widget.onChanged(widget.variant.copyWith(
      customNotes: notes.isEmpty ? null : notes,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final v = widget.variant;
    final headerLabel = v.style != BrewStyle.custom
        ? v.style.label
        : (v.label.isEmpty ? 'Variante ${widget.index + 1}' : v.label);

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
                    // Stil-Chips
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: BrewStyle.values.map((s) {
                        final active = v.style == s;
                        return ChoiceChip(
                          label: Text(s.label),
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
                          onSelected: (_) => _changeStyle(s),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),

                    // Tee (g) + Wasser (ml)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _dosage,
                            decoration: const InputDecoration(labelText: 'Tee (g)'),
                            keyboardType: TextInputType.number,
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
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Stil-spezifische Felder
                    if (v.style == BrewStyle.western) ...[
                      _InfusionSection(
                        label: 'Trink-Aufgüsse',
                        gongFu: false,
                        variant: v,
                        onChanged: widget.onChanged,
                      ),
                    ] else if (v.style == BrewStyle.gongfu) ...[
                      ToggleRow(
                        label: 'Rinse (Aufwachaufguss)',
                        value: v.hasRinse,
                        onChanged: (val) =>
                            widget.onChanged(v.copyWith(hasRinse: val)),
                      ),
                      if (v.hasRinse) ...[
                        const SizedBox(height: 8),
                        _RinseSection(variant: v, onChanged: widget.onChanged),
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
                        variant: v,
                        onChanged: widget.onChanged,
                      ),
                    ] else if (v.style == BrewStyle.coldBrew) ...[
                      Text('Aufguss', style: textTheme.labelSmall),
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
                        value: v.isFridgeBrew,
                        onChanged: (val) =>
                            widget.onChanged(v.copyWith(isFridgeBrew: val)),
                      ),
                    ] else if (v.style == BrewStyle.custom) ...[
                      TextField(
                        controller: _label,
                        decoration: const InputDecoration(labelText: 'Bezeichnung'),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (val) =>
                            widget.onChanged(v.copyWith(label: val.trim())),
                      ),
                      const SizedBox(height: 8),
                      _InfusionSection(
                        label: 'Trink-Aufgüsse',
                        gongFu: false,
                        variant: v,
                        onChanged: widget.onChanged,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _custNotes,
                        decoration: const InputDecoration(labelText: 'Notizen'),
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

// Aufguss-Sektion

class _InfusionSection extends StatelessWidget {
  final String label;
  final bool gongFu;
  final BrewVariant variant;
  final ValueChanged<BrewVariant> onChanged;

  const _InfusionSection({
    required this.label,
    required this.gongFu,
    required this.variant,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: textTheme.labelSmall),
            TextButton(
              onPressed: () {
                final lastTemp = variant.infusions.isNotEmpty
                    ? variant.infusions.last.tempMin
                    : 80;
                final defaultTime = gongFu
                    ? const Duration(seconds: 30)
                    : const Duration(minutes: 2);
                final updated = List<InfusionSpec>.from(variant.infusions)
                  ..add(InfusionSpec(tempMin: lastTemp, steepTime: defaultTime));
                onChanged(variant.copyWith(infusions: updated));
              },
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSurfaceVariant,
                textStyle: textTheme.labelSmall,
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('+ Aufguss'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...variant.infusions.asMap().entries.map((e) => _InfusionRow(
              key: ValueKey(e.value.id),
              index: e.key,
              spec: e.value,
              gongFu: gongFu,
              onChanged: (s) {
                final list = List<InfusionSpec>.from(variant.infusions);
                list[e.key] = s;
                onChanged(variant.copyWith(infusions: list));
              },
              onDelete: () {
                final list = List<InfusionSpec>.from(variant.infusions)
                  ..removeAt(e.key);
                onChanged(variant.copyWith(infusions: list));
              },
            )),
      ],
    );
  }
}

// Rinse-Sektion

class _RinseSection extends StatelessWidget {
  final BrewVariant variant;
  final ValueChanged<BrewVariant> onChanged;

  const _RinseSection({required this.variant, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Rinse-Aufgüsse', style: textTheme.labelSmall),
            TextButton(
              onPressed: () {
                final lastTemp = variant.rinseInfusions.isNotEmpty
                    ? variant.rinseInfusions.last.tempMin
                    : (variant.infusions.isNotEmpty
                        ? variant.infusions.first.tempMin
                        : 80);
                final updated = List<InfusionSpec>.from(variant.rinseInfusions)
                  ..add(InfusionSpec(
                      tempMin: lastTemp,
                      steepTime: const Duration(seconds: 15)));
                onChanged(variant.copyWith(rinseInfusions: updated));
              },
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSurfaceVariant,
                textStyle: textTheme.labelSmall,
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('+ Rinse'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (variant.rinseInfusions.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              'Noch kein Rinse-Aufguss definiert.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          ...variant.rinseInfusions.asMap().entries.map((e) => _InfusionRow(
                key: ValueKey(e.value.id),
                index: e.key,
                spec: e.value,
                gongFu: true,
                onChanged: (s) {
                  final list = List<InfusionSpec>.from(variant.rinseInfusions);
                  list[e.key] = s;
                  onChanged(variant.copyWith(rinseInfusions: list));
                },
                onDelete: () {
                  final list = List<InfusionSpec>.from(variant.rinseInfusions)
                    ..removeAt(e.key);
                  onChanged(variant.copyWith(rinseInfusions: list));
                },
              )),
      ],
    );
  }
}

// Aufguss-Zeile

class _InfusionRow extends StatefulWidget {
  final int index;
  final InfusionSpec spec;
  final bool gongFu;
  final ValueChanged<InfusionSpec> onChanged;
  final VoidCallback onDelete;

  const _InfusionRow({
    super.key,
    required this.index,
    required this.spec,
    required this.gongFu,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_InfusionRow> createState() => _InfusionRowState();
}

class _InfusionRowState extends State<_InfusionRow> {
  late TextEditingController _temp;
  late TextEditingController _timeSecs;
  late TextEditingController _timeMins;
  late TextEditingController _timeSecsSplit;

  @override
  void initState() {
    super.initState();
    _temp = TextEditingController(text: widget.spec.tempMin.toString());
    _timeSecs = TextEditingController(
      text: widget.spec.steepTime.inSeconds.toString(),
    );
    _timeMins = TextEditingController(
      text: widget.spec.steepTime.inMinutes.remainder(60).toString(),
    );
    _timeSecsSplit = TextEditingController(
      text: widget.spec.steepTime.inSeconds.remainder(60).toString(),
    );
  }

  @override
  void didUpdateWidget(_InfusionRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spec.id != widget.spec.id) {
      _temp.text = widget.spec.tempMin.toString();
      _timeSecs.text = widget.spec.steepTime.inSeconds.toString();
      _timeMins.text = widget.spec.steepTime.inMinutes.remainder(60).toString();
      _timeSecsSplit.text = widget.spec.steepTime.inSeconds.remainder(60).toString();
    }
  }

  @override
  void dispose() {
    _temp.dispose();
    _timeSecs.dispose();
    _timeMins.dispose();
    _timeSecsSplit.dispose();
    super.dispose();
  }

  void _update() {
    final tempVal = int.tryParse(_temp.text) ?? widget.spec.tempMin;
    final Duration steep;
    if (widget.gongFu) {
      steep = Duration(seconds: int.tryParse(_timeSecs.text) ?? 30);
    } else {
      steep = Duration(
        minutes: int.tryParse(_timeMins.text) ?? 0,
        seconds: int.tryParse(_timeSecsSplit.text) ?? 0,
      );
    }
    widget.onChanged(widget.spec.copyWith(tempMin: tempVal, steepTime: steep));
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
          Expanded(
            child: TextField(
              controller: _temp,
              decoration: const InputDecoration(
                labelText: '°C',
                contentPadding: EdgeInsets.zero,
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _update(),
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
