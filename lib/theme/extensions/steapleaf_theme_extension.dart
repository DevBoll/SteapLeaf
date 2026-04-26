import 'package:flutter/material.dart';
import '../tokens/tea_type_tokens.dart';


@immutable
class SteapLeafThemeExtension extends ThemeExtension<SteapLeafThemeExtension> {
  const SteapLeafThemeExtension({
    // Brand Colors
    required this.starFilled,
    required this.starEmpty,
    required this.favorite,
    required this.coldBrewSurface,

    // Slider 
    required this.sliderActive,
    required this.sliderInactive,
    required this.sliderThumb,

    // Step Indicator
    required this.stepIndicatorActive,
    required this.stepIndicatorInactive,

    // Timer
    required this.timerArcActive,
    required this.timerArcTrack,
    required this.timerBarBackground,
    required this.timerBarColdBrewBackground,

    // Tea Type Colors
    required this.teaTypeGreen,
    required this.teaTypeBlack,
    required this.teaTypeOolong,
    required this.teaTypeWhite,
    required this.teaTypePuerh,
    required this.teaTypeHerbal,
    required this.teaTypeFruit,
    required this.teaTypeRooibos,
    required this.teaTypeYellow,
  });

  // Brand Colors
  /// Farbe ausgefüllter Bewertungssterne.
  final Color starFilled;

  /// Farbe leerer Bewertungssterne.
  final Color starEmpty;

  /// Farbe des aktiven Herz-Icons (Favorit).
  final Color favorite;

  /// Hintergrundfarbe der Cold-Brew-Timer-Bar (blauer Tint zur Differenzierung).
  final Color coldBrewSurface;

  // Slider

  /// Aktiver Teil der Slider-Spur (links vom Thumb).
  final Color sliderActive;

  /// Inaktiver Teil der Slider-Spur (rechts vom Thumb).
  final Color sliderInactive;

  /// Slider-Thumb-Farbe.
  final Color sliderThumb;

  // Step Indicator

  /// Aktives/abgeschlossenes Segment im Session-Flow-Indikator.
  final Color stepIndicatorActive;

  /// Noch nicht erreichtes Segment im Session-Flow-Indikator.
  final Color stepIndicatorInactive;

  // Timer

  /// Aktiver Arc-Fortschritt auf dem Timer-Screen.
  final Color timerArcActive;

  /// Hintergrunds-Spur des Timer-Arcs.
  final Color timerArcTrack;

  /// Hintergrundfarbe einer normalen Floating-Timer-Bar.
  final Color timerBarBackground;

  /// Hintergrundfarbe der Cold-Brew-Floating-Timer-Bar.
  final Color timerBarColdBrewBackground;

  // Tea Type Colors
  final TeaTypeColors teaTypeGreen;
  final TeaTypeColors teaTypeBlack;
  final TeaTypeColors teaTypeOolong;
  final TeaTypeColors teaTypeWhite;
  final TeaTypeColors teaTypePuerh;
  final TeaTypeColors teaTypeHerbal;
  final TeaTypeColors teaTypeFruit;
  final TeaTypeColors teaTypeRooibos;
  final TeaTypeColors teaTypeYellow;

  // ThemeExtension boilerplate 

