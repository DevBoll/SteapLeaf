import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens/ref_palette.dart';
import 'tokens/tea_type_tokens.dart';
import 'tokens/text_theme.dart';
import 'tokens/shapes.dart';
import 'extensions/steapleaf_theme_extension.dart';

abstract final class SteapLeafTheme {
  SteapLeafTheme._();

  // Color Schemes

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary · Warm Red (Camellia)
    primary:          RefPalette.red30,
    onPrimary:        RefPalette.neutral100,
    primaryContainer: RefPalette.red90,
    onPrimaryContainer: RefPalette.red10,

    // Secondary · Warm Neutral
    secondary:            Color(0xFF7D6E62),
    onSecondary:          RefPalette.neutral100,
    secondaryContainer:   RefPalette.neutralVariant90,
    onSecondaryContainer: RefPalette.neutralVariant30,

    // Tertiary · Muted Gold (für spätere Erweiterung)
    tertiary:            Color(0xFF8B6914),
    onTertiary:          RefPalette.neutral100,
    tertiaryContainer:   Color(0xFFF5DFA0),
    onTertiaryContainer: Color(0xFF2C1F00),

    // Error
    error:            Color(0xFFBA1A1A),
    onError:          RefPalette.neutral100,
    errorContainer:   RefPalette.red90,
    onErrorContainer: RefPalette.red10,

    // Surface & Background
    surface:               RefPalette.neutral100,
    onSurface:             RefPalette.neutral10,
    onSurfaceVariant:      RefPalette.neutralVariant30,
    surfaceContainerLowest:  RefPalette.neutral100,
    surfaceContainerLow:     RefPalette.neutral99,
    surfaceContainer:        Color(0xFFEDE8E0),
    surfaceContainerHigh:    Color(0xFFE5E0D8),
    surfaceContainerHighest: RefPalette.neutral90,

    // Outline
    outline:        RefPalette.neutral60,
    outlineVariant: RefPalette.neutral80,

    // Inverse (für Snackbars)
    inverseSurface:   RefPalette.neutral20,
    onInverseSurface: RefPalette.neutral99,
    inversePrimary:   RefPalette.red80,

    // Scaffold Background = das warme Papier
    shadow:           RefPalette.neutral10,
    scrim:            RefPalette.neutral10,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Primary
    primary:            RefPalette.red80,
    onPrimary:          RefPalette.red20,
    primaryContainer:   RefPalette.red30,
    onPrimaryContainer: RefPalette.red90,

    // Secondary
    secondary:            RefPalette.neutralVariant80,
    onSecondary:          RefPalette.neutralVariant30,
    secondaryContainer:   Color(0xFF52443A),
    onSecondaryContainer: RefPalette.neutralVariant90,

    // Tertiary
    tertiary:            Color(0xFFD4B86A),
    onTertiary:          Color(0xFF3C2F00),
    tertiaryContainer:   Color(0xFF594500),
    onTertiaryContainer: Color(0xFFF5DFA0),

    // Error
    error:            RefPalette.red80,
    onError:          RefPalette.red20,
    errorContainer:   RefPalette.red30,
    onErrorContainer: RefPalette.red90,

    // Surface & Background
    surface:               RefPalette.darkSurface,
    onSurface:             RefPalette.neutral90,
    onSurfaceVariant:      RefPalette.neutralVariant80,
    surfaceContainerLowest:  Color(0xFF18120D),
    surfaceContainerLow:     RefPalette.darkBackground,
    surfaceContainer:        RefPalette.darkSurface,
    surfaceContainerHigh:    Color(0xFF2E271F),
    surfaceContainerHighest: Color(0xFF392F25),

    // Outline
    outline:        RefPalette.darkOutline,
    outlineVariant: RefPalette.neutral30,

    // Inverse
    inverseSurface:   RefPalette.neutral90,
    onInverseSurface: RefPalette.neutral20,
    inversePrimary:   RefPalette.red30,

