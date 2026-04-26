abstract final class TastingTags {
  static const List<String> texture = ['seidig', 'ölig', 'cremig', 'wässrig'];
}

bool _listStrEq(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

// Aroma

class AromaAxis {
  final int intensity; // 0..5

  const AromaAxis({this.intensity = 0});

  bool get isEmpty => intensity == 0;

  AromaAxis copyWith({int? intensity}) =>
      AromaAxis(intensity: intensity ?? this.intensity);

  Map<String, dynamic> toJson() => {'intensity': intensity};

  factory AromaAxis.fromJson(Map<String, dynamic> json) =>
      AromaAxis(intensity: json['intensity'] as int? ?? 0);

  @override
  bool operator ==(Object other) =>
      other is AromaAxis && intensity == other.intensity;

  @override
  int get hashCode => intensity.hashCode;
}

class AromaProfile {
  final AromaAxis floral;
  final AromaAxis fruity;
  final AromaAxis green;
  final AromaAxis spicy;
  final AromaAxis woody;
  final AromaAxis roasted;
  final AromaAxis herbal;

  const AromaProfile({
    this.floral  = const AromaAxis(),
    this.fruity  = const AromaAxis(),
    this.green   = const AromaAxis(),
    this.spicy   = const AromaAxis(),
    this.woody   = const AromaAxis(),
    this.roasted = const AromaAxis(),
    this.herbal  = const AromaAxis(),
  });

  bool get isEmpty =>
      floral.isEmpty && fruity.isEmpty && green.isEmpty &&
      spicy.isEmpty  && woody.isEmpty  && roasted.isEmpty && herbal.isEmpty;

  bool get isNotEmpty => !isEmpty;

  List<double> get intensities => [
        floral.intensity.toDouble(),
        fruity.intensity.toDouble(),
        green.intensity.toDouble(),
        spicy.intensity.toDouble(),
        woody.intensity.toDouble(),
        roasted.intensity.toDouble(),
        herbal.intensity.toDouble(),
      ];

  static const List<String> axisLabels = [
    'Blumig', 'Fruchtig', 'Grasig', 'Würzig', 'Holzig/Erdig', 'Geröstet/Süß', 'Kräuterartig',
  ];

  List<({String key, String label, AromaAxis axis})> get axes => [
        (key: 'floral',  label: 'Blumig',       axis: floral),
        (key: 'fruity',  label: 'Fruchtig',      axis: fruity),
        (key: 'green',   label: 'Grasig',        axis: green),
        (key: 'spicy',   label: 'Würzig',        axis: spicy),
        (key: 'woody',   label: 'Holzig/Erdig',  axis: woody),
        (key: 'roasted', label: 'Geröstet/Süß',  axis: roasted),
        (key: 'herbal',  label: 'Kräuterartig',  axis: herbal),
      ];

  AromaProfile copyWith({
    AromaAxis? floral, AromaAxis? fruity, AromaAxis? green,
    AromaAxis? spicy,  AromaAxis? woody,  AromaAxis? roasted, AromaAxis? herbal,
  }) =>
      AromaProfile(
        floral:  floral  ?? this.floral,
        fruity:  fruity  ?? this.fruity,
        green:   green   ?? this.green,
        spicy:   spicy   ?? this.spicy,
        woody:   woody   ?? this.woody,
        roasted: roasted ?? this.roasted,
        herbal:  herbal  ?? this.herbal,
      );

  AromaProfile withAxis(String key, AromaAxis axis) => copyWith(
        floral:  key == 'floral'  ? axis : null,
        fruity:  key == 'fruity'  ? axis : null,
        green:   key == 'green'   ? axis : null,
        spicy:   key == 'spicy'   ? axis : null,
        woody:   key == 'woody'   ? axis : null,
        roasted: key == 'roasted' ? axis : null,
        herbal:  key == 'herbal'  ? axis : null,
      );

  Map<String, dynamic> toJson() => {
        'floral':  floral.toJson(),
        'fruity':  fruity.toJson(),
        'green':   green.toJson(),
        'spicy':   spicy.toJson(),
        'woody':   woody.toJson(),
        'roasted': roasted.toJson(),
        'herbal':  herbal.toJson(),
      };

  factory AromaProfile.fromJson(Map<String, dynamic> json) => AromaProfile(
        floral:  AromaAxis.fromJson(json['floral']  as Map<String, dynamic>? ?? {}),
        fruity:  AromaAxis.fromJson(json['fruity']  as Map<String, dynamic>? ?? {}),
        green:   AromaAxis.fromJson(json['green']   as Map<String, dynamic>? ?? {}),
        spicy:   AromaAxis.fromJson(json['spicy']   as Map<String, dynamic>? ?? {}),
        woody:   AromaAxis.fromJson(json['woody']   as Map<String, dynamic>? ?? {}),
        roasted: AromaAxis.fromJson(json['roasted'] as Map<String, dynamic>? ?? {}),
        herbal:  AromaAxis.fromJson(json['herbal']  as Map<String, dynamic>? ?? {}),
      );

  @override
  bool operator ==(Object other) =>
      other is AromaProfile &&
      floral == other.floral && fruity == other.fruity &&
      green  == other.green  && spicy  == other.spicy  &&
      woody  == other.woody  && roasted == other.roasted && herbal == other.herbal;

  @override
  int get hashCode =>
      Object.hash(floral, fruity, green, spicy, woody, roasted, herbal);
}

// Taste

class TasteProfile {
  final int sweet;
  final int sour;
  final int bitter;
  final int umami;
  final int salty;

  const TasteProfile({
    this.sweet  = 0,
    this.sour   = 0,
    this.bitter = 0,
    this.umami  = 0,
    this.salty  = 0,
  });

  bool get isEmpty =>
      sweet == 0 && sour == 0 && bitter == 0 && umami == 0 && salty == 0;

  bool get isNotEmpty => !isEmpty;

  List<double> get values => [
        sweet.toDouble(), sour.toDouble(), bitter.toDouble(),
        umami.toDouble(), salty.toDouble(),
      ];

  static const List<String> axisLabels = ['Süß', 'Sauer', 'Bitter', 'Umami', 'Salzig'];

  List<({String label, int value})> get axes => [
        (label: 'Süß',    value: sweet),
        (label: 'Sauer',  value: sour),
        (label: 'Bitter', value: bitter),
        (label: 'Umami',  value: umami),
        (label: 'Salzig', value: salty),
      ];

  TasteProfile copyWith({int? sweet, int? sour, int? bitter, int? umami, int? salty}) =>
      TasteProfile(
        sweet:  sweet  ?? this.sweet,
        sour:   sour   ?? this.sour,
        bitter: bitter ?? this.bitter,
        umami:  umami  ?? this.umami,
        salty:  salty  ?? this.salty,
      );

  Map<String, dynamic> toJson() => {
        'sweet': sweet, 'sour': sour, 'bitter': bitter,
        'umami': umami, 'salty': salty,
      };

  factory TasteProfile.fromJson(Map<String, dynamic> json) => TasteProfile(
        sweet:  json['sweet']  as int? ?? 0,
        sour:   json['sour']   as int? ?? 0,
        bitter: json['bitter'] as int? ?? 0,
        umami:  json['umami']  as int? ?? 0,
        salty:  json['salty']  as int? ?? 0,
      );

  @override
  bool operator ==(Object other) =>
      other is TasteProfile &&
      sweet == other.sweet && sour == other.sour && bitter == other.bitter &&
      umami == other.umami && salty == other.salty;

  @override
  int get hashCode => Object.hash(sweet, sour, bitter, umami, salty);
}

// Mouthfeel

class MouthfeelProfile {
  final int body;         // 0..5
  final List<String> texture; // z.B. ['seidig', 'ölig']
  final int astringency;  // 0..5
  final int finishLength; // 0..5

  const MouthfeelProfile({
    this.body         = 0,
    this.texture      = const [],
    this.astringency  = 0,
    this.finishLength = 0,
  });

  bool get isEmpty =>
      body == 0 && texture.isEmpty && astringency == 0 && finishLength == 0;

  bool get isNotEmpty => !isEmpty;

  MouthfeelProfile copyWith({
    int? body, List<String>? texture, int? astringency, int? finishLength,
  }) =>
      MouthfeelProfile(
        body:         body         ?? this.body,
        texture:      texture      ?? this.texture,
        astringency:  astringency  ?? this.astringency,
        finishLength: finishLength ?? this.finishLength,
      );

  Map<String, dynamic> toJson() => {
        'body': body, 'texture': texture,
        'astringency': astringency, 'finishLength': finishLength,
      };

  factory MouthfeelProfile.fromJson(Map<String, dynamic> json) => MouthfeelProfile(
        body:         json['body']         as int? ?? 0,
        texture:      List<String>.from(json['texture'] as List? ?? []),
        astringency:  json['astringency']  as int? ?? 0,
        finishLength: json['finishLength'] as int? ?? 0,
      );

  @override
  bool operator ==(Object other) =>
      other is MouthfeelProfile &&
      body         == other.body         &&
      _listStrEq(texture, other.texture) &&
      astringency  == other.astringency  &&
      finishLength == other.finishLength;

  @override
  int get hashCode =>
      Object.hash(body, Object.hashAll(texture), astringency, finishLength);
}

class FlavorProfile {
  final AromaProfile    aroma;
  final TasteProfile    taste;
  final MouthfeelProfile mouthfeel;
  /// Freitext-Aroma-Tag-IDs aus der `aroma_tags`-Tabelle.
  final List<String> aromaTagIds;

  const FlavorProfile({
    this.aroma      = const AromaProfile(),
    this.taste      = const TasteProfile(),
    this.mouthfeel  = const MouthfeelProfile(),
    this.aromaTagIds = const [],
  });

  static const empty = FlavorProfile();

  bool get isEmpty => aroma.isEmpty && taste.isEmpty && mouthfeel.isEmpty;
  bool get isNotEmpty => !isEmpty;

  FlavorProfile copyWith({
    AromaProfile?    aroma,
    TasteProfile?    taste,
    MouthfeelProfile? mouthfeel,
    List<String>?    aromaTagIds,
  }) =>
      FlavorProfile(
        aroma:       aroma       ?? this.aroma,
        taste:       taste       ?? this.taste,
        mouthfeel:   mouthfeel   ?? this.mouthfeel,
        aromaTagIds: aromaTagIds ?? this.aromaTagIds,
      );

  Map<String, dynamic> toJson() => {
        'aroma':       aroma.toJson(),
        'taste':       taste.toJson(),
        'mouthfeel':   mouthfeel.toJson(),
        'aromaTagIds': aromaTagIds,
      };

  factory FlavorProfile.fromJson(Map<String, dynamic> json) => FlavorProfile(
        aroma:     AromaProfile.fromJson(
            json['aroma']    as Map<String, dynamic>? ?? {}),
        taste:     TasteProfile.fromJson(
            json['taste']    as Map<String, dynamic>? ?? {}),
        mouthfeel: MouthfeelProfile.fromJson(
            json['mouthfeel'] as Map<String, dynamic>? ?? {}),
        aromaTagIds: (json['aromaTagIds'] as List?)?.cast<String>() ?? const [],
      );

  @override
  bool operator ==(Object other) =>
      other is FlavorProfile &&
      aroma     == other.aroma     &&
      taste     == other.taste     &&
      mouthfeel == other.mouthfeel &&
      _listStrEq(aromaTagIds, other.aromaTagIds);

  @override
  int get hashCode =>
      Object.hash(aroma, taste, mouthfeel, Object.hashAll(aromaTagIds));
}

