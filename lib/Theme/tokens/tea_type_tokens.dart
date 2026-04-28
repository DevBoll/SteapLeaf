import 'package:flutter/material.dart';

/// Farb-Set für einen einzelnen Tee-Typen.
@immutable
class TeaTypeColors {
  const TeaTypeColors({
    required this.container,
    required this.onContainer,
    required this.badge,
  });

  final Color container;
  final Color onContainer;
  final Color badge;

  /// Erzeugt eine [TeaTypeColors] Instanz für Dark Theme.
  TeaTypeColors darkened() => TeaTypeColors(
        container: HSLColor.fromColor(container)
            .withLightness(
                (HSLColor.fromColor(container).lightness - 0.35).clamp(0.1, 1.0))
            .toColor(),
        onContainer: HSLColor.fromColor(onContainer)
            .withLightness(
                (HSLColor.fromColor(onContainer).lightness + 0.5).clamp(0.0, 1.0))
            .toColor(),
        badge: HSLColor.fromColor(badge)
            .withLightness(
                (HSLColor.fromColor(badge).lightness + 0.4).clamp(0.0, 1.0))
            .toColor(),
      );
}

abstract final class TeaTypeTokens {
  TeaTypeTokens._();

  static const TeaTypeColors green = TeaTypeColors(
    container:   Color(0xFFDCE8CD),
    onContainer: Color(0xFF4A6A2E),
    badge:       Color(0xFF5C8235),
  );

  static const TeaTypeColors black = TeaTypeColors(
    container:   Color(0xFFD4C4B8),
    onContainer: Color(0xFF4A2D1A),
    badge:       Color(0xFF5C3A24),
  );

  static const TeaTypeColors oolong = TeaTypeColors(
    container:   Color(0xFFD8C9A8),
    onContainer: Color(0xFF5A4218),
    badge:       Color(0xFF7A5C24),
  );

  static const TeaTypeColors white = TeaTypeColors(
    container:   Color(0xFFEBE4D2),
    onContainer: Color(0xFF6B5A2E),
    badge:       Color(0xFF8A7A48),
  );

  static const TeaTypeColors puerh = TeaTypeColors(
    container:   Color(0xFFD4BC92),
    onContainer: Color(0xFF5C4218),
    badge:       Color(0xFF7A5818),
  );

  static const TeaTypeColors herbal = TeaTypeColors(
    container:   Color(0xFFC8D4B0),
    onContainer: Color(0xFF3F5226),
    badge:       Color(0xFF536A2E),
  );

  static const TeaTypeColors fruit = TeaTypeColors(
    container:   Color(0xFFEFCBC8),
    onContainer: Color(0xFF7A2A35),
    badge:       Color(0xFFA8424E),
  );

  static const TeaTypeColors rooibos = TeaTypeColors(
    container:   Color(0xFFE5C4B0),
    onContainer: Color(0xFF6E3618),
    badge:       Color(0xFF8A4424),
  );

  static const TeaTypeColors yellow = TeaTypeColors(
    container:   Color(0xFFF0E4B8),
    onContainer: Color(0xFF6B5418),
    badge:       Color(0xFF8B6F1A),
  );

static const TeaTypeColors other = TeaTypeColors(
    container:   Color(0xFFDCD7CD),
    onContainer: Color(0xFF5F5A50),
    badge:       Color(0xFF7A7468),
  );

}
