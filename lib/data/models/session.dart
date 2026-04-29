import 'brewing.dart';
import 'enums.dart';
import 'flavor_profile.dart';

class Session {
  final int? id;
  final DateTime timestamp;
  final SessionType sessionType;
  final SessionStatus sessionStatus;
  final int? teaId;
  final String? externalTeaName;
  final String? externalTeaType;
  final int? brewingVariantId;
  final int? brewingParametersId;
  final double? rating;
  final String? notes;
  final int? flavorProfileId;
  final bool isManual;
  final DateTime? start;
  final DateTime? end;

  const Session({
    this.id,
    required this.timestamp,
    required this.sessionType,
    this.sessionStatus = SessionStatus.planned,
    this.teaId,
    this.externalTeaName,
    this.externalTeaType,
    this.brewingVariantId,
    this.brewingParametersId,
    this.rating,
    this.notes,
    this.flavorProfileId,
    this.isManual = false,
    this.start,
    this.end,
  }) : assert(teaId != null || externalTeaName != null,
            'Either teaId or externalTeaName must be provided');

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'timestamp': timestamp.toIso8601String(),
        'sessionType': sessionType.dbValue,
        'sessionStatus': sessionStatus.dbValue,
        'teaId': teaId,
        'externalTeaName': externalTeaName,
        'externalTeaType': externalTeaType,
        'brewingVariantId': brewingVariantId,
        'brewingParametersId': brewingParametersId,
        'rating': rating,
        'notes': notes,
        'flavorProfileId': flavorProfileId,
        'isManual': isManual ? 1 : 0,
        'start': start?.toIso8601String(),
        'end': end?.toIso8601String(),
      };

  factory Session.fromMap(Map<String, Object?> map) => Session(
        id: map['id'] as int?,
        timestamp: DateTime.parse(map['timestamp'] as String),
        sessionType: SessionType.fromDb(map['sessionType'] as String),
        sessionStatus: SessionStatus.fromDb(map['sessionStatus'] as String),
        teaId: map['teaId'] as int?,
        externalTeaName: map['externalTeaName'] as String?,
        externalTeaType: map['externalTeaType'] as String?,
        brewingVariantId: map['brewingVariantId'] as int?,
        brewingParametersId: map['brewingParametersId'] as int?,
        rating: (map['rating'] as num?)?.toDouble(),
        notes: map['notes'] as String?,
        flavorProfileId: map['flavorProfileId'] as int?,
        isManual: ((map['isManual'] as int?) ?? 0) != 0,
        start: _parseDate(map['start']),
        end: _parseDate(map['end']),
      );

  Session copyWith({
    int? id,
    DateTime? timestamp,
    SessionType? sessionType,
    SessionStatus? sessionStatus,
    int? teaId,
    String? externalTeaName,
    String? externalTeaType,
    int? brewingVariantId,
    int? brewingParametersId,
    double? rating,
    String? notes,
    int? flavorProfileId,
    bool? isManual,
    DateTime? start,
    DateTime? end,
  }) =>
      Session(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        sessionType: sessionType ?? this.sessionType,
        sessionStatus: sessionStatus ?? this.sessionStatus,
        teaId: teaId ?? this.teaId,
        externalTeaName: externalTeaName ?? this.externalTeaName,
        externalTeaType: externalTeaType ?? this.externalTeaType,
        brewingVariantId: brewingVariantId ?? this.brewingVariantId,
        brewingParametersId: brewingParametersId ?? this.brewingParametersId,
        rating: rating ?? this.rating,
        notes: notes ?? this.notes,
        flavorProfileId: flavorProfileId ?? this.flavorProfileId,
        isManual: isManual ?? this.isManual,
        start: start ?? this.start,
        end: end ?? this.end,
      );

  static DateTime? _parseDate(Object? v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}

class Infusion {
  final int? id;
  final int sessionId;
  final int infusionIndex;
  final bool isRinse;
  final int? steepSeconds;
  final DateTime? start;
  final DateTime? end;
  final double? rating;
  final String? notes;
  final int? flavorProfileId;

  const Infusion({
    this.id,
    required this.sessionId,
    required this.infusionIndex,
    this.isRinse = false,
    this.steepSeconds,
    this.start,
    this.end,
    this.rating,
    this.notes,
    this.flavorProfileId,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'sessionId': sessionId,
        'infusionIndex': infusionIndex,
        'isRinse': isRinse ? 1 : 0,
        'steepSeconds': steepSeconds,
        'start': start?.toIso8601String(),
        'end': end?.toIso8601String(),
        'rating': rating,
        'notes': notes,
        'flavorProfileId': flavorProfileId,
      };

  factory Infusion.fromMap(Map<String, Object?> map) => Infusion(
        id: map['id'] as int?,
        sessionId: map['sessionId'] as int,
        infusionIndex: map['infusionIndex'] as int,
        isRinse: ((map['isRinse'] as int?) ?? 0) != 0,
        steepSeconds: map['steepSeconds'] as int?,
        start: _parseDate(map['start']),
        end: _parseDate(map['end']),
        rating: (map['rating'] as num?)?.toDouble(),
        notes: map['notes'] as String?,
        flavorProfileId: map['flavorProfileId'] as int?,
      );

  Infusion copyWith({
    int? id,
    int? sessionId,
    int? infusionIndex,
    bool? isRinse,
    int? steepSeconds,
    DateTime? start,
    DateTime? end,
    double? rating,
    String? notes,
    int? flavorProfileId,
  }) =>
      Infusion(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        infusionIndex: infusionIndex ?? this.infusionIndex,
        isRinse: isRinse ?? this.isRinse,
        steepSeconds: steepSeconds ?? this.steepSeconds,
        start: start ?? this.start,
        end: end ?? this.end,
        rating: rating ?? this.rating,
        notes: notes ?? this.notes,
        flavorProfileId: flavorProfileId ?? this.flavorProfileId,
      );

  static DateTime? _parseDate(Object? v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}

class SessionWithDetails {
  final Session session;
  final BrewingParameters? parameters;
  final List<BrewingStep> steps;
  final List<BrewingAdditive> additives;
  final FlavorProfile? flavorProfile;
  final List<FlavorProfileAromaTag> aromaTags;
  final List<InfusionWithDetails> infusions;

  const SessionWithDetails({
    required this.session,
    this.parameters,
    this.steps = const [],
    this.additives = const [],
    this.flavorProfile,
    this.aromaTags = const [],
    this.infusions = const [],
  });
}

class InfusionWithDetails {
  final Infusion infusion;
  final FlavorProfile? flavorProfile;
  final List<FlavorProfileAromaTag> aromaTags;

  const InfusionWithDetails({
    required this.infusion,
    this.flavorProfile,
    this.aromaTags = const [],
  });
}
