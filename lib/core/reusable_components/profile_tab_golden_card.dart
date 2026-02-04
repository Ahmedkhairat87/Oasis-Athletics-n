// lib/core/reusable_components/gold_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors_Manager.dart';

/// A joyful, multicolor "gold" card wrapper.
/// - Soft multicolor gradient border (brand blue + accents)
/// - Light shadow
/// - Gentle pop-in animation on build
class GoldCard extends StatelessWidget {
  const GoldCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color primaryBlue = ColorsManager.primaryGradientStart;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;

    final Color innerBackground =
        isLight ? Colors.white : ColorsManager.darkFields;

    final List<Color> borderGradient =
        isLight
            ? [
              primaryBlue.withOpacity(0.95),
              accentSky.withOpacity(0.85),
              accentMint.withOpacity(0.85),
              accentSun.withOpacity(0.9),
            ]
            : [
              ColorsManager.darkBorders,
              ColorsManager.darkFields,
              ColorsManager.darkBorders,
            ];

    final List<BoxShadow> cardShadow =
        isLight
            ? [
              BoxShadow(
                color: primaryBlue.withOpacity(0.22),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ]
            : [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1.0),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutBack,
      builder: (context, value, childWidget) {
        return Transform.scale(scale: value, child: childWidget);
      },
      child: Container(
        //width: double.infinity,
        // Outer gradient border
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: borderGradient,
          ),
          boxShadow: cardShadow,
        ),
        child: Container(
          // Inner card surface
          margin: EdgeInsets.all(1.2.w),
          decoration: BoxDecoration(
            color: innerBackground.withOpacity(0.97),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Padding(padding: EdgeInsets.all(12.w), child: child),
        ),
      ),
    );
  }
}
