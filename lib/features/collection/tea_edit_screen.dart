import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:steapleaf/features/collection/widgets/tasting_profile_editor.dart';
import 'package:steapleaf/shared/widgets/star_rating.dart';
import 'package:steapleaf/shared/widgets/tag_editor.dart';
import 'package:steapleaf/shared/widgets/tea_type_selector.dart';
import 'package:steapleaf/shared/widgets/toggle_row.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/infusion_spec.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/variant_editor.dart';
import 'tea_provider.dart';
import '../../theme/steapleaf_theme.dart';
import '../../domain/models/tea.dart';
import '../../domain/models/brew_variant.dart';
import '../../domain/models/tasting_profile.dart';
import '../../domain/enums/enums.dart';

class TeaEditScreen extends StatefulWidget {
  final Tea? tea;
  const TeaEditScreen({super.key, this.tea});

  @override
  State<TeaEditScreen> createState() => _TeaEditScreenState();
}

class _TeaEditScreenState extends State<TeaEditScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _origin;
  late final TextEditingController _vendor;
  late final TextEditingController _notes;

  late TeaType _type;
  late bool _inStock;
  late bool _isFavorite;
  late int _rating;
  late List<String> _tags;
  late TastingProfile _tasting;
  late List<BrewVariant> _variants;
  String? _defaultVariantId;
  String? _photoTeaPath;
  String? _photoLabelPath;

  final _picker = ImagePicker();
  bool _hasChanges = false;
  bool _tastingModified = false;

  bool get _hasTastingContent => _tastingModified;
  bool get _hasVariantContent => _variants.isNotEmpty;

  void _set(VoidCallback fn) => setState(() {
        fn();
        _hasChanges = true;
      });

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this)
      ..addListener(() => setState(() {}));
    final t = widget.tea;
    _name = TextEditingController(text: t?.name ?? '');
    _origin = TextEditingController(text: t?.origin ?? '');
    _vendor = TextEditingController(text: t?.vendor ?? '');
    _notes = TextEditingController(text: t?.notes ?? '');
    _type = t?.type ?? TeaType.green;
    _inStock = t?.inStock ?? true;
    _isFavorite = t?.isFavorite ?? false;
    _rating = t?.rating ?? 0;
    _tags = List.from(t?.tags ?? []);
    _tasting = t?.tastingProfile ?? const TastingProfile();
    _tastingModified = t?.tastingProfile != null;
    _variants = List.from(t?.brewVariants ?? []);
    _defaultVariantId = t?.defaultVariantId;
    _photoTeaPath = t?.photoTeaPath;
    _photoLabelPath = t?.photoLabelPath;
  }

  @override
  void dispose() {
    _tabs.dispose();
    _name.dispose();
    _origin.dispose();
    _vendor.dispose();
    _notes.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isNew = widget.tea == null;

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await _confirmDiscard(context);
        if (leave && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${SteapLeafKanji.tea.character} · ${isNew ? 'Neuer Tee' : 'Tee bearbeiten'}',
            style: textTheme.titleLarge,
          ),
          bottom: TabBar(
            controller: _tabs,
            tabs: [
              _TabLabel('基', 'Basis', hasDot: false),
              _TabLabel('味', 'Verkostung', hasDot: _hasTastingContent),
              _TabLabel('法', 'Zubereitung', hasDot: _hasVariantContent),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                onChanged: () => setState(() => _hasChanges = true),
                child: TabBarView(
                  controller: _tabs,
                  children: [
                    _buildBasisTab(context, colorScheme, textTheme),
                    _buildVerkostungTab(context, textTheme),
                    _buildZubereitungTab(context, colorScheme, textTheme),
                  ],
                ),
              ),
            ),
            ActionBar(
              children: [
                ActionBarButton.secondary(
                  label: 'Abbrechen',
                  onPressed: () async {
                    if (!_hasChanges) {
                      Navigator.pop(context);
                      return;
                    }
                    final leave = await _confirmDiscard(context);
                    if (leave && context.mounted) Navigator.pop(context);
                  },
                ),
                ActionBarButton.primary(
                  label: '${SteapLeafKanji.save.character}  Speichern',
                  onPressed: _save,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Tabs ───────────────────────────────────────────────────────────────────

  Widget _buildBasisTab(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final favoriteColor =
        Theme.of(context).extension<SteapLeafThemeExtension>()?.favorite ??
            colorScheme.primary;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        // Fotos
        Text('画像  · Bilder', style: textTheme.labelSmall),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _PhotoCard(
                label: 'Etikett',
                path: _photoLabelPath,
                hint: 'Nur zum Nachschlagen\nOCR geplant',
                onTap: () => _pickPhoto(
                  _photoLabelPath,
                  (p) => _set(() => _photoLabelPath = p),
                ),
                onRemove: _photoLabelPath != null
                    ? () => _set(() => _photoLabelPath = null)
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PhotoCard(
                label: 'Tee-Foto',
                path: _photoTeaPath,
                onTap: () => _pickPhoto(
                  _photoTeaPath,
                  (p) => _set(() => _photoTeaPath = p),
                ),
                onRemove: _photoTeaPath != null
                    ? () => _set(() => _photoTeaPath = null)
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Basisdaten
        Text('基  · Basisdaten', style: textTheme.labelSmall),
        const SizedBox(height: 12),
        WashiCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name *'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Pflichtfeld' : null,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              Text('Teesorte', style: textTheme.labelSmall),
              const SizedBox(height: 6),
              TeaTypeSelector(
                selected: _type,
                onChanged: (t) => _set(() => _type = t),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _origin,
                decoration: const InputDecoration(
                  labelText: 'Herkunft / Anbaugebiet',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _vendor,
                decoration: const InputDecoration(
                  labelText: 'Händler / Hersteller',
                ),
              ),
              const SizedBox(height: 4),
              ToggleRow(
                label: 'Im Besitz',
                value: _inStock,
                onChanged: (v) => _set(() => _inStock = v),
              ),
              Divider(
                  height: 1, thickness: 0.5, color: colorScheme.outlineVariant),
              const SizedBox(height: 10),
              Text('Tags', style: textTheme.labelSmall),
              const SizedBox(height: 6),
              TagEditor(
                tags: _tags,
                onChanged: (v) => _set(() => _tags = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Bewertung
        Text('評価  · Bewertung', style: textTheme.labelSmall),
        const SizedBox(height: 12),
        WashiCard(
          child: Row(
            children: [
              StarRating(
                rating: _rating,
                onChanged: (v) => _set(() => _rating = v),
              ),
              const Spacer(),
              ToggleRow(
                label: 'Favorit',
                value: _isFavorite,
                icon: Icons.favorite_outline,
                activeIcon: Icons.favorite,
                activeColor: favoriteColor,
                onChanged: (v) => _set(() => _isFavorite = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Notizen
        Text('覚書 · Notizen', style: textTheme.labelSmall),
        const SizedBox(height: 12),
        WashiCard(
          child: TextFormField(
            controller: _notes,
            decoration: const InputDecoration(
              hintText: 'Persönliche Notizen …',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            maxLines: 4,
            minLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildVerkostungTab(BuildContext context, TextTheme textTheme) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text('味 · Verkostungsprofil', style: textTheme.labelSmall),
        const SizedBox(height: 12),
        TastingProfileEditor(
          profile: _tasting,
          onChanged: (p) => _set(() {
            _tasting = p;
            _tastingModified = true;
          }),
        ),
      ],
    );
  }

  Widget _buildZubereitungTab(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Row(
          children: [
            Text('淹れ方 · Zubereitungsart', style: textTheme.labelSmall),
            const Spacer(),
            TextButton(
              onPressed: _addVariant,
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSurfaceVariant,
                textStyle: textTheme.labelSmall,
                minimumSize: Size.zero,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('+ Variante'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_variants.isEmpty)
          WashiCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Noch keine Brühvariante definiert.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          )
        else
          ..._variants.asMap().entries.map(
            (e) => VariantEditor(
              variant: e.value,
              index: e.key,
              isDefault: _defaultVariantId == e.value.id,
              onSetDefault: () => _set(() {
                _defaultVariantId =
                    _defaultVariantId == e.value.id ? null : e.value.id;
              }),
              onChanged: (v) => _set(() => _variants[e.key] = v),
              onDelete: () => _set(() {
                if (_defaultVariantId == e.value.id) {
                  _defaultVariantId = _variants.length > 1
                      ? _variants.firstWhere((v) => v.id != e.value.id).id
                      : null;
                }
                _variants.removeAt(e.key);
              }),
            ),
          ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: _addVariant,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Variante hinzufügen'),
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.onSurfaceVariant,
            textStyle: textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  // ── Aktionen ───────────────────────────────────────────────────────────────

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      _tabs.animateTo(0);
      return;
    }
    final provider = context.read<TeaProvider>();
    final tea = Tea(
      id: widget.tea?.id ?? const Uuid().v4(),
      name: _name.text.trim(),
      type: _type,
      origin: _origin.text.trim().isEmpty ? null : _origin.text.trim(),
      vendor: _vendor.text.trim().isEmpty ? null : _vendor.text.trim(),
      inStock: _inStock,
      isFavorite: _isFavorite,
      rating: _rating,
      tags: _tags,
      tastingProfile: _tasting,
      brewVariants: _variants,
      defaultVariantId: _defaultVariantId,
      photoTeaPath: _photoTeaPath,
      photoLabelPath: _photoLabelPath,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      createdAt: widget.tea?.createdAt ?? DateTime.now(),
    );
    if (widget.tea == null) {
      await provider.addTea(tea);
    } else {
      await provider.updateTea(tea);
    }
    if (mounted) Navigator.pop(context);
  }

  void _addVariant() {
    final id = const Uuid().v4();
    _set(() {
      _variants.add(
        BrewVariant(
          id: id,
          label: BrewStyle.western.label,
          style: BrewStyle.western,
          infusions: [
            InfusionSpec(
              tempMin: _type.defaultTemp,
              tempMax: _type.defaultTemp,
              steepTime: _type.defaultSteepTime,
            ),
          ],
        ),
      );
      _defaultVariantId ??= id;
    });
    // Zum Zubereitung-Tab springen wenn noch nicht aktiv
    if (_tabs.index != 2) _tabs.animateTo(2);
  }

  Future<void> _pickPhoto(
    String? currentPath,
    ValueChanged<String?> onPick,
  ) async {
    final colorScheme = Theme.of(context).colorScheme;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galerie'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            if (currentPath != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: colorScheme.error),
                title: Text(
                  'Entfernen',
                  style: TextStyle(color: colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  onPick(null);
                },
              ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 75,
      );
      if (file != null) onPick(file.path);
    } on PlatformException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kamerazugriff verweigert')),
        );
      }
    }
  }

  Future<bool> _confirmDiscard(BuildContext context) => ConfirmDialog.show(
        context,
        title: 'Änderungen verwerfen?',
        message: 'Nicht gespeicherte Änderungen gehen verloren.',
      );
}

// ── Tab-Label mit optionalem Dot-Indikator ────────────────────────────────

class _TabLabel extends StatelessWidget {
  final String kanji;
  final String label;
  final bool hasDot;

  const _TabLabel(this.kanji, this.label, {required this.hasDot});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$kanji · $label'),
          if (hasDot) ...[
            const SizedBox(width: 5),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Foto-Karte ─────────────────────────────────────────────────────────────

class _PhotoCard extends StatelessWidget {
  final String label;
  final String? path;
  final String? hint;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const _PhotoCard({
    required this.label,
    required this.path,
    required this.onTap,
    this.hint,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return WashiCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: path != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRect(
                    child: Image.file(
                      File(path!),
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  if (onRemove != null)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          color: colorScheme.error,
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      size: 28,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (hint != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        hint!,
                        textAlign: TextAlign.center,
                        style: textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
