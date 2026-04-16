import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steapleaf/features/collection/tea_edit_screen.dart';
import 'package:steapleaf/features/collection/tea_provider.dart';

import '../../domain/models/brew_variant.dart';
import '../../domain/models/tea.dart';
import '../../shared/widgets/brew_variant_card.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/star_rating.dart';
import '../../shared/widgets/tea_type_chip.dart';
import '../../theme/steapleaf_theme.dart';
import 'widgets/tasting_profile_view.dart';


class TeaDetailScreen extends StatelessWidget {
  final String teaId;
  const TeaDetailScreen({super.key, required this.teaId, required Tea tea});

  @override
  Widget build(BuildContext context) {
    return Consumer<TeaProvider>(builder: (context, provider, _) {
      final tea = provider.getById(teaId);
      if (tea == null) {
        return const Scaffold(
          body: Center(child: Text('Tee nicht gefunden')),
        );
      }
      return _TeaDetailView(tea: tea);
    });
  }
}

class _TeaDetailView extends StatelessWidget {
  final Tea tea;
  const _TeaDetailView({required this.tea});

  void _startBrew(BuildContext context, BrewVariant v) {
    // TODO: Session-Flow verknüpfen
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme   = Theme.of(context).textTheme;

    final hasTasting = tea.tastingProfile.isNotEmpty;
    final hasNotes   = tea.notes?.isNotEmpty == true;

    return Scaffold(
      appBar: AppBar(
        title: Text('${tea.type.kanji} · ${tea.name}', style: textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, size: 20,
                color: colorScheme.onSurfaceVariant),
            tooltip: 'Bearbeiten',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TeaEditScreen(tea: tea)),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 20,
                color: colorScheme.onSurfaceVariant),
            tooltip: 'Löschen',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            onPressed: () => _confirmDelete(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 0.5,
            color: colorScheme.outlineVariant,
          ),
        ),
      ),
      bottomNavigationBar: ActionBar(
        children: [
          ActionBarButton.primary(
            label: '${SteapLeafKanji.sessionStart.character} · Session starten',
            onPressed: null, // TODO: Session-Flow verknüpfen
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          // Tee-Details
          _MetaCard(tea: tea),
          const SizedBox(height: 14),

          // Verkostungsprofil
          if (hasTasting) ...[
            Text('味 · Verkostungsprofil', style: textTheme.labelSmall),
            const SizedBox(height: 12),
            TastingProfileView(profile: tea.tastingProfile),
            const SizedBox(height: 14),
          ],

          // Notizen
          if (hasNotes) ...[
            Text('記 · Notizen', style: textTheme.labelSmall),
            const SizedBox(height: 12),
            WashiCard(
              child: Text(
                tea.notes!,
                style: textTheme.bodySmall?.copyWith(
                  height: 1.7,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Brühvarianten
          Text('法 · Brühvarianten', style: textTheme.labelSmall),
          const SizedBox(height: 12),
          if (tea.brewVariants.isEmpty)
            WashiCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Noch keine Brühvariante angelegt.',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TeaEditScreen(tea: tea)),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Variante anlegen'),
                  ),
                ],
              ),
            )
          else
            ...tea.brewVariants.map(
              (v) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: BrewVariantCard(
                  tea: tea,
                  variant: v,
                  onTap: () => _startBrew(context, v),
                ),
              ),
            ),

          // Etikett-Foto (ausklappbar)
          if (tea.photoLabelPath != null) ...[
            const SizedBox(height: 8),
            _LabelPhotoSection(path: tea.photoLabelPath!),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Tee löschen?',
      message: '„${tea.name}" wird dauerhaft entfernt. Deine Sessions bleiben erhalten.',
      confirmLabel: 'Löschen',
      cancelLabel: 'Abbrechen',
    );
    if (confirmed && context.mounted) {
      context.read<TeaProvider>().deleteTea(tea.id);
      Navigator.pop(context);
    }
  }
}


class _MetaCard extends StatelessWidget {
  final Tea tea;
  const _MetaCard({required this.tea});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme   = Theme.of(context).textTheme;
    final ext = Theme.of(context).extension<SteapLeafThemeExtension>()!;

    return WashiCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tee-Bild
          ClipRect(child: _TeaImage(tea: tea)),

          // Inhalt
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sorte-Chip + Besitz
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TeaTypeChip(type: tea.type),
                    const Spacer(),
                    _StockBadge(inStock: tea.inStock),
                  ],
                ),
                const SizedBox(height: 8),

                // Tee-Name
                Text(
                  tea.name,
                  style: textTheme.bodyMedium?.copyWith(
                    letterSpacing: 0.2,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),

                // Herkunft
                if (tea.origin?.isNotEmpty == true) ...[
                  _IconRow(
                    icon: Icons.place_outlined,
                    text: tea.origin!,
                  ),
                  const SizedBox(height: 3),
                ],

                // Händler
                if (tea.vendor?.isNotEmpty == true)
                  _IconRow(
                    icon: Icons.storefront_outlined,
                    text: tea.vendor!,
                  ),

                // Bewertung + Favorit
                DashedDivider(
                  color: colorScheme.outlineVariant,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (tea.rating > 0)
                      StarRating(rating: tea.rating, size: 14)
                    else
                      Text(
                        'Nicht bewertet',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 0.2,
                        ),
                      ),
                    const Spacer(),
                    if (tea.isFavorite)
                      Icon(
                        Icons.favorite,
                        color: ext.favorite,
                        size: 16,
                      ),
                  ],
                ),

                // Tags
                if (tea.tags.isNotEmpty) ...[
                  DashedDivider(
                    color: colorScheme.outlineVariant,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: tea.tags.map(_TagChip.new).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeaImage extends StatelessWidget {
  final Tea tea;
  const _TeaImage({required this.tea});

  static const _height = 160.0;

  @override
  Widget build(BuildContext context) {
    if (tea.photoTeaPath != null) {
      return SizedBox(
        height: _height,
        width: double.infinity,
        child: Image.file(
          File(tea.photoTeaPath!),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _Placeholder(tea: tea),
        ),
      );
    }
    return _Placeholder(tea: tea);
  }
}

class _Placeholder extends StatelessWidget {
  final Tea tea;
  const _Placeholder({required this.tea});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _TeaImage._height,
      width: double.infinity,
      color: tea.type.color.withValues(alpha: 0.12),
      child: Center(
        child: Text(
          tea.type.kanji,
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w200,
            color: tea.type.color.withValues(alpha: 0.55),
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final bool inStock;
  const _StockBadge({required this.inStock});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor  = inStock ? colorScheme.primary : colorScheme.outlineVariant;
    final textColor    = inStock ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          inStock ? 'Vorrätig' : 'Aufgebraucht',
          style: TextStyle(
            fontSize: 9,
            letterSpacing: 0.8,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _IconRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme   = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;
  const _TagChip(this.tag, {super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme   = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          '#$tag',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _LabelPhotoSection extends StatefulWidget {
  final String path;
  const _LabelPhotoSection({required this.path});

  @override
  State<_LabelPhotoSection> createState() => _LabelPhotoSectionState();
}

class _LabelPhotoSectionState extends State<_LabelPhotoSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme   = Theme.of(context).textTheme;

    return WashiCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kopfzeile
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Text('写 · Etikett', style: textTheme.labelSmall),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Foto
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashedDivider(
                  color: colorScheme.outlineVariant,
                  padding: EdgeInsets.zero,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: ClipRect(
                    child: Image.file(
                      File(widget.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(Icons.broken_image_outlined,
                            color: colorScheme.onSurfaceVariant),
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
