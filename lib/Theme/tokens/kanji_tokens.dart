// Kanji Rolle 
enum KanjiRole {
  functional,
  navigational,
  decorative,
  taxonomic,
}

class KanjiDefinition {
  const KanjiDefinition({
    required this.character,
    required this.reading,
    required this.meaning,
    required this.semanticLabel,
    required this.defaultRole,
  });

  final String character;
  final String reading;
  final String meaning;
  final String semanticLabel;
  final KanjiRole defaultRole;

  @override
  String toString() => character;
}

abstract final class SteapLeafKanji {
  SteapLeafKanji._();

  static const KanjiDefinition sessionStart = KanjiDefinition(
    character:     '始',
    reading:       'Hajime',
    meaning:       'Anfang, Start',
    semanticLabel: 'Session starten',
    defaultRole:   KanjiRole.functional,
  );

  static const KanjiDefinition newItem = KanjiDefinition(
    character:     '新',
    reading:       'Shin',
    meaning:       'Neu',
    semanticLabel: 'Neu erstellen',
    defaultRole:   KanjiRole.functional,
  );

  static const KanjiDefinition save = KanjiDefinition(
    character:     '保',
    reading:       'Ho',
    meaning:       'Bewahren, Schützen',
    semanticLabel: 'Speichern',
    defaultRole:   KanjiRole.functional,
  );

  static const KanjiDefinition stop = KanjiDefinition(
    character:     '止',
    reading:       'Shi',
    meaning:       'Stopp, Anhalten',
    semanticLabel: 'Stopp',
    defaultRole:   KanjiRole.functional,
  );

  static const KanjiDefinition record = KanjiDefinition(
    character:     '録',
    reading:       'Roku',
    meaning:       'Aufzeichnen, Protokollieren',
    semanticLabel: 'Session erfassen',
    defaultRole:   KanjiRole.functional,
  );

  static const KanjiDefinition edit = KanjiDefinition(
    character:     '編',
    reading:       'Hen',
    meaning:       'Bearbeiten',
    semanticLabel: 'Bearbeiten',
    defaultRole:   KanjiRole.functional,
  );

  static const KanjiDefinition delete = KanjiDefinition(
    character:     '削',
    reading:       'Saku',
    meaning:       'Löschen, Entfernen',
    semanticLabel: 'Löschen',
    defaultRole:   KanjiRole.functional,
  );

  // Navigation 

  static const KanjiDefinition home = KanjiDefinition(
    character:     '家',
    reading:       'Ie',
    meaning:       'Heim, Zuhause',
    semanticLabel: 'Heim',
    defaultRole:   KanjiRole.navigational,
  );

  static const KanjiDefinition collection = KanjiDefinition(
    character:     '蔵',
    reading:       'Kura',
    meaning:       'Lager, Vorratskammer',
    semanticLabel: 'Teesammlung',
    defaultRole:   KanjiRole.navigational,
  );

  static const KanjiDefinition journal = KanjiDefinition(
    character:     '緑',
    reading:       'Ryoku',
    meaning:       'Grün (Journal)',
    semanticLabel: 'Journal',
    defaultRole:   KanjiRole.navigational,
  );

  // Teetypen (Taxonomisch) 

  static const KanjiDefinition typeGreen = KanjiDefinition(
    character:     '緑',
    reading:       'Midori',
    meaning:       'Grün',
    semanticLabel: 'Grüner Tee',
    defaultRole:   KanjiRole.taxonomic,
  );

  static const KanjiDefinition typeBlack = KanjiDefinition(
    character:     '黒',
    reading:       'Kuro',
    meaning:       'Schwarz',
    semanticLabel: 'Schwarzer Tee',
    defaultRole:   KanjiRole.taxonomic,
  );

  static const KanjiDefinition typeOolong = KanjiDefinition(
    character:     '青',
    reading:       'Ao',
    meaning:       'Blau-Grün',
    semanticLabel: 'Oolong Tee',
    defaultRole:   KanjiRole.taxonomic,
  );

