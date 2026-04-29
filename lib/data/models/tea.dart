import 'brewing.dart';
import 'enums.dart';
import 'flavor_profile.dart';
import 'tag.dart';

class Tea {
  final int? id;
  final String name;
  final TeaType? type;
  final String? origin;
  final String? harvest;
  final String? vendor;
  final bool isOwned;
  final bool isFavorite;
  final String? teaPhotoPath;
  final String? labelPhotoPath;
  final String? notes;
  final double? rating;
  final int? flavorProfileId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Tea({
    this.id,
    required this.name,
    this.type,
    this.origin,
    this.harvest,
    this.vendor,
    this.isOwned = false,
    this.isFavorite = false,
    this.teaPhotoPath,
    this.labelPhotoPath,
    this.notes,
    this.rating,
    this.flavorProfileId,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'type': type?.dbValue,
        'origin': origin,
        'harvest': harvest,
        'vendor': vendor,
        'isOwned': isOwned ? 1 : 0,
        'isFavorite': isFavorite ? 1 : 0,
        'teaPhotoPath': teaPhotoPath,
        'labelPhotoPath': labelPhotoPath,
        'notes': notes,
        'rating': rating,
        'flavorProfileId': flavorProfileId,
      };

  factory Tea.fromMap(Map<String, Object?> map) => Tea(
        id: map['id'] as int?,
        name: map['name'] as String,
        type: map['type'] == null ? null : TeaType.fromDb(map['type'] as String),
        origin: map['origin'] as String?,
        harvest: map['harvest'] as String?,
        vendor: map['vendor'] as String?,
        isOwned: ((map['isOwned'] as int?) ?? 0) != 0,
        isFavorite: ((map['isFavorite'] as int?) ?? 0) != 0,
        teaPhotoPath: map['teaPhotoPath'] as String?,
        labelPhotoPath: map['labelPhotoPath'] as String?,
        notes: map['notes'] as String?,
        rating: (map['rating'] as num?)?.toDouble(),
        flavorProfileId: map['flavorProfileId'] as int?,
        createdAt: _parseDate(map['createdAt']),
        updatedAt: _parseDate(map['updatedAt']),
      );

  Tea copyWith({
    int? id,
    String? name,
    TeaType? type,
    String? origin,
    String? harvest,
    String? vendor,
    bool? isOwned,
    bool? isFavorite,
    String? teaPhotoPath,
    String? labelPhotoPath,
    String? notes,
    double? rating,
    int? flavorProfileId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Tea(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        origin: origin ?? this.origin,
        harvest: harvest ?? this.harvest,
        vendor: vendor ?? this.vendor,
        isOwned: isOwned ?? this.isOwned,
        isFavorite: isFavorite ?? this.isFavorite,
        teaPhotoPath: teaPhotoPath ?? this.teaPhotoPath,
        labelPhotoPath: labelPhotoPath ?? this.labelPhotoPath,
        notes: notes ?? this.notes,
        rating: rating ?? this.rating,
        flavorProfileId: flavorProfileId ?? this.flavorProfileId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static DateTime? _parseDate(Object? v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}

class TeaWithDetails {
  final Tea tea;
  final FlavorProfile? flavorProfile;
  final List<FlavorProfileAromaTag> aromaTags;
  final List<Tag> tags;
  final List<BrewingVariantWithDetails> brewingVariants;

  const TeaWithDetails({
    required this.tea,
    this.flavorProfile,
    this.aromaTags = const [],
    this.tags = const [],
    this.brewingVariants = const [],
  });
}