  @override
  SteapLeafThemeExtension copyWith({
    Color? brandLine,
    Color? kanjiDecorative,
    Color? starFilled,
    Color? starEmpty,
    Color? favorite,
    Color? coldBrewSurface,
    Color? sliderActive,
    Color? sliderInactive,
    Color? sliderThumb,
    Color? stepIndicatorActive,
    Color? stepIndicatorInactive,
    Color? timerArcActive,
    Color? timerArcTrack,
    Color? timerBarBackground,
    Color? timerBarColdBrewBackground,
    TeaTypeColors? teaTypeGreen,
    TeaTypeColors? teaTypeBlack,
    TeaTypeColors? teaTypeOolong,
    TeaTypeColors? teaTypeWhite,
    TeaTypeColors? teaTypePuerh,
    TeaTypeColors? teaTypeHerbal,
    TeaTypeColors? teaTypeFruit,
    TeaTypeColors? teaTypeRooibos,
    TeaTypeColors? teaTypeYellow,
  }) {
    return SteapLeafThemeExtension(
      starFilled:                   starFilled                   ?? this.starFilled,
      starEmpty:                    starEmpty                    ?? this.starEmpty,
      favorite:                     favorite                     ?? this.favorite,
      coldBrewSurface:              coldBrewSurface              ?? this.coldBrewSurface,
      sliderActive:                 sliderActive                 ?? this.sliderActive,
      sliderInactive:               sliderInactive               ?? this.sliderInactive,
      sliderThumb:                  sliderThumb                  ?? this.sliderThumb,
      stepIndicatorActive:          stepIndicatorActive          ?? this.stepIndicatorActive,
      stepIndicatorInactive:        stepIndicatorInactive        ?? this.stepIndicatorInactive,
      timerArcActive:               timerArcActive               ?? this.timerArcActive,
      timerArcTrack:                timerArcTrack                ?? this.timerArcTrack,
      timerBarBackground:           timerBarBackground           ?? this.timerBarBackground,
      timerBarColdBrewBackground:   timerBarColdBrewBackground   ?? this.timerBarColdBrewBackground,
      teaTypeGreen:                 teaTypeGreen                 ?? this.teaTypeGreen,
      teaTypeBlack:                 teaTypeBlack                 ?? this.teaTypeBlack,
      teaTypeOolong:                teaTypeOolong                ?? this.teaTypeOolong,
      teaTypeWhite:                 teaTypeWhite                 ?? this.teaTypeWhite,
      teaTypePuerh:                 teaTypePuerh                 ?? this.teaTypePuerh,
      teaTypeHerbal:                teaTypeHerbal                ?? this.teaTypeHerbal,
      teaTypeFruit:                 teaTypeFruit                 ?? this.teaTypeFruit,
      teaTypeRooibos:               teaTypeRooibos               ?? this.teaTypeRooibos, 
      teaTypeYellow:                teaTypeYellow                ?? this.teaTypeYellow, 
    );
  }

  @override
  SteapLeafThemeExtension lerp(SteapLeafThemeExtension? other, double t) {
    if (other == null) return this;
    return SteapLeafThemeExtension(
      starFilled:                  Color.lerp(starFilled,                  other.starFilled,                  t)!,
      starEmpty:                   Color.lerp(starEmpty,                   other.starEmpty,                   t)!,
      favorite:                    Color.lerp(favorite,                    other.favorite,                    t)!,
      coldBrewSurface:             Color.lerp(coldBrewSurface,             other.coldBrewSurface,             t)!,
      sliderActive:                Color.lerp(sliderActive,                other.sliderActive,                t)!,
      sliderInactive:              Color.lerp(sliderInactive,              other.sliderInactive,              t)!,
      sliderThumb:                 Color.lerp(sliderThumb,                 other.sliderThumb,                 t)!,
      stepIndicatorActive:         Color.lerp(stepIndicatorActive,         other.stepIndicatorActive,         t)!,
      stepIndicatorInactive:       Color.lerp(stepIndicatorInactive,       other.stepIndicatorInactive,       t)!,
      timerArcActive:              Color.lerp(timerArcActive,              other.timerArcActive,              t)!,
      timerArcTrack:               Color.lerp(timerArcTrack,               other.timerArcTrack,               t)!,
      timerBarBackground:          Color.lerp(timerBarBackground,          other.timerBarBackground,          t)!,
      timerBarColdBrewBackground:  Color.lerp(timerBarColdBrewBackground,  other.timerBarColdBrewBackground,  t)!,
      teaTypeGreen:    t < 0.5 ? teaTypeGreen   : other.teaTypeGreen,
      teaTypeBlack:    t < 0.5 ? teaTypeBlack   : other.teaTypeBlack,
      teaTypeOolong:   t < 0.5 ? teaTypeOolong  : other.teaTypeOolong,
      teaTypeWhite:    t < 0.5 ? teaTypeWhite   : other.teaTypeWhite,
      teaTypePuerh:    t < 0.5 ? teaTypePuerh   : other.teaTypePuerh,
      teaTypeHerbal:   t < 0.5 ? teaTypeHerbal  : other.teaTypeHerbal,
      teaTypeFruit:    t < 0.5 ? teaTypeFruit   : other.teaTypeFruit,
      teaTypeRooibos:  t < 0.5 ? teaTypeRooibos : other.teaTypeRooibos,
      teaTypeYellow:   t < 0.5 ? teaTypeYellow  : other.teaTypeYellow, 
    );
  }
}
