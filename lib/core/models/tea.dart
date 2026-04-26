import 'dart:convert';

import 'enums.dart';
import 'flavor_profile.dart';
import 'tags.dart';
import 'brewing_variant.dart';

/// Hauptentität: ein Tee in der Sammlung.
///
/// `tags` und `brewingVariants` sind im Tea-Objekt gehalten, werden aber
/// in eigenen Tabellen persistiert. Sie werden vom Repository mitgeladen.
class Tea {
  final String id;
  final String name;
  final TeaType type;
  final String origin;
  final String harvest;
  final String vendor;
  final bool isOwned;
  final bool isFavorite;
  final String? teaPhotoPath;
  final String? labelPhotoPath;
  final String notes;
  final int rating; // 0 = nicht bewertet, 1..5
  final FlavorProfile flavorProfile;
  final List<TeaTag> tags;
  final List<BrewingVariant> brewingVariants;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Tea({
    required this.id,
    required this.name,
    required this.type,
    this.origin = '',
    this.harvest = '',
    this.vendor = '',
    this.isOwned = false,
    this.isFavorite = false,
    this.teaPhotoPath,
    this.labelPhotoPath,
    this.notes = '',
    this.rating = 0,
    this.flavorProfile = FlavorProfile.empty,
    this.tags = const [],
    this.brewingVariants = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Tea copyWith({
    String? id,
    String? name,
    TeaType? type,
    String? origin,
    String? harvest,
    String? vendor,
    bool? isOwned,
    bool? isFavorite,
    String? teaPhotoPath,
    String? labelPhotoPath,
    bool clearTeaPhoto = false,
    bool clearLabelPhoto = false,
    String? notes,
    int? rating,
    FlavorProfile? flavorProfile,
    List<TeaTag>? tags,
    List<BrewingVariant>? brewingVariants,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tea(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      origin: origin ?? this.origin,
      harvest: harvest ?? this.harvest,
      vendor: vendor ?? this.vendor,
      isOwned: isOwned ?? this.isOwned,
      isFavorite: isFavorite ?? this.isFavorite,
      teaPhotoPath:
          clearTeaPhoto ? null : (teaPhotoPath ?? this.teaPhotoPath),
      labelPhotoPath:
          clearLabelPhoto ? null : (labelPhotoPath ?? this.labelPhotoPath),
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      flavorProfile: flavorProfile ?? this.flavorProfile,
      tags: tags ?? this.tags,
      brewingVariants: brewingVariants ?? this.brewingVariants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Konvertierung in eine SQLite-Row.
  /// `tags` und `brewingVariants` werden NICHT mitgegeben –
  /// die schreibt das Repository in ihre eigenen Tabellen.
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': type.name,
        'origin': origin,
        'harvest': harvest,
        'vendor': vendor,
        'is_owned': isOwned ? 1 : 0,
        'is_favorite': isFavorite ? 1 : 0,
        'tea_photo_path': teaPhotoPath,
        'label_photo_path': labelPhotoPath,
        'notes': notes,
        'rating': rating,
        'flavor_profile': jsonEncode(flavorProfile.toJson()),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory Tea.fromMap(
    Map<String, dynamic> m, {
    List<TeaTag> tags = const [],
    List<BrewingVariant> brewingVariants = const [],
  }) {
    return Tea(
      id: m['id'] as String,
      name: m['name'] as String,
      type: enumFromName(TeaType.values, m['type'] as String?, TeaType.other),
      origin: (m['origin'] as String?) ?? '',
      harvest: (m['harvest'] as String?) ?? '',
      vendor: (m['vendor'] as String?) ?? '',
      isOwned: (m['is_owned'] as int? ?? 0) == 1,
      isFavorite: (m['is_favorite'] as int? ?? 0) == 1,
      teaPhotoPath: m['tea_photo_path'] as String?,
      labelPhotoPath: m['label_photo_path'] as String?,
      notes: (m['notes'] as String?) ?? '',
      rating: (m['rating'] as int?) ?? 0,
      flavorProfile: _decodeFlavor(m['flavor_profile'] as String?),
      tags: tags,
      brewingVariants: brewingVariants,
      createdAt: DateTime.parse(m['created_at'] as String),
      updatedAt: DateTime.parse(m['updated_at'] as String),
    );
  }

  static FlavorProfile _decodeFlavor(String? raw) {
    if (raw == null || raw.isEmpty) return FlavorProfile.empty;
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return FlavorProfile.fromJson(decoded);
    }
    return FlavorProfile.empty;
  }
}
