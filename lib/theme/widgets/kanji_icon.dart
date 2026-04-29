import 'package:flutter/material.dart';
import '../tokens/kanji_tokens.dart';
import '../tokens/text_theme.dart';


enum KanjiSize {
  /// 10sp · Neben Section-Labels (味 · GESCHMACK)
  sectionLabel(12),

  /// 20sp · In Buttons, Breadcrumbs, Inline-Labels (始 · SESSION)
  icon(SteapLeafTextTheme.kanjiIconSize),

  /// 28sp · Im FAB (新, 録)
  fab(SteapLeafTextTheme.kanjiIconLargeSize),

  /// 64sp · Im Avatar-Kreis (緑, 青)
  avatar(SteapLeafTextTheme.kanjiHeroSize),

  /// 96sp · Großes dekoratives Kanji (茶)
  decorative(SteapLeafTextTheme.kanjiDecorativeSize);

  const KanjiSize(this.fontSize);

  /// Font-Größe in sp.
  final double fontSize;
}

class KanjiIcon extends StatelessWidget {
  const KanjiIcon(
    this.kanji, {
    super.key,
    this.size = KanjiSize.icon,
    this.color,
    this.opacity,
    this.role,
    this.semanticLabelOverride,
    this.fontWeight,
  });

  
  final KanjiDefinition kanji;
  final KanjiSize size;
  final Color? color;
  final double? opacity;
  final KanjiRole? role;
  final String? semanticLabelOverride;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final effectiveRole = role ?? kanji.defaultRole;
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurface;
    final effectiveOpacity = opacity ?? _defaultOpacity(effectiveRole);
    final effectiveWeight = fontWeight ?? _defaultWeight(effectiveRole);

    final textWidget = Text(
      kanji.character,
      style: TextStyle(
        fontFamily: SteapLeafTextTheme.serifFamily,
        fontSize: size.fontSize,
        fontWeight: effectiveWeight,
        color: effectiveColor.withValues(alpha: effectiveOpacity),
        height: 1.0,
        // Kein letterSpacing – Kanji braucht den natürlichen Zeichenabstand
        decoration: TextDecoration.none,
      ),
    );

    return switch (effectiveRole) {
      // Dekorativ: aus Semantik-Tree ausschließen
      KanjiRole.decorative => ExcludeSemantics(child: textWidget),

      // Navigatorisch: semanticLabel setzen, aber kein eigenes Semantik-Objekt
      // (das umgebende NavigationDestination / Tab hat bereits ein Label)
      KanjiRole.navigational => ExcludeSemantics(child: textWidget),

      // Funktional & Taxonomisch: semanticLabel setzen
      KanjiRole.functional || KanjiRole.taxonomic => Semantics(
          label: semanticLabelOverride ?? kanji.semanticLabel,
          child: textWidget,
        ),
    };
  }

  /// Standard-Deckkraft abhängig von der Rolle.
  double _defaultOpacity(KanjiRole role) => switch (role) {
        KanjiRole.decorative  => 0.07, // Sehr dezent im Hintergrund
        KanjiRole.navigational => 0.9,
        KanjiRole.functional  => 1.0,
        KanjiRole.taxonomic   => 1.0,
      };

  /// Standard-Fontgewicht abhängig von der Größe und Rolle.
  FontWeight _defaultWeight(KanjiRole role) => switch (role) {
        KanjiRole.decorative  => FontWeight.w300,
        KanjiRole.navigational => FontWeight.w400,
        KanjiRole.functional  => FontWeight.w400,
        KanjiRole.taxonomic   => FontWeight.w300,
      };
}

// KanjiLabel Widget

class KanjiLabel extends StatelessWidget {
  const KanjiLabel({
    super.key,
    required this.kanji,
    required this.label,
    this.kanjiSize = KanjiSize.sectionLabel,
    this.color,
    this.gap = 6.0,
  });

  final KanjiDefinition kanji;

  /// Text-Label (wird automatisch uppercased dargestellt).
  final String label;

  final KanjiSize kanjiSize;

  /// Farbe für Kanji und Text. Standard: onSurfaceVariant.
  final Color? color;

  /// Horizontaler Abstand zwischen Kanji und Text.
  final double gap;

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ?? Theme.of(context).colorScheme.onSurfaceVariant;

    return Semantics(
      label: kanji.semanticLabel,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            KanjiIcon(
              kanji,
              size: kanjiSize,
              color: effectiveColor,
              role: KanjiRole.decorative, // im Label-Kontext ist es dekorativ
            ),
            SizedBox(width: gap),
            Text(
              '· $label',
              style: SteapLeafTextTheme.labelMedium.copyWith(
                color: effectiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// KanjiAvatar Widget

class KanjiAvatar extends StatelessWidget {
  const KanjiAvatar({
    super.key,
    required this.kanji,
    required this.containerColor,
    required this.onContainerColor,
    this.size = 48.0,
    this.semanticLabel,
    this.imageProvider,
  });

  final KanjiDefinition kanji;
  final Color containerColor;
  final Color onContainerColor;

  /// Durchmesser des Avatars in dp.
  final double size;

  /// Überschreibt das semanticLabel (z.B. Tee-Name statt Teetyp).
  final String? semanticLabel;

  /// Optionales Foto. Wenn gesetzt, wird das Kanji nicht angezeigt.
  final ImageProvider? imageProvider;

  @override
  Widget build(BuildContext context) {
    final kanjiFontSize = size * 0.55; // Kanji nimmt 55% des Avatars ein

    return Semantics(
      label: semanticLabel ?? kanji.semanticLabel,
      image: imageProvider != null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: containerColor,
          shape: BoxShape.circle,
          image: imageProvider != null
              ? DecorationImage(
                  image: imageProvider!,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        alignment: Alignment.center,
        child: imageProvider == null
            ? ExcludeSemantics(
                child: Text(
                  kanji.character,
                  style: TextStyle(
                    fontFamily: SteapLeafTextTheme.serifFamily,
                    fontSize: kanjiFontSize,
                    fontWeight: FontWeight.w300,
                    color: onContainerColor,
                    height: 1.0,
                    decoration: TextDecoration.none,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

// KanjiBreadcrumb Widget

class KanjiBreadcrumb extends StatelessWidget {
  const KanjiBreadcrumb({
    super.key,
    required this.kanji,
    required this.label,
    this.onTap,
  });

  final KanjiDefinition kanji;
  final String label;

  /// Optionaler Tap-Handler (z.B. für Navigation zur übergeordneten Seite).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        KanjiIcon(
          kanji,
          size: KanjiSize.sectionLabel,
          color: color,
          role: KanjiRole.decorative,
        ),
        const SizedBox(width: 6),
        Text(
          '· $label',
          style: SteapLeafTextTheme.labelMedium.copyWith(color: color),
        ),
      ],
    );

    if (onTap == null) {
      return Semantics(
        label: '${kanji.semanticLabel}: $label',
        child: ExcludeSemantics(child: content),
      );
    }

    return Semantics(
      label: '${kanji.semanticLabel}: $label',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ExcludeSemantics(child: content),
        ),
      ),
    );
  }
}
