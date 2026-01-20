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
  static ThemeData darkMode = ThemeData(
    fontFamily: 'Roboto',
    cardTheme: const CardThemeData(surfaceTintColor: Colors.transparent),
    dialogTheme: const DialogThemeData(surfaceTintColor: Colors.transparent),
    useMaterial3: true,
    applyElevationOverlayColor: false,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorsManager.darkBackground,
  );
  //==> Dark Theme Ends Here <==//
}
