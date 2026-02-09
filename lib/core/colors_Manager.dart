import 'dart:ui';

abstract class ColorsManager {
  // =========================
  // BRAND / PRIMARY
  // =========================
  static const Color logoGoldMain = Color(0xFF004B9B);
  static const Color logoGoldLight = Color(0xFF2F74F3);
  static const Color logoGoldDark = Color(0xFF00336E);
  static const Color logoMaroonAccent = Color(0xFFE53935);

  static const Color lighBlueMainBackColor = logoGoldMain;
  static const Color darkBlueMainBackColor = logoGoldDark;

  static const Color primaryGradientStart = Color(0xFF004B9B);
  static const Color primaryGradientEnd = Color(0xFF004EA3);

  static const Color primaryGradientStartDark = Color(0xFF00152F);
  static const Color primaryGradientEndDark = Color(0xFF002A5C);

  // =========================
  // STATUS COLORS (ok to keep)
  // =========================
  static const Color accentMint = Color(0xFF34A853);
  static const Color accentSun = Color(0xFFF4B000);
  static const Color accentCoral = Color(0xFFE53935);
  static const Color accentSky = Color(0xFF2F74F3);
  static const Color accentPurple = Color(0xFF9B5DE5);

  // =========================
  // LIGHT THEME (unchanged)
  // =========================
  static const Color lightTextWhite = Color(0xFFFFFFFF);
  static const Color lightTextBlack = Color(0xFF000000);

  static const Color lightBackground = Color(0xFFF3F5FB);
  static const Color lightText = Color(0xFF182230);

  static const Color lightHintText = Color(0xFF8A94A6);
  static const Color lightLabelText = Color(0xFF4B5568);

  static const Color lightElements = logoGoldLight;
  static const Color lightFields = Color(0xFFFFFFFF);
  static const Color lightBorders = Color(0xFFE0E4F2);

  static const Color lightMediumBubble = logoGoldLight;
  static const Color lightSmallBubble = accentMint;
  static const Color lightLargeBubble = accentSun;

  static const Color lightModeGradient = Color(0xFFE5EEFF);

  // =========================
  // DARK THEME (UPDATED to be familiar)
  // Neutral background, subtle surfaces, minimal outlines, blue only for action
  // =========================

  // Text
  static const Color darkTextWhite = Color(0xFFFFFFFF);
  static const Color darkTextBlack = Color(0xFF000000);

  /// Near-black background (neutral, not blue)
  static const Color darkBackground = Color(0xFF0B0D10);

  /// Lifted surfaces (cards/fields)
  static const Color darkFields = Color(0xFF141922);

  /// Optional higher surface (dialogs/menus/pressed cards)
  static const Color darkSurface2 = Color(0xFF1A2030);

  /// Primary text / secondary / hint
  static const Color darkText = Color(0xFFEDEFF2);
  static const Color darkLabelText = Color(0xFFB8C0CC);
  static const Color darkHintText = Color(0xFF7F8896);

  /// Subtle outline (NOT neon)
  static const Color darkBorders = Color(0xFF232A36);

  /// Brand accent for actions/focus only
  static const Color darkElements = logoGoldLight;

  // Decorative bubbles (make them neutral — stop RGB look)
  static const Color darkMediumBubble = darkFields;
  static const Color darkSmallBubble = darkFields;
  static const Color darkLargeBubble = darkSurface2;

  /// Keep overlay subtle & neutral
  static const Color darkModeGradient = Color(0xFF0B0D10);
}