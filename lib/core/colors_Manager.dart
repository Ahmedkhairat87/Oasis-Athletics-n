// lib/core/reusable_components/colors_Manager.dart
import 'dart:ui';

/// Global color palette for the Oasis Athletics app.
///
/// IMPORTANT:
/// - Variable names are kept for backwards compatibility (logoGold*, etc.).
/// - Colors are now tuned to match the *web dashboard* look:
///   strong blue header, white cards, soft grey-blue background,
///   and green / yellow / red pills.
abstract class ColorsManager {
  // =========================
  // BRAND / PRIMARY BLUES
  // =========================

  /// Main brand blue (used instead of the old "gold").
  /// Close to the website's top bar / header blue.
  static const Color logoGoldMain = Color(0xFF004B9B); // start of gradient

  /// Lighter action/hover blue (buttons, active pills).
  static const Color logoGoldLight = Color(0xFF2F74F3);

  /// Darker navy for side nav background / deep accents.
  static const Color logoGoldDark = Color(0xFF00336E);

  /// Legacy maroon accent now mapped to a clean red used for warnings.
  static const Color logoMaroonAccent = Color(0xFFE53935);

  // Light/dark main background mapping (kept names)
  static const Color lighBlueMainBackColor = logoGoldMain;
  static const Color darkBlueMainBackColor = logoGoldDark;

  /// Main app gradient (matches the requested web gradient).
  static const Color primaryGradientStart = Color(0xFF004B9B); // #004B9B
  static const Color primaryGradientEnd = Color(0xFF004EA3); // #004EA3

  /// Dark equivalents of the gradient.
  static const Color primaryGradientStartDark = Color(0xFF00152F);
  static const Color primaryGradientEndDark = Color(0xFF002A5C);

  // =========================
  // JOYFUL PILL / STATUS COLORS
  // (like the “All Plate / Most / Tasted / None” chips)
  // =========================

  /// Green – success / “All Plate”.
  static const Color accentMint = Color(0xFF34A853);

  /// Yellow / orange – “Most of Plate”.
  static const Color accentSun = Color(0xFFF4B000);

  /// Red – “None / warning”.
  static const Color accentCoral = Color(0xFFE53935);

  /// Light blue pill / info.
  static const Color accentSky = Color(0xFF2F74F3);

  /// Optional purple accent if needed.
  static const Color accentPurple = Color(0xFF9B5DE5);

  // =========================
  // LIGHT THEME
  // =========================

  static const Color lightTextWhite = Color(0xFFFFFFFF);
  static const Color lightTextBlack = Color(0xFF000000);

  /// Page background like the web: very light bluish grey.
  static const Color lightBackground = Color(0xFFF3F5FB);

  /// Main content text (dark, but slightly cool-toned).
  static const Color lightText = Color(0xFF182230);

  static const Color lightHintText = Color(0xFF8A94A6);
  static const Color lightLabelText = Color(0xFF4B5568);

  /// Primary interactive color (buttons, links, active states).
  static const Color lightElements = logoGoldLight;

  /// Card/field background (white cards on bluish background).
  static const Color lightFields = Color(0xFFFFFFFF);

  /// Card/field borders.
  static const Color lightBorders = Color(0xFFE0E4F2);

  // Decorative “bubble” colors (can be used in headers / sections)
  static const Color lightMediumBubble = logoGoldLight; // header blue
  static const Color lightSmallBubble = accentMint; // green
  static const Color lightLargeBubble = accentSun; // yellow/orange;

  /// Very subtle gradient overlay / highlight.
  static const Color lightModeGradient = Color(0xFFE5EEFF);

  // =========================
  // DARK THEME
  // (kept simple but harmonious with the same brand colors)
  // =========================

  static const Color darkTextWhite = Color(0xFF000000);
  static const Color darkTextBlack = Color(0xFFFFFFFF);

  /// Dark background for content.
  static const Color darkBackground = Color(0xFF020617);

  /// Main text on dark.
  static const Color darkText = Color(0xFFE5ECFF);

  static const Color darkHintText = Color(0xFF9AA4BF);
  static const Color darkLabelText = Color(0xFFCAD3EB);

  /// Primary elements in dark mode.
  static const Color darkElements = logoGoldLight;

  /// Cards/fields in dark.
  static const Color darkFields = Color(0xFF0B1120);

  /// Borders in dark.
  static const Color darkBorders = Color(0xFF1E293B);

  // Decorative bubbles for dark mode.
  static const Color darkMediumBubble = Color(0xFF1D4ED8); // blue
  static const Color darkSmallBubble = accentMint; // green
  static const Color darkLargeBubble = accentCoral; // red/orange

  static const Color darkModeGradient = Color(0xFF020617);
}
