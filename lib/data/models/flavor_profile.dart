import 'enums.dart';

class FlavorProfile {
  final int? id;
  final double? floral;
  final double? fruity;
  final double? vegetal;
  final double? spicy;
  final double? earthy;
  final double? roasted;
  final double? herbal;
  final double? sweet;
  final double? sour;
  final double? bitter;
  final double? umami;
  final double? salty;
  final double? body;
  final Texture? texture;
  final double? astringency;
  final double? finishLength;

  const FlavorProfile({
    this.id,
    this.floral,
    this.fruity,
    this.vegetal,
    this.spicy,
    this.earthy,
    this.roasted,
    this.herbal,
    this.sweet,
    this.sour,
    this.bitter,
    this.umami,
    this.salty,
    this.body,
    this.texture,
    this.astringency,
    this.finishLength,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'floral': floral,
        'fruity': fruity,
        'vegetal': vegetal,
        'spicy': spicy,
        'earthy': earthy,
        'roasted': roasted,
        'herbal': herbal,
        'sweet': sweet,
        'sour': sour,
        'bitter': bitter,
        'umami': umami,
        'salty': salty,
        'body': body,
        'texture': texture?.dbValue,
        'astringency': astringency,
        'finishLength': finishLength,
      };

  factory FlavorProfile.fromMap(Map<String, Object?> map) => FlavorProfile(
        id: map['id'] as int?,
        floral: (map['floral'] as num?)?.toDouble(),
        fruity: (map['fruity'] as num?)?.toDouble(),
        vegetal: (map['vegetal'] as num?)?.toDouble(),
        spicy: (map['spicy'] as num?)?.toDouble(),
        earthy: (map['earthy'] as num?)?.toDouble(),
        roasted: (map['roasted'] as num?)?.toDouble(),
        herbal: (map['herbal'] as num?)?.toDouble(),
        sweet: (map['sweet'] as num?)?.toDouble(),
        sour: (map['sour'] as num?)?.toDouble(),
        bitter: (map['bitter'] as num?)?.toDouble(),
        umami: (map['umami'] as num?)?.toDouble(),
        salty: (map['salty'] as num?)?.toDouble(),
        body: (map['body'] as num?)?.toDouble(),
        texture: Texture.fromDb(map['texture'] as String?),
        astringency: (map['astringency'] as num?)?.toDouble(),
        finishLength: (map['finishLength'] as num?)?.toDouble(),
      );
}

class FlavorProfileAromaTag {
  final int? id;
  final int flavorProfileId;
  final Aroma aroma;
  final String tag;

  const FlavorProfileAromaTag({
    this.id,
    required this.flavorProfileId,
    required this.aroma,
    required this.tag,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'flavorProfileId': flavorProfileId,
        'aroma': aroma.dbValue,
        'tag': tag,
      };

  factory FlavorProfileAromaTag.fromMap(Map<String, Object?> map) =>
      FlavorProfileAromaTag(
        id: map['id'] as int?,
        flavorProfileId: map['flavorProfileId'] as int,
        aroma: Aroma.fromDb(map['aroma'] as String),
        tag: map['tag'] as String,
      );
}
