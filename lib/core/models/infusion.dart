import 'dart:convert';

import 'enums.dart';
import 'flavor_profile.dart';

/// Tatsächlich durchgeführter Aufguss innerhalb einer Session.
/// (Geplante Aufgüsse stecken als `BrewingStep` in den Parametern.)
class Infusion {
  final String id;
  final String sessionId;
  final int index;
  final InfusionType type;
  final int steepSeconds;
  final DateTime start;
  final DateTime? end;
  final int rating; // 0 = nicht bewertet, 1..5
  final String notes;
  final FlavorProfile flavorProfile;

  const Infusion({
    required this.id,
    required this.sessionId,
    required this.index,
    required this.type,
    required this.steepSeconds,
    required this.start,
    this.end,
    this.rating = 0,
    this.notes = '',
    this.flavorProfile = FlavorProfile.empty,
  });

  Infusion copyWith({
    String? id,
    String? sessionId,
    int? index,
    InfusionType? type,
    int? steepSeconds,
    DateTime? start,
    DateTime? end,
    bool clearEnd = false,
    int? rating,
    String? notes,
    FlavorProfile? flavorProfile,
  }) {
    return Infusion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      index: index ?? this.index,
      type: type ?? this.type,
      steepSeconds: steepSeconds ?? this.steepSeconds,
      start: start ?? this.start,
      end: clearEnd ? null : (end ?? this.end),
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      flavorProfile: flavorProfile ?? this.flavorProfile,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'session_id': sessionId,
        'idx': index,
        'type': type.name,
        'steep_seconds': steepSeconds,
        'start_time': start.toIso8601String(),
        'end_time': end?.toIso8601String(),
        'rating': rating,
        'notes': notes,
        'flavor_profile': jsonEncode(flavorProfile.toJson()),
      };

  factory Infusion.fromMap(Map<String, dynamic> m) {
    return Infusion(
      id: m['id'] as String,
      sessionId: m['session_id'] as String,
      index: (m['idx'] as int?) ?? 0,
      type: enumFromName(
        InfusionType.values,
        m['type'] as String?,
        InfusionType.drink,
      ),
      steepSeconds: (m['steep_seconds'] as int?) ?? 0,
      start: DateTime.parse(m['start_time'] as String),
      end: m['end_time'] != null
          ? DateTime.parse(m['end_time'] as String)
          : null,
      rating: (m['rating'] as int?) ?? 0,
      notes: (m['notes'] as String?) ?? '',
      flavorProfile: _decodeFlavor(m['flavor_profile'] as String?),
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
