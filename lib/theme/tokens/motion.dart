import 'package:flutter/material.dart';

/// SteapLeaf Motion Tokens
///
/// Basiert auf M3's Easing- und Duration-System.
/// Verwendung: `AnimatedContainer(duration: SteapLeafMotion.medium2, curve: SteapLeafMotion.emphasized)`
abstract final class SteapLeafMotion {
  SteapLeafMotion._();

  // Easing Curves

  /// Standard: Elemente die ihre Position ändern
  static const Curve standard = Cubic(0.2, 0.0, 0.0, 1.0);

  /// Standard Accelerate: Elemente die den Screen verlassen
  static const Curve standardAccelerate = Cubic(0.3, 0.0, 1.0, 1.0);

  /// Standard Decelerate: Elemente die den Screen betreten
  static const Curve standardDecelerate = Cubic(0.0, 0.0, 0.0, 1.0);

  /// Emphasized: Wichtige Transitions (Container-Transform, Screen-Wechsel)
  static const Curve emphasized = Cubic(0.2, 0.0, 0.0, 1.0);

  /// Emphasized Accelerate: Elemente die wichtig und schnell verschwinden
  static const Curve emphasizedAccelerate = Cubic(0.3, 0.0, 0.8, 0.15);

  /// Emphasized Decelerate: Elemente die wichtig und sanft ankommen
  static const Curve emphasizedDecelerate = Cubic(0.05, 0.7, 0.1, 1.0);

  // Duration Scale

  /// 50ms – Micro-Feedback: Ripple, State-Layer
  static const Duration short1 = Duration(milliseconds: 50);

  /// 100ms – Kleine UI-Reaktionen: Checkbox, Switch
  static const Duration short2 = Duration(milliseconds: 100);

  /// 150ms – Chips ein-/ausblenden, Badge-Erscheinen
  static const Duration short3 = Duration(milliseconds: 150);

  /// 200ms – Buttons, Icon-Wechsel, Tooltip
  static const Duration short4 = Duration(milliseconds: 200);

  /// 250ms – Snackbar, Floating-Timer-Bar einblenden
  static const Duration medium1 = Duration(milliseconds: 250);

  /// 300ms – Dialoge, Bottom Sheets öffnen
  static const Duration medium2 = Duration(milliseconds: 300);

  /// 350ms – Tab-Wechsel, Accordion auf-/zuklappen
  static const Duration medium3 = Duration(milliseconds: 350);

  /// 400ms – Standard Screen-Transition
  static const Duration medium4 = Duration(milliseconds: 400);

  /// 450ms – Container-Transform (Liste → Detail)
  static const Duration long1 = Duration(milliseconds: 450);

  /// 500ms – FAB → Neuer-Tee-Screen Transition
  static const Duration long2 = Duration(milliseconds: 500);

  // SteapLeaf Custom

  /// 800ms – Sanfter Timer-Arc-Update (ein Tick des Timers)
  static const Duration timerTick = Duration(milliseconds: 800);

  // Semantische Aliase (für Lesbarkeit im Code)

  /// Für Buttons und kleine interaktive Elemente
  static const Duration button            = short4;

  /// Für Chips, Badges, Filter-Aktualisierungen
  static const Duration chip              = short3;

  /// Für das Ein-/Ausblenden der Floating-Timer-Bar
  static const Duration timerBarEnter     = medium1;

  /// Für das Öffnen von Bottom Sheets (Brühparameter-Anpassung)
  static const Duration bottomSheetOpen   = medium2;

  /// Für Tab-Wechsel (Journal, Tee-Erfassung)
  static const Duration tabSwitch         = medium3;

  /// Für Screen-Übergänge im Session-Flow
  static const Duration screenTransition  = medium4;

  /// Für Container-Transform (Teesammlung → Tee-Detail)
  static const Duration containerTransform = long1;

  // Semantische Curve-Aliase

  /// Für Elemente die in den Screen hereinkommen
  static const Curve enter = emphasizedDecelerate;

  /// Für Elemente die den Screen verlassen
  static const Curve exit  = emphasizedAccelerate;

  /// Für persistente Elemente (Slider, Timer-Arc)
  static const Curve persist = standard;
}
