import 'package:flutter/material.dart';
import 'colors_Manager.dart';

class AppStyle {
  //==> Light Theme Starts Here <==//
  static ThemeData lightMode = ThemeData(
    fontFamily: 'helvetica',
    cardTheme: const CardThemeData(surfaceTintColor: Colors.transparent),
    dialogTheme: const DialogThemeData(surfaceTintColor: Colors.transparent),
    useMaterial3: true,
    applyElevationOverlayColor: false,
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorsManager.lightBackground,
  );
  //==> Light Theme Ends Here <==//

  //==> Dark Theme Starts Here <==//
  static final ColorScheme _darkScheme = ColorScheme.dark(
    brightness: Brightness.dark,

    primary: ColorsManager.logoGoldLight,
    onPrimary: ColorsManager.darkTextWhite,

    secondary: ColorsManager.logoGoldLight,
    onSecondary: ColorsManager.darkTextWhite,

    background: ColorsManager.darkBackground,
    onBackground: ColorsManager.darkText,

    surface: ColorsManager.darkFields,
    onSurface: ColorsManager.darkText,

    surfaceVariant: ColorsManager.darkSurface2,
    onSurfaceVariant: ColorsManager.darkLabelText,

    outline: ColorsManager.darkBorders,

    error: ColorsManager.logoMaroonAccent,
    onError: ColorsManager.darkTextWhite,
  );

  static ThemeData darkMode = ThemeData(
    fontFamily: 'Roboto',
    useMaterial3: true,
    applyElevationOverlayColor: false,
    brightness: Brightness.dark,
    colorScheme: _darkScheme,

    scaffoldBackgroundColor: ColorsManager.darkBackground,
    dividerColor: ColorsManager.darkBorders,

    appBarTheme: const AppBarTheme(
      backgroundColor: ColorsManager.darkBackground,
      foregroundColor: ColorsManager.darkText,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),

    iconTheme: const IconThemeData(color: ColorsManager.darkLabelText),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: ColorsManager.darkText),
      bodyMedium: TextStyle(color: ColorsManager.darkText),
      bodySmall: TextStyle(color: ColorsManager.darkLabelText),
      titleLarge: TextStyle(color: ColorsManager.darkText),
      titleMedium: TextStyle(color: ColorsManager.darkText),
      titleSmall: TextStyle(color: ColorsManager.darkLabelText),
      labelLarge: TextStyle(color: ColorsManager.darkText),
    ),

    cardTheme: CardThemeData(
      color: ColorsManager.darkFields,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: ColorsManager.darkBorders.withOpacity(0.35), // subtle
          width: 1,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorsManager.darkFields,
      hintStyle: const TextStyle(color: ColorsManager.darkHintText),
      labelStyle: const TextStyle(color: ColorsManager.darkLabelText),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorsManager.darkBorders.withOpacity(0.45),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: ColorsManager.logoGoldLight, width: 1.2),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
//==> Dark Theme Ends Here <==//
}