import 'dart:convert';

import 'enums.dart';
import 'brewing_parameters.dart';

/// Eine konkrete Brüh-Variante eines Tees (z. B. "Western Standard",
/// "Gong Fu Cha 5g", "Cold Brew Sommer").
class BrewingVariant {
  final String id;
  final String teaId;
  final String name;
  final BrewingType brewingType;
  final BrewingParameters parameters;
  final bool isDefault;
  final String notes;

  const BrewingVariant({
    required this.id,
    required this.teaId,
    required this.name,
    required this.brewingType,
    this.parameters = BrewingParameters.empty,
    this.isDefault = false,
    this.notes = '',
  });

  BrewingVariant copyWith({
    String? id,
    String? teaId,
    String? name,
    BrewingType? brewingType,
    BrewingParameters? parameters,
    bool? isDefault,
    String? notes,
  }) {
    return BrewingVariant(
      id: id ?? this.id,
      teaId: teaId ?? this.teaId,
      name: name ?? this.name,
      brewingType: brewingType ?? this.brewingType,
      parameters: parameters ?? this.parameters,
      isDefault: isDefault ?? this.isDefault,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'tea_id': teaId,
        'name': name,
        'brewing_type': brewingType.name,
        'parameters': jsonEncode(parameters.toJson()),
        'is_default': isDefault ? 1 : 0,
        'notes': notes,
      };

  factory BrewingVariant.fromMap(Map<String, dynamic> m) {
    return BrewingVariant(
      id: m['id'] as String,
      teaId: m['tea_id'] as String,
      name: m['name'] as String,
      brewingType: enumFromName(
        BrewingType.values,
        m['brewing_type'] as String?,
        BrewingType.western,
      ),
      parameters: _decodeParameters(m['parameters'] as String?),
      isDefault: (m['is_default'] as int? ?? 0) == 1,
      notes: (m['notes'] as String?) ?? '',
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
}
