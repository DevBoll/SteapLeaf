
abstract final class SteapLeafSpacing {
  SteapLeafSpacing._();

  // Basis-Skala 
  
  /// 2dp – Icon-zu-Text innerhalb eines Buttons
  static const double micro = 2.0;

  /// 4dp – Chip-Padding, Badge, Stern-Abstand
  static const double tiny  = 4.0;

  /// 8dp – Label zu Feld, Icon zu Text in Listen
  static const double xs    = 8.0;

  /// 12dp – Listeneinträge-Gap, Chip-Gruppen-Gap
  static const double sm    = 12.0;

  /// 16dp – Screen-Padding (horizontal), Card-Innenabstand
  static const double md    = 16.0;

  /// 24dp – Section-Abstände, großzügige Cards
  static const double lg    = 24.0;

  /// 32dp – Abstände zwischen Sections
  static const double xl    = 32.0;

  /// 48dp – Screen-Top-Padding, großer Leerraum vor Titeln
  static const double xxl   = 48.0;

  // Layout-Spezifische Tokens

  /// Seitlicher Innenabstand aller Screens (M3-Standard)
  static const double screenPaddingHorizontal = md;

  /// Innenabstand aller Cards
  static const double cardPadding = md;

  /// Abstand Section-Label zu erstem Feld (AROMA, GESCHMACK etc.)
  static const double sectionLabelMarginBottom = xs;

  /// Abstand zwischen zwei Formular-Feldern
  static const double formFieldGap = sm;

  /// Abstand zwischen Sections in Create/Edit-Screens
  static const double sectionGap = xl;

  // Komponenten-Größen

  /// Standard-Höhe von Listen-Einträgen (Teesammlung, Session-Liste)
  static const double listItemHeight = 72.0;

  /// Höhe der fixierten Aktionsleiste (Abbrechen / Speichern)
  static const double bottomBarHeight = 80.0;

  /// Höhe einer einzelnen Floating-Timer-Bar
  static const double timerBarHeight = 56.0;

  /// Standard-FAB-Größe
  static const double fabSize = 56.0;

  /// Tee-Avatar Durchmesser in Listen
  static const double avatarSize = 48.0;

  /// Tee-Avatar Durchmesser auf Detailseite (Hero)
  static const double avatarSizeHero = 80.0;

  /// Mindest-Touch-Target (M3-Pflicht: 48×48dp)
  static const double minTouchTarget = 48.0;

  /// Höhe des Step-Indikators im Session-Flow
  static const double stepIndicatorHeight = 3.0;

  /// Höhe der Handwriting-Underline unter Screen-Titeln
  static const double brandLineHeight = 2.0;

  /// Abstand vom Titel zur Handwriting-Underline
  static const double brandLineMarginTop = 4.0;
}
