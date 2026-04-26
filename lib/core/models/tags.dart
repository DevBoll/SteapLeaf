import 'enums.dart';

/// Tag, der einem Tee zugewiesen werden kann (z. B. "morgens", "süss").
class TeaTag {
  final String id;
  final String name;

  const TeaTag({required this.id, required this.name});

  TeaTag copyWith({String? id, String? name}) =>
      TeaTag(id: id ?? this.id, name: name ?? this.name);

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  factory TeaTag.fromMap(Map<String, dynamic> m) =>
      TeaTag(id: m['id'] as String, name: m['name'] as String);
}

/// Aroma-Tag (z. B. "Honig", "Gras"), gehört zu genau einer AromaCategory.
class AromaTag {
  final String id;
  final String name;
  final AromaCategory category;

  const AromaTag({
    required this.id,
    required this.name,
    required this.category,
  });

  AromaTag copyWith({String? id, String? name, AromaCategory? category}) =>
      AromaTag(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category.name,
      };

  factory AromaTag.fromMap(Map<String, dynamic> m) => AromaTag(
        id: m['id'] as String,
        name: m['name'] as String,
        category: enumFromName(
          AromaCategory.values,
          m['category'] as String?,
          AromaCategory.floral,
        ),
      );
}

/// Texture-Tag für Mouthfeel (z. B. "ölig", "trocken").
class TextureTag {
  final String id;
  final String name;

  const TextureTag({required this.id, required this.name});

  TextureTag copyWith({String? id, String? name}) =>
      TextureTag(id: id ?? this.id, name: name ?? this.name);

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  factory TextureTag.fromMap(Map<String, dynamic> m) =>
      TextureTag(id: m['id'] as String, name: m['name'] as String);
}
