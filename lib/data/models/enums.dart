/// Enums passend zu den CHECK-Constraints im DB-Schema.
library;

enum BrewingType {
  western('WESTERN'),
  gongfu('GONGFU'),
  grandpa('GRANDPA'),
  coldBrew('COLD_BREW'),
  matcha('MATCHA'),
  boiled('BOILED');

  final String dbValue;
  const BrewingType(this.dbValue);

  static BrewingType fromDb(String value) => BrewingType.values.firstWhere(
        (e) => e.dbValue == value,
        orElse: () => throw ArgumentError('Unknown BrewingType: $value'),
      );
}

enum ColdBrewLocation {
  fridge('FRIDGE'),
  roomTemperature('ROOM_TEMPERATURE'),
  outdoor('OUTDOOR');

  final String dbValue;
  const ColdBrewLocation(this.dbValue);

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

  static ThemePreference fromDb(String value) =>
      ThemePreference.values.firstWhere(
        (e) => e.dbValue == value,
        orElse: () => ThemePreference.system,
      );
}
