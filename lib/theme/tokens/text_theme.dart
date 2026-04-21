import 'package:flutter/material.dart';


abstract final class SteapLeafTextTheme {
  SteapLeafTextTheme._();

  // Font Families 

  static const String serifFamily = 'NotoSerifJP';
  static const String bodyFamily  = 'NotoSansJP';
  static const String monoFamily  = 'DMMono';

  // Kanji-Größen 

  /// Kleine Kanji-Icons neben Labels
  static const double kanjiIconSize      = 20.0;

  /// FAB-Kanji
  static const double kanjiIconLargeSize = 28.0;

  /// Kanji im Tee-Avatar
  static const double kanjiHeroSize      = 64.0;

  /// Großes dekoratives Kanji
  static const double kanjiDecorativeSize = 96.0;

  static TextStyle get displayLarge => const TextStyle(
    fontFamily: serifFamily,
    fontSize: 40, fontWeight: FontWeight.w300,
    letterSpacing: -0.5, height: 1.1,
  );

  static TextStyle get headlineLarge => const TextStyle(
    fontFamily: serifFamily,
    fontSize: 32, fontWeight: FontWeight.w300,
    letterSpacing: -0.5, height: 1.1,
  );

  static TextStyle get headlineMedium => const TextStyle(
    fontFamily: serifFamily,
    fontSize: 26, fontWeight: FontWeight.w400,
    letterSpacing: -0.3, height: 1.15,
  );

  static TextStyle get headlineSmall => const TextStyle(
    fontFamily: serifFamily,
    fontSize: 22, fontWeight: FontWeight.w400,
    letterSpacing: -0.2, height: 1.2,
  );

  static TextStyle get titleLarge => const TextStyle(
    fontFamily: bodyFamily,
    fontSize: 20, fontWeight: FontWeight.w500,
    letterSpacing: 0, height: 1.3,
  );

  static TextStyle get titleMedium => const TextStyle(
    fontFamily: bodyFamily,
    fontSize: 16, fontWeight: FontWeight.w600,
    letterSpacing: 0.1, height: 1.4,
  );

  static TextStyle get titleSmall => const TextStyle(
    fontFamily: bodyFamily,
    fontSize: 14, fontWeight: FontWeight.w600,
    letterSpacing: 0.1, height: 1.4,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: bodyFamily,
    fontSize: 16, fontWeight: FontWeight.w400,
    letterSpacing: 0.1, height: 1.6,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: bodyFamily,
    fontSize: 14, fontWeight: FontWeight.w400,
    letterSpacing: 0.1, height: 1.5,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12, fontWeight: FontWeight.w400,
    letterSpacing: 0.2, height: 1.4,
  );

  static TextStyle get labelLarge => const TextStyle(
    fontFamily: bodyFamily,
    fontSize: 14, fontWeight: FontWeight.w600,
    letterSpacing: 0.1, height: 1.3,
  );

  static TextStyle get labelMedium => const TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12, fontWeight: FontWeight.w500,
    letterSpacing: 0.3, height: 1.3,
  );

  static TextStyle get labelSmall => const TextStyle(
    fontFamily: monoFamily,
    fontSize: 11, fontWeight: FontWeight.w500,
    letterSpacing: 0.2, height: 1.3,
  );

  // SteapLeaf Custom Styles

  /// Für Section-Labels in Großbuchstaben (AROMA, KIROKU, KURA)
  static TextStyle get sectionLabel => const TextStyle(
    fontFamily: monoFamily,
    fontSize: 10, fontWeight: FontWeight.w500,
    letterSpacing: 0.2, height: 1.2,
  );

  /// Für Brühparameter-Werte (70°C, 02:00, 3g)
  static TextStyle get brewParameter => const TextStyle(
    fontFamily: monoFamily,
    fontSize: 13, fontWeight: FontWeight.w400,
    letterSpacing: 0.05, height: 1.4,
  );

  /// Kanji in Avatar-Kreisen
  static TextStyle kanjiAvatar({double? size}) => TextStyle(
    fontFamily: serifFamily,
    fontSize: size ?? kanjiHeroSize,
    fontWeight: FontWeight.w300,
    height: 1.0,
  );

  // Flutter TextTheme 

  /// Vollständiges [TextTheme] für ThemeData.
  static TextTheme get textTheme => TextTheme(
    displayLarge:   displayLarge,
    displayMedium:  headlineLarge,
    displaySmall:   headlineMedium,
    headlineLarge:  headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall:  headlineSmall,
    titleLarge:     titleLarge,
    titleMedium:    titleMedium,
    titleSmall:     titleSmall,
    bodyLarge:      bodyLarge,
    bodyMedium:     bodyMedium,
    bodySmall:      bodySmall,
    labelLarge:     labelLarge,
    labelMedium:    labelMedium,
    labelSmall:     labelSmall,
  );
}
