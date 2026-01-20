// lib/core/reusable_components/app_colors_extension.dart
import 'package:flutter/material.dart';
import '../colors_Manager.dart';

extension AppColors on ColorScheme {
  // == Light/Dark shared logic == //
  bool get isLight => brightness == Brightness.light;

  /// Main button background / key action color.
  Color get btnBackMainColor =>
      isLight ? ColorsManager.logoGoldLight : ColorsManager.logoGoldLight;

  /// Scaffold / main page background behind cards.
  Color get backgroundMain =>
      isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground;

  /// Text on top of strong backgrounds (buttons, pills).
  Color get textMainWhite =>
      isLight ? ColorsManager.lightTextWhite : ColorsManager.darkTextBlack;

  /// Primary readable text for content.
  Color get textMainBlack =>
      isLight ? ColorsManager.lightText : ColorsManager.darkText;

  /// Hint / placeholder text.
  Color get hintText =>
      isLight ? ColorsManager.lightHintText : ColorsManager.darkHintText;

  /// Secondary labels (field labels, small captions).
  Color get labelText =>
      isLight ? ColorsManager.lightLabelText : ColorsManager.darkLabelText;

  /// Primary interactive elements: buttons, active icons.
  Color get elements =>
      isLight ? ColorsManager.lightElements : ColorsManager.darkElements;

  /// Input fields / cards background.
  Color get fields =>
      isLight ? ColorsManager.lightFields : ColorsManager.darkFields;

  /// Borders for the fields / cards.
  Color get borders =>
      isLight ? ColorsManager.lightBorders : ColorsManager.darkBorders;

  /// Decorative medium bubble (section headers, ribbons).
  Color get bubbleMedium =>
      isLight
          ? ColorsManager.lightMediumBubble
          : ColorsManager.darkMediumBubble;

  /// Decorative small bubble.
  Color get bubbleSmall =>
      isLight ? ColorsManager.lightSmallBubble : ColorsManager.darkSmallBubble;

  /// Decorative large bubble.
  Color get bubbleLarge =>
      isLight ? ColorsManager.lightLargeBubble : ColorsManager.darkLargeBubble;

  /// Background overlay gradient (if needed).
  Color get modeGradient =>
      isLight
          ? ColorsManager.lightModeGradient
          : ColorsManager.darkModeGradient;

  // Helpers for the main app gradient (web header feel).
  Color get brandGradientStart =>
      isLight
          ? ColorsManager.primaryGradientStart
          : ColorsManager.primaryGradientStartDark;

  Color get brandGradientEnd =>
      isLight
          ? ColorsManager.primaryGradientEnd
          : ColorsManager.primaryGradientEndDark;

  // Expose pill/status colors for convenience.
  Color get statusGreen => ColorsManager.accentMint;
  Color get statusYellow => ColorsManager.accentSun;
  Color get statusRed => ColorsManager.accentCoral;
  Color get statusBlue => ColorsManager.accentSky;
  Color get statusPurple => ColorsManager.accentPurple;
}
