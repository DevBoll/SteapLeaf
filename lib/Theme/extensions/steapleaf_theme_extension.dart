import 'package:flutter/material.dart';
import '../tokens/tea_type_tokens.dart';


@immutable
class SteapLeafThemeExtension extends ThemeExtension<SteapLeafThemeExtension> {
  const SteapLeafThemeExtension({
  
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
    required this.teaTypeOther,
  });

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
  final TeaTypeColors teaTypeOther;

  // ThemeExtension boilerplate 
  @override
  SteapLeafThemeExtension copyWith({
    TeaTypeColors? teaTypeGreen,
    TeaTypeColors? teaTypeBlack,
    TeaTypeColors? teaTypeOolong,
    TeaTypeColors? teaTypeWhite,
    TeaTypeColors? teaTypePuerh,
    TeaTypeColors? teaTypeHerbal,
    TeaTypeColors? teaTypeFruit,
    TeaTypeColors? teaTypeRooibos,
    TeaTypeColors? teaTypeYellow,
    TeaTypeColors? teaTypeOther,
  }) {
    return SteapLeafThemeExtension(
      teaTypeGreen:                 teaTypeGreen                 ?? this.teaTypeGreen,
      teaTypeBlack:                 teaTypeBlack                 ?? this.teaTypeBlack,
      teaTypeOolong:                teaTypeOolong                ?? this.teaTypeOolong,
      teaTypeWhite:                 teaTypeWhite                 ?? this.teaTypeWhite,
      teaTypePuerh:                 teaTypePuerh                 ?? this.teaTypePuerh,
      teaTypeHerbal:                teaTypeHerbal                ?? this.teaTypeHerbal,
      teaTypeFruit:                 teaTypeFruit                 ?? this.teaTypeFruit,
      teaTypeRooibos:               teaTypeRooibos               ?? this.teaTypeRooibos, 
      teaTypeYellow:                teaTypeYellow                ?? this.teaTypeYellow, 
      teaTypeOther:                 teaTypeOther                 ?? this.teaTypeOther,
    );
  }

  @override
  SteapLeafThemeExtension lerp(SteapLeafThemeExtension? other, double t) {
    if (other == null) return this;
    return SteapLeafThemeExtension(
      teaTypeGreen:    t < 0.5 ? teaTypeGreen   : other.teaTypeGreen,
      teaTypeBlack:    t < 0.5 ? teaTypeBlack   : other.teaTypeBlack,
      teaTypeOolong:   t < 0.5 ? teaTypeOolong  : other.teaTypeOolong,
      teaTypeWhite:    t < 0.5 ? teaTypeWhite   : other.teaTypeWhite,
      teaTypePuerh:    t < 0.5 ? teaTypePuerh   : other.teaTypePuerh,
      teaTypeHerbal:   t < 0.5 ? teaTypeHerbal  : other.teaTypeHerbal,
      teaTypeFruit:    t < 0.5 ? teaTypeFruit   : other.teaTypeFruit,
      teaTypeRooibos:  t < 0.5 ? teaTypeRooibos : other.teaTypeRooibos,
      teaTypeYellow:   t < 0.5 ? teaTypeYellow  : other.teaTypeYellow,
      teaTypeOther:    t < 0.5 ? teaTypeOther   : other.teaTypeOther, 
    );
  }
}
