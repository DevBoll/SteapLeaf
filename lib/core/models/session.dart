import 'dart:convert';

import 'enums.dart';
import 'flavor_profile.dart';
import 'brewing_parameters.dart';
import 'infusion.dart';

/// Manuell eingegebener (externer) Tee, wenn die Session ohne Bezug
/// auf einen Tee aus der Sammlung läuft.
class ExternalTea {
  final String name;
  final TeaType type;

  const ExternalTea({required this.name, required this.type});

  ExternalTea copyWith({String? name, TeaType? type}) =>
      ExternalTea(name: name ?? this.name, type: type ?? this.type);
}

/// Eine konkrete Brüh-Session (Verkostung oder einfache Session).
class Session {
  final String id;
  final DateTime dateTime;
  final SessionType sessionType;
  final String? teaId;                     // Referenz auf Tea oder null
  final String? brewingVariantId;          // Ursprung, nur für Statistik
  final ExternalTea? externalTea;          // bei manueller Eingabe
  final SessionStatus status;
  final BrewingType brewingType;           // Snapshot
  final BrewingParameters brewingParameters; // Snapshot
  final List<Infusion> infusions;
  final int rating;                        // 0 = nicht bewertet, 1..5
  final String notes;
  final FlavorProfile flavorProfile;
  final bool isManual;
  final DateTime start;
  final DateTime? end;

  const Session({
    required this.id,
    required this.dateTime,
    required this.sessionType,
    this.teaId,
    this.brewingVariantId,
    this.externalTea,
    required this.status,
    required this.brewingType,
    this.brewingParameters = BrewingParameters.empty,
    this.infusions = const [],
    this.rating = 0,
    this.notes = '',
    this.flavorProfile = FlavorProfile.empty,
    this.isManual = false,
    required this.start,
    this.end,
  });

  Session copyWith({
    String? id,
    DateTime? dateTime,
    SessionType? sessionType,
    String? teaId,
    String? brewingVariantId,
    ExternalTea? externalTea,
    bool clearTeaId = false,
    bool clearBrewingVariantId = false,
    bool clearExternalTea = false,
    SessionStatus? status,
    BrewingType? brewingType,
    BrewingParameters? brewingParameters,
    List<Infusion>? infusions,
    int? rating,
    String? notes,
    FlavorProfile? flavorProfile,
    bool? isManual,
    DateTime? start,
    DateTime? end,
    bool clearEnd = false,
  }) {
    return Session(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      sessionType: sessionType ?? this.sessionType,
      teaId: clearTeaId ? null : (teaId ?? this.teaId),
      brewingVariantId: clearBrewingVariantId
          ? null
          : (brewingVariantId ?? this.brewingVariantId),
      externalTea:
          clearExternalTea ? null : (externalTea ?? this.externalTea),
      status: status ?? this.status,
      brewingType: brewingType ?? this.brewingType,
      brewingParameters: brewingParameters ?? this.brewingParameters,
      infusions: infusions ?? this.infusions,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      flavorProfile: flavorProfile ?? this.flavorProfile,
      isManual: isManual ?? this.isManual,
      start: start ?? this.start,
      end: clearEnd ? null : (end ?? this.end),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'date_time': dateTime.toIso8601String(),
        'session_type': sessionType.name,
        'tea_id': teaId,
        'brewing_variant_id': brewingVariantId,
        'external_tea_name': externalTea?.name,
        'external_tea_type': externalTea?.type.name,
        'status': status.name,
        'brewing_type': brewingType.name,
        'brewing_parameters': jsonEncode(brewingParameters.toJson()),
        'rating': rating,
        'notes': notes,
        'flavor_profile': jsonEncode(flavorProfile.toJson()),
        'is_manual': isManual ? 1 : 0,
        'start_time': start.toIso8601String(),
        'end_time': end?.toIso8601String(),
      };

  factory Session.fromMap(
    Map<String, dynamic> m, {
    List<Infusion> infusions = const [],
  }) {
    final extName = m['external_tea_name'] as String?;
    final extTypeName = m['external_tea_type'] as String?;
    final externalTea = (extName != null)
        ? ExternalTea(
            name: extName,
            type: enumFromName(TeaType.values, extTypeName, TeaType.other),
          )
        : null;

    return Session(
      id: m['id'] as String,
      dateTime: DateTime.parse(m['date_time'] as String),
      sessionType: enumFromName(
        SessionType.values,
        m['session_type'] as String?,
        SessionType.simple,
      ),
      teaId: m['tea_id'] as String?,
      brewingVariantId: m['brewing_variant_id'] as String?,
      externalTea: externalTea,
      status: enumFromName(
        SessionStatus.values,
        m['status'] as String?,
        SessionStatus.completed,
      ),
      brewingType: enumFromName(
        BrewingType.values,
        m['brewing_type'] as String?,
        BrewingType.western,
      ),
      brewingParameters:
          _decodeParameters(m['brewing_parameters'] as String?),
      infusions: infusions,
      rating: (m['rating'] as int?) ?? 0,
      notes: (m['notes'] as String?) ?? '',
      flavorProfile: _decodeFlavor(m['flavor_profile'] as String?),
      isManual: (m['is_manual'] as int? ?? 0) == 1,
      start: DateTime.parse(m['start_time'] as String),
      end: m['end_time'] != null
          ? DateTime.parse(m['end_time'] as String)
          : null,
    );
  }

  static BrewingParameters _decodeParameters(String? raw) {
    if (raw == null || raw.isEmpty) return BrewingParameters.empty;
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return BrewingParameters.fromJson(decoded);
    }
    return BrewingParameters.empty;
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
