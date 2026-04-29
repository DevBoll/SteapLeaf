/// Enums passend zu den CHECK-Constraints im DB-Schema.
library;

import 'package:flutter/material.dart';
import '../../theme/tokens/kanji_tokens.dart';
import '../../theme/tokens/tea_type_tokens.dart';

enum BrewingType {
  western('WESTERN'),
  gongfu('GONGFU'),
  grandpa('GRANDPA'),
  coldBrew('COLD_BREW'),
  matcha('MATCHA');

  final String dbValue;
  const BrewingType(this.dbValue);

  String get label => switch (this) {
        BrewingType.western  => 'Westlich',
        BrewingType.gongfu   => 'Gong Fu',
        BrewingType.grandpa  => 'Grandpa',
        BrewingType.coldBrew => 'Cold Brew',
        BrewingType.matcha   => 'Matcha',
      };

  static BrewingType fromDb(String value) => BrewingType.values.firstWhere(
        (e) => e.dbValue == value,
        orElse: () => throw ArgumentError('Unknown BrewingType: $value'),
      );
}

enum ColdBrewLocation {
  fridge('FRIDGE'),
  roomTemperature('ROOM_TEMPERATURE');

  final String dbValue;
  const ColdBrewLocation(this.dbValue);

  String get label => switch (this) {
        ColdBrewLocation.fridge          => 'Kühlschrank',
        ColdBrewLocation.roomTemperature => 'Raumtemperatur',
      };

  static ColdBrewLocation? fromDb(String? value) {
    if (value == null) return null;
    for (final v in ColdBrewLocation.values) {
      if (v.dbValue == value) return v;
    }
    return null;
  }
}

enum Texture {
  smooth('SMOOTH'),
  silky('SILKY'),
  creamy('CREAMY'),
  oily('OILY'),
  buttery('BUTTERY'),
  thin('THIN'),
  watery('WATERY'),
  grainy('GRAINY'),
  velvety('VELVETY'),
  astringent('ASTRINGENT');

  final String dbValue;
  const Texture(this.dbValue);

  String get label => switch (this) {
        Texture.smooth     => 'Glatt',
        Texture.silky      => 'Seidig',
        Texture.creamy     => 'Cremig',
        Texture.oily       => 'Ölig',
        Texture.buttery    => 'Buttrig',
        Texture.thin       => 'Dünn',
        Texture.watery     => 'Wässrig',
        Texture.grainy     => 'Körnig',
        Texture.velvety    => 'Samtig',
        Texture.astringent => 'Adstringierend',
      };

  static Texture? fromDb(String? value) {
    if (value == null) return null;
    for (final v in Texture.values) {
      if (v.dbValue == value) return v;
    }
    return null;
  }
}

enum Aroma {
  floral('FLORAL'),
  fruity('FRUITY'),
  vegetal('VEGETAL'),
  spicy('SPICY'),
  earthy('EARTHY'),
  roasted('ROASTED'),
  herbal('HERBAL');

  final String dbValue;
  const Aroma(this.dbValue);

  String get label => switch (this) {
        Aroma.floral  => 'Blumig',
        Aroma.fruity  => 'Fruchtig',
        Aroma.vegetal => 'Pflanzlich',
        Aroma.spicy   => 'Würzig',
        Aroma.earthy  => 'Erdig',
        Aroma.roasted => 'Geröstet',
        Aroma.herbal  => 'Kräuterig',
      };

  static Aroma fromDb(String value) => Aroma.values.firstWhere(
        (e) => e.dbValue == value,
        orElse: () => throw ArgumentError('Unknown Aroma: $value'),
      );
}

enum SessionType {
  simple('SIMPLE'),
  tasting('TASTING');

  final String dbValue;
  const SessionType(this.dbValue);

  String get label => switch (this) {
        SessionType.simple  => 'Einfach',
        SessionType.tasting => 'Verkostung',
      };

  static SessionType fromDb(String value) => SessionType.values.firstWhere(
        (e) => e.dbValue == value,
        orElse: () => throw ArgumentError('Unknown SessionType: $value'),
      );
}

enum SessionStatus {
  planned('PLANNED'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED'),
  abandoned('ABANDONED');

  final String dbValue;
  const SessionStatus(this.dbValue);

  String get label => switch (this) {
        SessionStatus.planned    => 'Geplant',
        SessionStatus.inProgress => 'Läuft',
        SessionStatus.completed  => 'Abgeschlossen',
        SessionStatus.abandoned  => 'Abgebrochen',
      };

  static SessionStatus fromDb(String value) =>
      SessionStatus.values.firstWhere(
        (e) => e.dbValue == value,
        orElse: () => throw ArgumentError('Unknown SessionStatus: $value'),
      );
}

enum ThemePreference {
  light('LIGHT'),
  dark('DARK'),
  system('SYSTEM');

  final String dbValue;
  const ThemePreference(this.dbValue);

  String get label => switch (this) {
        ThemePreference.light  => 'Hell',
        ThemePreference.dark   => 'Dunkel',
        ThemePreference.system => 'Systemstandard',
      };

  static ThemePreference fromDb(String value) =>
      ThemePreference.values.firstWhere(
        (e) => e.dbValue == value,
        orElse: () => ThemePreference.system,
      );
}

enum TeaType {
  green('GREEN'),
  black('BLACK'),
  oolong('OOLONG'),
  white('WHITE'),
  yellow('YELLOW'),
  puerh('PUERH'),
  herbal('HERBAL'),
  fruit('FRUIT'),
  rooibos('ROOIBOS'),
  other('OTHER');

  final String dbValue;
  const TeaType(this.dbValue);

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
        TeaType.other   => 'Sonstige',
      };

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
        TeaType.other   => TeaTypeTokens.other,
      };

  Color get color => colors.badge;
  Color get textColor => colors.onContainer;

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
        TeaType.other   => SteapLeafKanji.typeCustom.character,
      };

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
        TeaType.other   => 100,
      };

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
        TeaType.other   => const Duration(minutes: 3),
      };

  static TeaType fromDb(String value) => TeaType.values.firstWhere(
        (e) => e.dbValue == value,
        orElse: () => throw ArgumentError('Unknown TeaType: $value'),
      );
}
