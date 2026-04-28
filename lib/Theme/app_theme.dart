import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens/shapes.dart';
import 'tokens/spacing.dart';
import 'tokens/tea_type_tokens.dart';
import 'extensions/steapleaf_theme_extension.dart';
import 'tokens/text_theme.dart';

abstract final class SteapLeafTheme {
  SteapLeafTheme._();

  // Color Schemes

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary · Warm Red (Camellia)
    primary:           Color(0xFF9C2C2C),
    onPrimary:        Color(0xFFFEFCF8),
    primaryContainer: Color(0xFFF2D5D0),
    onPrimaryContainer: Color(0xFF3D0F0F),

    // Secondary · Warm Neutral
    secondary:            Color(0xFF6E5D52),
    onSecondary:         Color(0xFFFEFCF8),
    secondaryContainer:   Color(0xFFE8DCCB),
    onSecondaryContainer: Color(0xFF2A1E15),

    // Error
    error:            Color(0xFFB3261E),
    onError:          Color(0xFFFEFCF8),
    errorContainer:   Color(0xFFF9DEDA),
    onErrorContainer: Color(0xFF410E0B),

    // Surface & Background
    surface:               Color(0xFFF4EFE6),
    onSurface:             Color(0xFF2A2826),
    onSurfaceVariant:      Color(0xFF5C544B),
    surfaceContainerLowest:  Color(0xFFFEFCF8),
    surfaceContainerLow:    Color(0xFFFAF5EC),
    surfaceContainer:       Color(0xFFF4EFE6),
    surfaceContainerHigh:    Color(0xFFEDE7DC),
    surfaceContainerHighest: Color(0xFFE6DFD2),

    // Outline
    outline:       Color(0xFF847B73),
    outlineVariant: Color(0xFFD4CCBF),

    // Inverse (für Snackbars)
    inverseSurface:   Color(0xFF2A2826),
    onInverseSurface: Color(0xFFF4EFE6),
    inversePrimary:   Color(0xFFFFB4AB),

    // Scaffold Background = das warme Papier
    shadow:          Color(0xFF000000),
    scrim:           Color(0xFF000000),
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Primary
    primary:           Color(0xFFFFB4AB),
    onPrimary:          Color(0xFF5C1010),
    primaryContainer:   Color(0xFF7A2020),
    onPrimaryContainer: Color(0xFFFFDAD5),

    // Secondary
    secondary:            Color(0xFFD4C3B5),
    onSecondary:          Color(0xFF3D2F26),
    secondaryContainer:   Color(0xFF564539),
    onSecondaryContainer: Color(0xFFF0E2D2),

    // Error
    error:           Color(0xFFFFB4AB),
    onError:         Color(0xFF690005),
    errorContainer:   Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),

    // Surface & Background
    surface:              Color(0xFF1F1D1B),
    onSurface:            Color(0xFFF4EFE6),
    onSurfaceVariant:      Color(0xFFC9C0B5),
    surfaceContainerLowest:  Color(0xFF161513),
    surfaceContainerLow:    Color(0xFF25221F),
    surfaceContainer:        Color(0xFF2A2826),
    surfaceContainerHigh:    Color(0xFF35322F),
    surfaceContainerHighest: Color(0xFF403C38),

    // Outline
    outline:        Color(0xFF948A7F),
    outlineVariant: Color(0xFF4A4540),

    // Inverse
    inverseSurface:   Color(0xFFF4EFE6),
    onInverseSurface: Color(0xFF2A2826),
    inversePrimary:   Color(0xFF9C2C2C),

    shadow:  Color(0xFF000000),
    scrim:   Color(0xFF000000),
  );

  // Theme Extension: Light

  static final SteapLeafThemeExtension _lightExtension = SteapLeafThemeExtension(
    teaTypeGreen:   TeaTypeTokens.green,
    teaTypeBlack:   TeaTypeTokens.black,
    teaTypeOolong:  TeaTypeTokens.oolong,
    teaTypeWhite:   TeaTypeTokens.white,
    teaTypePuerh:   TeaTypeTokens.puerh,
    teaTypeHerbal:  TeaTypeTokens.herbal,
    teaTypeFruit:   TeaTypeTokens.fruit,
    teaTypeRooibos: TeaTypeTokens.rooibos,
    teaTypeYellow:  TeaTypeTokens.yellow,
    teaTypeOther:   TeaTypeTokens.other,
  );

  static final SteapLeafThemeExtension _darkExtension = SteapLeafThemeExtension(
    teaTypeGreen:   TeaTypeTokens.green.darkened(),
    teaTypeBlack:   TeaTypeTokens.black.darkened(),
    teaTypeOolong:  TeaTypeTokens.oolong.darkened(),
    teaTypeWhite:   TeaTypeTokens.white.darkened(),
    teaTypePuerh:   TeaTypeTokens.puerh.darkened(),
    teaTypeHerbal:  TeaTypeTokens.herbal.darkened(),
    teaTypeFruit:   TeaTypeTokens.fruit.darkened(),
    teaTypeRooibos: TeaTypeTokens.rooibos.darkened(),
    teaTypeYellow: TeaTypeTokens.yellow.darkened(),
    teaTypeOther:   TeaTypeTokens.other.darkened(),
  );

  // ThemeData

  static ThemeData get light => _buildTheme(
        colorScheme: _lightColorScheme,
        extension: _lightExtension,
        scaffoldBackground: Color(0xFFF4EFE6),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      );

  static ThemeData get dark => _buildTheme(
        colorScheme: _darkColorScheme,
        extension: _darkExtension,
        scaffoldBackground:  Color(0xFF1F1D1B),
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
        toolbarHeight: SteapLeafSizes.barHeight,
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
        indicatorShape: SteapLeafShapes.none,
        height: SteapLeafSizes.bottomBarHeight,
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
          shape: SteapLeafShapes.none,
          minimumSize: const Size(64, 48),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
          textStyle: SteapLeafTextTheme.labelLarge,
          shape: SteapLeafShapes.none,
          minimumSize: const Size(64, 48),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
          textStyle: SteapLeafTextTheme.labelLarge,
          shape: SteapLeafShapes.none,
          minimumSize: const Size(64, 48),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          textStyle: SteapLeafTextTheme.labelLarge,
          shape: SteapLeafShapes.none,
          minimumSize: const Size(64, 48),
        ),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: SteapLeafShapes.none,
        elevation: 6,
      ),

      // Cards
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: SteapLeafShapes.none,
        margin: SteapLeafSpacing.card,
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
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
        contentPadding: SteapLeafSpacing.listItem,
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: SteapLeafTextTheme.labelMedium.copyWith(
          color: colorScheme.onSurface,
        ),
        shape: SteapLeafShapes.none,
        side: BorderSide(color: colorScheme.outlineVariant),
        padding: SteapLeafSpacing.listItem,
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: SteapLeafShapes.none,
        showDragHandle: true,
        dragHandleColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: SteapLeafShapes.none,
        titleTextStyle: SteapLeafTextTheme.headlineMedium.copyWith(
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
    );
  }
}
