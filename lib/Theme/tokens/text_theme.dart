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

  static TextStyle get headlineMedium => const TextStyle(
    fontFamily: serifFamily,
    fontSize: 26, fontWeight: FontWeight.w400,
    letterSpacing: -0.3, height: 1.15,
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

  // SteapLeaf Custom Styles
  static TextStyle kanjiAvatar({double? size}) => TextStyle(
    fontFamily: serifFamily,
    fontSize: size ?? kanjiHeroSize,
    fontWeight: FontWeight.w300,
    height: 1.0,
  );

  /// Vollständiges [TextTheme] für ThemeData.
  static TextTheme get textTheme => TextTheme(
    displaySmall:   headlineMedium,
    headlineMedium: headlineMedium,
    titleLarge:     titleLarge,
    titleMedium:    titleMedium,
    bodyLarge:      bodyLarge,
    bodyMedium:     bodyMedium,
    bodySmall:      bodySmall,
    labelLarge:     labelLarge,
    labelMedium:    labelMedium,
  );
}