    shadow:  RefPalette.neutral10,
    scrim:   RefPalette.neutral10,
  );

  // Theme Extension: Light

  static final SteapLeafThemeExtension _lightExtension = SteapLeafThemeExtension(
    // Brand
    starFilled:      RefPalette.red30,
    starEmpty:       RefPalette.neutral80,
    favorite:        RefPalette.red30,
    coldBrewSurface: const Color(0xFFE8F0F8),

    // Slider
    sliderActive:   RefPalette.red30,
    sliderInactive: RefPalette.neutral80,
    sliderThumb:    RefPalette.red30,

    // Step Indicator
    stepIndicatorActive:   RefPalette.red30,
    stepIndicatorInactive: RefPalette.neutral80,

    // Timer
    timerArcActive:             RefPalette.red30,
    timerArcTrack:              RefPalette.neutral80,
    timerBarBackground:         const Color(0xFFE5E0D8),
    timerBarColdBrewBackground: const Color(0xFFE8F0F8),

    // Tea Types (Light)
    teaTypeGreen:   TeaTypeTokens.green,
    teaTypeBlack:   TeaTypeTokens.black,
    teaTypeOolong:  TeaTypeTokens.oolong,
    teaTypeWhite:   TeaTypeTokens.white,
    teaTypePuerh:   TeaTypeTokens.puerh,
    teaTypeHerbal:  TeaTypeTokens.herbal,
    teaTypeFruit:   TeaTypeTokens.fruit,
    teaTypeRooibos: TeaTypeTokens.rooibos,
    teaTypeYellow:  TeaTypeTokens.yellow,
  );

  static final SteapLeafThemeExtension _darkExtension = SteapLeafThemeExtension(
    // Brand
    starFilled:      RefPalette.red80,
    starEmpty:       RefPalette.neutral30,
    favorite:        RefPalette.red80,
    coldBrewSurface: const Color(0xFF1A2430),

    // Slider
    sliderActive:   RefPalette.red80,
    sliderInactive: RefPalette.neutral30,
    sliderThumb:    RefPalette.red80,

    // Step Indicator
    stepIndicatorActive:   RefPalette.red80,
    stepIndicatorInactive: RefPalette.neutral30,

    // Timer
    timerArcActive:             RefPalette.red80,
    timerArcTrack:              RefPalette.neutral30,
    timerBarBackground:         const Color(0xFF2E271F),
    timerBarColdBrewBackground: const Color(0xFF1A2430),

    // Tea Types (Dark – leicht angepasste Töne)
    teaTypeGreen:   TeaTypeTokens.green.darkened(),
    teaTypeBlack:   TeaTypeTokens.black.darkened(),
    teaTypeOolong:  TeaTypeTokens.oolong.darkened(),
    teaTypeWhite:   TeaTypeTokens.white.darkened(),
    teaTypePuerh:   TeaTypeTokens.puerh.darkened(),
    teaTypeHerbal:  TeaTypeTokens.herbal.darkened(),
    teaTypeFruit:   TeaTypeTokens.fruit.darkened(),
    teaTypeRooibos: TeaTypeTokens.rooibos.darkened(),
    teaTypeYellow: TeaTypeTokens.yellow.darkened(),
  );

  // ThemeData

  static ThemeData get light => _buildTheme(
        colorScheme: _lightColorScheme,
        extension: _lightExtension,
        scaffoldBackground: RefPalette.neutral99,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      );

  static ThemeData get dark => _buildTheme(
        colorScheme: _darkColorScheme,
        extension: _darkExtension,
        scaffoldBackground: RefPalette.darkBackground,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      );

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required SteapLeafThemeExtension extension,
    required Color scaffoldBackground,
    required SystemUiOverlayStyle systemOverlayStyle,
  }) {
    final bool isLight = colorScheme.brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: SteapLeafTextTheme.textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      extensions: [extension],

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: colorScheme.primary,
        titleTextStyle: SteapLeafTextTheme.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        systemOverlayStyle: systemOverlayStyle,
      ),

      // Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        indicatorColor: colorScheme.primaryContainer,
        indicatorShape: const RoundedRectangleBorder(),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.onPrimaryContainer);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return SteapLeafTextTheme.labelMedium.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            );
          }
          return SteapLeafTextTheme.labelMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
        elevation: 2,
      ),

      // Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: SteapLeafTextTheme.labelLarge,
          shape: const RoundedRectangleBorder(),
          minimumSize: const Size(64, 48),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
          textStyle: SteapLeafTextTheme.labelLarge,
          shape: const RoundedRectangleBorder(),
          minimumSize: const Size(64, 48),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
          textStyle: SteapLeafTextTheme.labelLarge,
          shape: const RoundedRectangleBorder(),
          minimumSize: const Size(64, 48),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          textStyle: SteapLeafTextTheme.labelLarge,
          shape: const RoundedRectangleBorder(),
          minimumSize: const Size(64, 48),
        ),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: SteapLeafShapes.radiusNone,
        ),
        elevation: 6,
      ),

      // Cards
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: SteapLeafShapes.radiusNone
        ),
        margin: EdgeInsets.zero,
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: SteapLeafShapes.radiusNone,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: SteapLeafShapes.radiusNone,
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: SteapLeafShapes.radiusNone,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        hintStyle: SteapLeafTextTheme.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelStyle: SteapLeafTextTheme.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: SteapLeafTextTheme.labelMedium.copyWith(
          color: colorScheme.onSurface,
        ),
        shape: const RoundedRectangleBorder(),
        side: BorderSide(color: colorScheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: SteapLeafShapes.radiusNone,
        ),
        showDragHandle: true,
        dragHandleColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: SteapLeafShapes.none,
        titleTextStyle: SteapLeafTextTheme.headlineSmall.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: SteapLeafTextTheme.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: SteapLeafTextTheme.bodyMedium.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        behavior: SnackBarBehavior.floating,
        shape: SteapLeafShapes.none,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Tabs
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: SteapLeafTextTheme.labelLarge.copyWith(
          letterSpacing: 0.15,
        ),
        unselectedLabelStyle: SteapLeafTextTheme.labelMedium,
        dividerColor: colorScheme.outlineVariant,
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: isLight ? RefPalette.neutral80 : RefPalette.neutral30,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      ),

      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.outlineVariant,
        circularTrackColor: colorScheme.outlineVariant,
      ),
    );
  }
}
