import 'enums.dart';

/// Geschmacksprofil – eingebettetes Wert-Objekt.
/// Wird als JSON in der Spalte `flavor_profile` der Owner-Tabelle gespeichert
/// (Tea, Session, Infusion).
///
/// Aroma-Tag-IDs und texture-Tag-ID referenzieren die Master-Tabellen
/// `aroma_tags` bzw. `texture_tags`. Es gibt keinen DB-Foreign-Key – die
/// Konsistenz muss im Repository sichergestellt werden.
class FlavorProfile {
  final Map<AromaCategory, int> aromaRatings;       // 0..5 (0 = nicht bewertet)
  final List<String> aromaTagIds;
  final Map<TasteCategory, int> tasteRatings;       // 0..5
  final Map<MouthfeelCategory, int> mouthfeelRatings; // 0..5
  final String? textureTagId;

  const FlavorProfile({
    this.aromaRatings = const {},
    this.aromaTagIds = const [],
    this.tasteRatings = const {},
    this.mouthfeelRatings = const {},
    this.textureTagId,
  });

  static const empty = FlavorProfile();

  FlavorProfile copyWith({
    Map<AromaCategory, int>? aromaRatings,
    List<String>? aromaTagIds,
    Map<TasteCategory, int>? tasteRatings,
    Map<MouthfeelCategory, int>? mouthfeelRatings,
    String? textureTagId,
    bool clearTextureTagId = false,
  }) {
    return FlavorProfile(
      aromaRatings: aromaRatings ?? this.aromaRatings,
      aromaTagIds: aromaTagIds ?? this.aromaTagIds,
      tasteRatings: tasteRatings ?? this.tasteRatings,
      mouthfeelRatings: mouthfeelRatings ?? this.mouthfeelRatings,
      textureTagId:
          clearTextureTagId ? null : (textureTagId ?? this.textureTagId),
    );
  }

  Map<String, dynamic> toJson() => {
        'aromaRatings':
            aromaRatings.map((k, v) => MapEntry(k.name, v)),
        'aromaTagIds': aromaTagIds,
        'tasteRatings':
            tasteRatings.map((k, v) => MapEntry(k.name, v)),
        'mouthfeelRatings':
            mouthfeelRatings.map((k, v) => MapEntry(k.name, v)),
        'textureTagId': textureTagId,
      };

  factory FlavorProfile.fromJson(Map<String, dynamic> j) {
    return FlavorProfile(
      aromaRatings: _parseEnumIntMap(AromaCategory.values, j['aromaRatings']),
      aromaTagIds: (j['aromaTagIds'] as List?)?.cast<String>() ?? const [],
      tasteRatings: _parseEnumIntMap(TasteCategory.values, j['tasteRatings']),
      mouthfeelRatings:
          _parseEnumIntMap(MouthfeelCategory.values, j['mouthfeelRatings']),
      textureTagId: j['textureTagId'] as String?,
    );
  }

  static Map<T, int> _parseEnumIntMap<T extends Enum>(
    List<T> values,
    dynamic raw,
  ) {
    if (raw is! Map) return <T, int>{};
    final out = <T, int>{};
    raw.forEach((k, v) {
      final e = enumFromNameOrNull(values, k as String?);
      if (e != null && v is num) out[e] = v.toInt();
    });
    return out;
  }
}