  static const KanjiDefinition typeWhite = KanjiDefinition(
    character:     '白',
    reading:       'Shiro',
    meaning:       'Weiß',
    semanticLabel: 'Weißer Tee',
    defaultRole:   KanjiRole.taxonomic,
  );

  static const KanjiDefinition typePuerh = KanjiDefinition(
    character:     '普',
    reading:       'Fu',
    meaning:       'Allgemein',
    semanticLabel: 'Pu-Erh Tee',
    defaultRole:   KanjiRole.taxonomic,
  );

  static const KanjiDefinition typeHerbal = KanjiDefinition(
    character:     '草',
    reading:       'Kusa',
    meaning:       'Pflanze, Kraut',
    semanticLabel: 'Kräutertee',
    defaultRole:   KanjiRole.taxonomic,
  );

  static const KanjiDefinition typeFruit = KanjiDefinition(
    character:     '果',
    reading:       'Ka',
    meaning:       'Frucht',
    semanticLabel: 'Früchtetee',
    defaultRole:   KanjiRole.taxonomic,
  );

  static const KanjiDefinition typeRooibos = KanjiDefinition(
    character:     '赤',
    reading:       'Aka',
    meaning:       'Rot',
    semanticLabel: 'Rooibos Tee',
    defaultRole:   KanjiRole.taxonomic,
  );

static const KanjiDefinition typeYellow = KanjiDefinition(
  character:     '黄',
  reading:       'Ki',
  meaning:       'Gelb',
  semanticLabel: 'Gelber Tee',
  defaultRole:   KanjiRole.taxonomic,
);

  static const KanjiDefinition typeCustom = KanjiDefinition(
    character:     '外',
    reading:       'Soto',
    meaning:       'Außen, Extern',
    semanticLabel: 'Anderer Tee',
    defaultRole:   KanjiRole.taxonomic,
  );

  // Verkostungsprofil 

  static const KanjiDefinition aroma = KanjiDefinition(
    character:     '香',
    reading:       'Kou',
    meaning:       'Duft, Aroma',
    semanticLabel: 'Aroma',
    defaultRole:   KanjiRole.navigational,
  );

  static const KanjiDefinition taste = KanjiDefinition(
    character:     '味',
    reading:       'Aji',
    meaning:       'Geschmack',
    semanticLabel: 'Geschmack',
    defaultRole:   KanjiRole.navigational,
  );

  static const KanjiDefinition mouthfeel = KanjiDefinition(
    character:     '感',
    reading:       'Kan',
    meaning:       'Gefühl, Empfindung',
    semanticLabel: 'Mundgefühl',
    defaultRole:   KanjiRole.navigational,
  );

  static const KanjiDefinition tasting = KanjiDefinition(
    character:     '品',
    reading:       'Hin',
    meaning:       'Qualität, Verkostung',
    semanticLabel: 'Verkostungsprofil',
    defaultRole:   KanjiRole.navigational,
  );

  // Tee-Erfassung Tabs

  static const KanjiDefinition basics = KanjiDefinition(
    character:     '基',
    reading:       'Ki',
    meaning:       'Grundlage, Basis',
    semanticLabel: 'Basisdaten',
    defaultRole:   KanjiRole.navigational,
  );

  static const KanjiDefinition notes = KanjiDefinition(
    character:     '記',
    reading:       'Ki',
    meaning:       'Notizen, Aufzeichnung',
    semanticLabel: 'Notizen',
    defaultRole:   KanjiRole.navigational,
  );

  // Journal

  static const KanjiDefinition overview = KanjiDefinition(
    character:     '統',
    reading:       'Tou',
    meaning:       'Überblick, Auswertung',
    semanticLabel: 'Auswertung',
    defaultRole:   KanjiRole.navigational,
  );

  static const KanjiDefinition history = KanjiDefinition(
    character:     '歴',
    reading:       'Reki',
    meaning:       'Verlauf, Geschichte',
    semanticLabel: 'Verlauf',
    defaultRole:   KanjiRole.navigational,
  );
}
