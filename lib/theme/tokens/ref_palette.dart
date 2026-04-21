import 'package:flutter/material.dart';

abstract final class RefPalette {
  RefPalette._();

  // Primary · Warm Red (Camellia) 
  static const Color red0   = Color(0xFF000000);
  static const Color red10  = Color(0xFF410002);
  static const Color red20  = Color(0xFF690005);
  static const Color red30  = Color(0xFF8B1A1A);
  static const Color red40  = Color(0xFFBA1A1A);
  static const Color red80  = Color(0xFFFFB4AB);
  static const Color red90  = Color(0xFFFFDAD6);
  static const Color red95  = Color(0xFFFFEDEA);
  static const Color red99  = Color(0xFFFFFBFF);

  // Neutral · Warm Paper (Washi) 
  static const Color neutral10  = Color(0xFF1A1714);
  static const Color neutral20  = Color(0xFF302D2A);
  static const Color neutral30  = Color(0xFF48433F);
  static const Color neutral40  = Color(0xFF6B6459);
  static const Color neutral60  = Color(0xFFA89F94);
  static const Color neutral80  = Color(0xFFD0C8BC);
  static const Color neutral90  = Color(0xFFDDD5C4);
  static const Color neutral95  = Color(0xFFEAE3D3);
  static const Color neutral99  = Color(0xFFF5F0E8);
  static const Color neutral100 = Color(0xFFFFFFFF);

  // Neutral Variant · Warm Ink
  static const Color neutralVariant30 = Color(0xFF52443A);
  static const Color neutralVariant50 = Color(0xFF7D6E62);
  static const Color neutralVariant80 = Color(0xFFC4B5A8);
  static const Color neutralVariant90 = Color(0xFFDDD0C7);
  static const Color neutralVariant95 = Color(0xFFEDE3DA);

  // Dark Theme · Warm Night (Yoru)
  static const Color darkBackground     = Color(0xFF1C1610);
  static const Color darkSurface        = Color(0xFF262018);
  static const Color darkSurfaceVariant = Color(0xFF312A21);
  static const Color darkOutline        = Color(0xFF5C524A);
}
