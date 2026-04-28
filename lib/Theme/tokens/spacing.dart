import 'package:flutter/material.dart';

abstract final class SteapLeafSpacing {
  SteapLeafSpacing._();

  /// 2dp – Icon-zu-Text innerhalb eines Buttons
  static const double xxs = 2;
  /// 4dp – Chip-Padding, Badge, Stern-Abstand
  static const double xs = 4;
  /// 8dp – Label zu Feld, Icon zu Text in Listen
  static const double sm = 8;
  /// 12dp – Listeneinträge-Gap, Chip-Gruppen-Gap
  static const double md = 12;
  /// 16dp – Screen-Padding (horizontal), Card-Innenabstand
  static const double lg = 16;
  /// 24dp – Section-Abstände, großzügige Cards
  static const double xl = 24;
  /// 32dp – Abstände zwischen Sections
  static const double xxl = 32;
  /// 48dp – Screen-Top-Padding, großer Leerraum vor Titeln
  static const double xxxl = 48;

   /// Seitlicher Innenabstand aller Screens (M3-Standard)
  static const EdgeInsets screenPadding = EdgeInsets.all(lg);

  static const EdgeInsets allSm = EdgeInsets.all(sm);
  static const EdgeInsets allMd = EdgeInsets.all(md);
  static const EdgeInsets allLg = EdgeInsets.all(lg);
  static const EdgeInsets allXl = EdgeInsets.all(xl);

  static const EdgeInsets screenWithBottomAction = EdgeInsets.fromLTRB(
    lg, lg, lg, xxl,
  );

  static const EdgeInsets card = EdgeInsets.all(lg);
  static const EdgeInsets cardCompact = EdgeInsets.all(sm);

  static const EdgeInsets listItem = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );


 }

abstract final class SteapLeafSizes {
  SteapLeafSizes._();

  /// Mindest-Touch-Target (M3-Pflicht: 48×48dp)
  static const double minTouchTarget = 48.0;

  /// Höhe der fixierten Aktionsleiste (Abbrechen / Speichern)
  static const double bottomBarHeight = 80.0;

  /// Höhe einer einzelnen Floating-Bar oder AppBar
  static const double barHeight = 56.0;

  /// Höhe für Inputs
  static const double inputHeight = 56; 

  /// Icons
  static const double iconSm = 16;
  static const double iconMd = 24;          
  static const double iconLg = 32;
  static const double iconXl = 48;

  /// Avatars
  static const double avatarSm = 32;
  static const double avatarMd = 40;
  static const double avatarLg = 56;
  static const double avatarXl = 80;
}
