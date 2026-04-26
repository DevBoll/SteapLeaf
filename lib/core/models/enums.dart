// Sammlung aller Enums.
// Persistiert wird der `name` (z. B. 'green') als TEXT in SQLite.

enum TeaType {
  green,    // Grün
  black,    // Schwarz
  oolong,   // Oolong
  puerh,    // Pu-Erh
  white,    // Weiss
  yellow,   // Gelb
  herbal,   // Kräuter
  fruit,    // Frucht
  rooibos,  // Rooibos
  other,    // Sonstige
}

enum BrewingType { western, gongFu, matcha, coldbrew, custom }

enum SessionType { simple, tasting }

enum SessionStatus { active, interrupted, completed, discarded }

enum InfusionType { prep, drink }

enum ColdBrewLocation { fridge, room }

enum AromaCategory { floral, fruity, grassy, earthy, woody, spicy, roasted }

enum TasteCategory { sweet, sour, bitter, umami, astringent }

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
