// Sammlung aller Enums.
// Persistiert wird der `name` (z. B. 'green') als TEXT in SQLite.

import 'package:flutter/material.dart';

import '../../theme/steapleaf_theme.dart';

enum TeaType {
  green,
  black,
  oolong,
  white,
  yellow,
  puerh,
  herbal,
  fruit,
  rooibos,
  other;

  String get label => switch (this) {
    TeaType.green   => 'Grün',
    TeaType.black   => 'Schwarz',
    TeaType.oolong  => 'Oolong',
    TeaType.white   => 'Weiß',
    TeaType.yellow  => 'Gelb',
    TeaType.puerh   => 'Pu-Erh',
    TeaType.herbal  => 'Kräuter',
    TeaType.fruit   => 'Früchte',
    TeaType.rooibos => 'Rooibos',
    TeaType.other  => 'Sonstige'
  };

  /// Vollständiges Farb-Set aus dem Theme (container, onContainer, badge).
  TeaTypeColors get colors => switch (this) {
    TeaType.green   => TeaTypeTokens.green,
    TeaType.black   => TeaTypeTokens.black,
    TeaType.oolong  => TeaTypeTokens.oolong,
    TeaType.white   => TeaTypeTokens.white,
    TeaType.yellow  => TeaTypeTokens.yellow,
    TeaType.puerh   => TeaTypeTokens.puerh,
    TeaType.herbal  => TeaTypeTokens.herbal,
    TeaType.fruit   => TeaTypeTokens.fruit,
    TeaType.rooibos => TeaTypeTokens.rooibos,
    TeaType.other => TeaTypeTokens.other,
  };

  /// Kennfarbe für Badges und Chips.
  Color get color => colors.badge;

  /// Textfarbe auf der Kennfarbe.
  Color get textColor => colors.onContainer;

  /// Kanji-Symbol aus der SteapLeaf-Kanji-Bibliothek.
  String get kanji => switch (this) {
    TeaType.green   => SteapLeafKanji.typeGreen.character,
    TeaType.black   => SteapLeafKanji.typeBlack.character,
    TeaType.oolong  => SteapLeafKanji.typeOolong.character,
    TeaType.white   => SteapLeafKanji.typeWhite.character,
    TeaType.yellow  => SteapLeafKanji.typeYellow.character,
    TeaType.puerh   => SteapLeafKanji.typePuerh.character,
    TeaType.herbal  => SteapLeafKanji.typeHerbal.character,
    TeaType.fruit   => SteapLeafKanji.typeFruit.character,
    TeaType.rooibos => SteapLeafKanji.typeRooibos.character,
    TeaType.other => SteapLeafKanji.typeCustom.character,
  };

  /// Empfohlene Brühtemperatur als Standardwert
  int get defaultTemp => switch (this) {
    TeaType.green   => 70,
    TeaType.yellow  => 75,
    TeaType.white   => 75,
    TeaType.oolong  => 85,
    TeaType.black   => 95,
    TeaType.puerh   => 95,
    TeaType.herbal  => 100,
    TeaType.fruit   => 100,
    TeaType.rooibos => 100,
    TeaType.other => 100,
  };

  /// Empfohlene Ziehzeit als Standardwert
  Duration get defaultSteepTime => switch (this) {
    TeaType.green   => const Duration(minutes: 2),
    TeaType.yellow  => const Duration(minutes: 2),
    TeaType.black   => const Duration(minutes: 3),
    TeaType.oolong  => const Duration(minutes: 3),
    TeaType.puerh   => const Duration(minutes: 3),
    TeaType.white   => const Duration(minutes: 4),
    TeaType.herbal  => const Duration(minutes: 5),
    TeaType.fruit   => const Duration(minutes: 5),
    TeaType.rooibos => const Duration(minutes: 5),
    TeaType.other => const Duration(minutes: 3),
  };

  static TeaType fromString(String value) {
    return TeaType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TeaType.green,
    );
  }

}

enum BrewingType {
  western,
  gongfu,
  coldBrew,
  matcha,
  custom;

  String get label => switch (this) {
    BrewingType.western  => 'Westlich',
    BrewingType.gongfu   => 'Gong Fu',
    BrewingType.coldBrew => 'Cold Brew',
    BrewingType.matcha => 'Matcha',
    BrewingType.custom   => 'Benutzerdefiniert',
  };

  static BrewingType fromString(String value) {
    return BrewingType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BrewingType.western,
    );
  }
}


enum SessionType { simple, tasting }

enum SessionStatus { active, interrupted, completed, discarded }

enum InfusionType { prep, drink }

enum ColdBrewLocation { fridge, room }

enum AromaCategory { floral, fruity, grassy, earthy, herbal, spicy, roasted }

enum TasteCategory { sweet, sour, bitter, umami, salty }

enum MouthfeelCategory { body, astringency, finish }

/// Hilfsfunktion: Enum aus String-Namen rekonstruieren mit Fallback.
T enumFromName<T extends Enum>(List<T> values, String? name, T fallback) {
  if (name == null) return fallback;
  for (final e in values) {
    if (e.name == name) return e;
  }
  return fallback;
}

/// Hilfsfunktion: nullable-Variante (gibt null zurück, wenn nicht gefunden).
T? enumFromNameOrNull<T extends Enum>(List<T> values, String? name) {
  if (name == null) return null;
  for (final e in values) {
    if (e.name == name) return e;
  }
  return null;
}
