import 'enums.dart';

class BrewingVariant {
  final int? id;
  final int teaId;
  final String name;
  final BrewingType brewingType;
  final int? brewingParametersId;
  final bool isDefault;
  final String? notes;

  const BrewingVariant({
    this.id,
    required this.teaId,
    required this.name,
    required this.brewingType,
    this.brewingParametersId,
    this.isDefault = false,
    this.notes,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'teaId': teaId,
        'name': name,
        'brewingType': brewingType.dbValue,
        'brewingParametersId': brewingParametersId,
        'isDefault': isDefault ? 1 : 0,
        'notes': notes,
      };

  factory BrewingVariant.fromMap(Map<String, Object?> map) => BrewingVariant(
        id: map['id'] as int?,
        teaId: map['teaId'] as int,
        name: map['name'] as String,
        brewingType: BrewingType.fromDb(map['brewingType'] as String),
        brewingParametersId: map['brewingParametersId'] as int?,
        isDefault: ((map['isDefault'] as int?) ?? 0) != 0,
        notes: map['notes'] as String?,
      );

  BrewingVariant copyWith({
    int? id,
    int? teaId,
    String? name,
    BrewingType? brewingType,
    int? brewingParametersId,
    bool? isDefault,
    String? notes,
  }) =>
      BrewingVariant(
        id: id ?? this.id,
        teaId: teaId ?? this.teaId,
        name: name ?? this.name,
        brewingType: brewingType ?? this.brewingType,
        brewingParametersId: brewingParametersId ?? this.brewingParametersId,
        isDefault: isDefault ?? this.isDefault,
        notes: notes ?? this.notes,
      );
}

class BrewingParameters {
  final int? id;
  final double? teaGrams;
  final double? waterMl;
  final ColdBrewLocation? coldBrewLocation;
  final int? minColdSteepSeconds;
  final int? maxColdSteepSeconds;
  final int? whiskSeconds;

  const BrewingParameters({
    this.id,
    this.teaGrams,
    this.waterMl,
    this.coldBrewLocation,
    this.minColdSteepSeconds,
    this.maxColdSteepSeconds,
    this.whiskSeconds,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'teaGrams': teaGrams,
        'waterMl': waterMl,
        'coldBrewLocation': coldBrewLocation?.dbValue,
        'minColdSteepSeconds': minColdSteepSeconds,
        'maxColdSteepSeconds': maxColdSteepSeconds,
        'whiskSeconds': whiskSeconds,
      };

  factory BrewingParameters.fromMap(Map<String, Object?> map) =>
      BrewingParameters(
        id: map['id'] as int?,
        teaGrams: (map['teaGrams'] as num?)?.toDouble(),
        waterMl: (map['waterMl'] as num?)?.toDouble(),
        coldBrewLocation:
            ColdBrewLocation.fromDb(map['coldBrewLocation'] as String?),
        minColdSteepSeconds: map['minColdSteepSeconds'] as int?,
        maxColdSteepSeconds: map['maxColdSteepSeconds'] as int?,
        whiskSeconds: map['whiskSeconds'] as int?,
      );
}

class BrewingStep {
  final int? id;
  final int brewingParametersId;
  final int stepIndex;
  final bool isRinse;
  final int? steepSeconds;
  final double? temperatureCelsius;

  const BrewingStep({
    this.id,
    required this.brewingParametersId,
    required this.stepIndex,
    this.isRinse = false,
    this.steepSeconds,
    this.temperatureCelsius,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'brewingParametersId': brewingParametersId,
        'stepIndex': stepIndex,
        'isRinse': isRinse ? 1 : 0,
        'steepSeconds': steepSeconds,
        'temperatureCelsius': temperatureCelsius,
      };

  factory BrewingStep.fromMap(Map<String, Object?> map) => BrewingStep(
        id: map['id'] as int?,
        brewingParametersId: map['brewingParametersId'] as int,
        stepIndex: map['stepIndex'] as int,
        isRinse: ((map['isRinse'] as int?) ?? 0) != 0,
        steepSeconds: map['steepSeconds'] as int?,
        temperatureCelsius: (map['temperatureCelsius'] as num?)?.toDouble(),
      );
}

class BrewingAdditive {
  final int? id;
  final int brewingParametersId;
  final String name;
  final String? amount;

  const BrewingAdditive({
    this.id,
    required this.brewingParametersId,
    required this.name,
    this.amount,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'brewingParametersId': brewingParametersId,
        'name': name,
        'amount': amount,
      };

  factory BrewingAdditive.fromMap(Map<String, Object?> map) => BrewingAdditive(
        id: map['id'] as int?,
        brewingParametersId: map['brewingParametersId'] as int,
        name: map['name'] as String,
        amount: map['amount'] as String?,
      );
}

class BrewingVariantWithDetails {
  final BrewingVariant variant;
  final BrewingParameters? parameters;
  final List<BrewingStep> steps;
  final List<BrewingAdditive> additives;

  const BrewingVariantWithDetails({
    required this.variant,
    this.parameters,
    this.steps = const [],
    this.additives = const [],
  });
}
