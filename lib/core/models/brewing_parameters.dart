import 'enums.dart';

/// Geplanter / durchgeführter Aufguss-Eintrag in den Parametern.
/// In einer Session gibt es zusätzlich `Infusion` mit Start-/End-Zeit.
class BrewingStep {
  final int steepSeconds;
  final InfusionType type;

  const BrewingStep({required this.steepSeconds, required this.type});

  BrewingStep copyWith({int? steepSeconds, InfusionType? type}) =>
      BrewingStep(
        steepSeconds: steepSeconds ?? this.steepSeconds,
        type: type ?? this.type,
      );

  Map<String, dynamic> toJson() => {
        'steepSeconds': steepSeconds,
        'type': type.name,
      };

  factory BrewingStep.fromJson(Map<String, dynamic> j) => BrewingStep(
        steepSeconds: (j['steepSeconds'] as num?)?.toInt() ?? 0,
        type: enumFromName(
          InfusionType.values,
          j['type'] as String?,
          InfusionType.drink,
        ),
      );
}

/// Zusatz / Additiv mit Menge und Einheit (z. B. "Zucker", 5.0, "g").
class Additive {
  final String name;
  final double amount;
  final String unit;

  const Additive({
    required this.name,
    required this.amount,
    required this.unit,
  });

  Additive copyWith({String? name, double? amount, String? unit}) => Additive(
        name: name ?? this.name,
        amount: amount ?? this.amount,
        unit: unit ?? this.unit,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'unit': unit,
      };

  factory Additive.fromJson(Map<String, dynamic> j) => Additive(
        name: j['name'] as String? ?? '',
        amount: (j['amount'] as num?)?.toDouble() ?? 0,
        unit: j['unit'] as String? ?? '',
      );
}

/// Brüh-Parameter – eingebettetes Wert-Objekt.
/// Wird als JSON in `brewing_variants.parameters` und
/// `sessions.brewing_parameters` (Snapshot) gespeichert.
class BrewingParameters {
  final double teaGrams;            // Tee in Gramm
  final double waterMl;             // Wasser in ml
  final double temperatureCelsius;  // Temperatur in °C
  final List<BrewingStep> steps;    // geplante Aufgüsse
  final int whiskSeconds;           // Whisk-Zeit (matcha)
  final List<Additive> additives;   // Zusätze
  // Cold-Brew-spezifisch (sonst null):
  final ColdBrewLocation? coldBrewLocation;
  final int? minColdSteepSeconds;
  final int? maxColdSteepSeconds;

  const BrewingParameters({
    this.teaGrams = 0,
    this.waterMl = 0,
    this.temperatureCelsius = 0,
    this.steps = const [],
    this.whiskSeconds = 0,
    this.additives = const [],
    this.coldBrewLocation,
    this.minColdSteepSeconds,
    this.maxColdSteepSeconds,
  });

  static const empty = BrewingParameters();

  BrewingParameters copyWith({
    double? teaGrams,
    double? waterMl,
    double? temperatureCelsius,
    List<BrewingStep>? steps,
    int? whiskSeconds,
    List<Additive>? additives,
    ColdBrewLocation? coldBrewLocation,
    int? minColdSteepSeconds,
    int? maxColdSteepSeconds,
    bool clearColdBrew = false,
  }) {
    return BrewingParameters(
      teaGrams: teaGrams ?? this.teaGrams,
      waterMl: waterMl ?? this.waterMl,
      temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
      steps: steps ?? this.steps,
      whiskSeconds: whiskSeconds ?? this.whiskSeconds,
      additives: additives ?? this.additives,
      coldBrewLocation:
          clearColdBrew ? null : (coldBrewLocation ?? this.coldBrewLocation),
      minColdSteepSeconds: clearColdBrew
          ? null
          : (minColdSteepSeconds ?? this.minColdSteepSeconds),
      maxColdSteepSeconds: clearColdBrew
          ? null
          : (maxColdSteepSeconds ?? this.maxColdSteepSeconds),
    );
  }

  Map<String, dynamic> toJson() => {
        'teaGrams': teaGrams,
        'waterMl': waterMl,
        'temperatureCelsius': temperatureCelsius,
        'steps': steps.map((s) => s.toJson()).toList(),
        'whiskSeconds': whiskSeconds,
        'additives': additives.map((a) => a.toJson()).toList(),
        'coldBrewLocation': coldBrewLocation?.name,
        'minColdSteepSeconds': minColdSteepSeconds,
        'maxColdSteepSeconds': maxColdSteepSeconds,
      };

  factory BrewingParameters.fromJson(Map<String, dynamic> j) {
    return BrewingParameters(
      teaGrams: (j['teaGrams'] as num?)?.toDouble() ?? 0,
      waterMl: (j['waterMl'] as num?)?.toDouble() ?? 0,
      temperatureCelsius: (j['temperatureCelsius'] as num?)?.toDouble() ?? 0,
      steps: (j['steps'] as List?)
              ?.map((s) => BrewingStep.fromJson(Map<String, dynamic>.from(s)))
              .toList() ??
          const [],
      whiskSeconds: (j['whiskSeconds'] as num?)?.toInt() ?? 0,
      additives: (j['additives'] as List?)
              ?.map((a) => Additive.fromJson(Map<String, dynamic>.from(a)))
              .toList() ??
          const [],
      coldBrewLocation: enumFromNameOrNull(
        ColdBrewLocation.values,
        j['coldBrewLocation'] as String?,
      ),
      minColdSteepSeconds: (j['minColdSteepSeconds'] as num?)?.toInt(),
      maxColdSteepSeconds: (j['maxColdSteepSeconds'] as num?)?.toInt(),
    );
  }
}
