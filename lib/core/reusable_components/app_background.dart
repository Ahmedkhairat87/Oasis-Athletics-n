// lib/core/reusable_components/app_background.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors_Manager.dart';

/// NEW Animated Athletic/Education Background
/// Emojis: ⚽ 🎾 🏊 🤸 ✏️ 🏋️ 👟 📚 🎽
/// Animations: floating, drifting, slow rotation
class AppBackground extends StatefulWidget {
  final Widget child;

  /// If true, we draw a solid/blur header strip behind AppBar area
  /// and push the content down by toolbar height (your original behavior).
  final bool useAppBarBlur;
  final bool useSafeArea;
  final bool safeAreaTop;
  final bool safeAreaBottom;

  const AppBackground({
    super.key,
    required this.child,
    this.useAppBarBlur = false,
    this.useSafeArea = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
  });

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_FloatingObject> _objects;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);

    final icons = [
      "⚽",
      "🎾",
      "🏊",
      "🤸",
      "✏️",
      "🏋️",
      "👟",
      "📚",
      "🎽",
    ];

    final rand = Random();

    // 12 floating objects placed around screen
    _objects = List.generate(12, (i) {
      return _FloatingObject(
        emoji: icons[i % icons.length],
        size: rand.nextInt(28) + 36, // 36–64 px
        dx: rand.nextDouble(),
        dy: rand.nextDouble(),
        verticalOffset: rand.nextInt(16) + 8, // 8–24 px
        horizontalOffset: rand.nextInt(10) + 4, // drift
        rotationAmount: (rand.nextDouble() * 12) - 6, // -6° to +6°
        speed: rand.nextDouble() * 0.6 + 0.4, // 0.4–1.0
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    // IMPORTANT:
    // Use MediaQuery.sizeOf(context) for exact full-screen painting
    // even when body extends behind system bars.
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);

    final Color pageBackground = theme.scaffoldBackgroundColor;

    final Color gradientStart =
    isLight
        ? ColorsManager.primaryGradientStart
        : ColorsManager.primaryGradientStartDark;

    final Color gradientEnd =
    isLight
        ? ColorsManager.primaryGradientEnd
        : ColorsManager.primaryGradientEndDark;

    final Color headerColor = gradientStart;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return SizedBox.expand(
          child: Stack(
            fit: StackFit.expand, // ✅ ensure stack expands full available space
            children: [
              /// ✅ Solid base (prevents transparent gradients blending to black)
              Positioned.fill(
                child: ColoredBox(color: pageBackground),
              ),

              /// ✅ Gradient wash (FULL SCREEN)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors:
                          isLight
                              ? [
                                gradientStart.withOpacity(0.10),
                                gradientEnd.withOpacity(0.06),
                                pageBackground,
                              ]
                              : [
                                gradientStart.withOpacity(0.14),
                                gradientEnd.withOpacity(0.08),
                                pageBackground,
                              ],
                    ),
                  ),
                ),
              ),

              /// ✅ FLOATING EMOJI OBJECTS (FULL SCREEN)
              ..._objects.map((obj) {
                final t = _controller.value * obj.speed;

                final double dyOffset = sin(t * 2 * pi) * obj.verticalOffset;
                final double dxOffset = cos(t * 2 * pi) * obj.horizontalOffset;
                final double rotation =
                    (sin(t * 2 * pi) * obj.rotationAmount) * (pi / 180);

                // Keep emojis inside screen bounds (avoid clipping on edges)
                final left = (obj.dx * size.width) + dxOffset;
                final top = (obj.dy * size.height) + dyOffset;

                // Small clamp to keep within safe-ish bounds
                final clampedLeft = left.clamp(8.0, size.width - 80.0);
                final clampedTop = top.clamp(8.0, size.height - 80.0);

                return Positioned(
                  top: clampedTop.toDouble(),
                  left: clampedLeft.toDouble(),
                  child: Transform.rotate(
                    angle: rotation,
                    child: IgnorePointer(
                      child: Text(
                        obj.emoji,
                        style: TextStyle(
                          fontSize: obj.size.sp,
                          // Softer + more "watermark" like your attached
                          color:
                              isLight
                                  ? Colors.black.withOpacity(0.10)
                                  : Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                  ),
                );
              }),

              /// ✅ Optional solid header strip behind appbar area
              /// We include status bar padding so it fills behind the notch too.
              if (widget.useAppBarBlur)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: padding.top + kToolbarHeight + 12.h,
                  child: Container(
                    color:
                        isLight
                            ? headerColor.withOpacity(0.10)
                            : headerColor.withOpacity(0.06),
                  ),
                ),

              /// ✅ MAIN CONTENT (optional safe area; background always full-screen)
              Builder(
                builder: (context) {
                  Widget content = widget.child;

                  if (widget.useAppBarBlur) {
                    content = Padding(
                      padding: const EdgeInsets.only(top: kToolbarHeight),
                      child: content,
                    );
                  }

                if (widget.useSafeArea) {
                  content = SafeArea(
                    top: widget.safeAreaTop,
                    bottom: widget.safeAreaBottom,
                    maintainBottomViewPadding: true,
                    child: content,
                  );
                }

                  return content;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FloatingObject {
  final String emoji;
  final double size;
  final double dx;
  final double dy;
  final double verticalOffset;
  final double horizontalOffset;
  final double rotationAmount;
  final double speed;

  _FloatingObject({
    required this.emoji,
    required this.size,
    required this.dx,
    required this.dy,
    required this.verticalOffset,
    required this.horizontalOffset,
    required this.rotationAmount,
    required this.speed,
  });
}

// // lib/core/reusable_components/app_background.dart
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../colors_Manager.dart';
//
// /// NEW Animated Athletic/Education Background
// /// Emojis: ⚽ 🎾 🏊 🤸 ✏️ 🏋️ 👟 📚 🎽
// /// Animations: floating, drifting, slow rotation
// class AppBackground extends StatefulWidget {
//   final Widget child;
//   final bool useAppBarBlur;
//
//   const AppBackground({
//     super.key,
//     required this.child,
//     this.useAppBarBlur = false,
//   });
//
//   @override
//   State<AppBackground> createState() => _AppBackgroundState();
// }
//
// class _AppBackgroundState extends State<AppBackground>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   late List<_FloatingObject> _objects;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 14),
//     )..repeat(reverse: true);
//
//     // Emoji objects used
//     final icons = [
//       "⚽", // Football
//       "🎾", // Tennis
//       "🏊", // Swimming
//       "🤸", // Gymnastics
//       "✏️", // Pencil
//       "🏋️", // Weightlifting
//       "👟", // Running shoe
//       "📚", // Books
//       "🎽", // Sports jersey
//     ];
//
//     final rand = Random();
//
//     // 12 floating objects placed around screen
//     _objects = List.generate(12, (i) {
//       return _FloatingObject(
//         emoji: icons[i % icons.length],
//         size: rand.nextInt(28) + 36, // 36–64 px
//         dx: rand.nextDouble(),
//         dy: rand.nextDouble(),
//         verticalOffset: rand.nextInt(16) + 8, // 8–24 px float space
//         horizontalOffset: rand.nextInt(10) + 4, // slight drift
//         rotationAmount: (rand.nextDouble() * 12) - 6, // -6° to +6°
//         speed:
//             rand.nextDouble() * 0.6 +
//             0.4, // 0.4–1.0 (animation speed influence)
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isLight = Theme.of(context).brightness == Brightness.light;
//
//     final Color pageBackground = Theme.of(context).scaffoldBackgroundColor;
//
//     final Color gradientStart =
//         isLight
//             ? ColorsManager.primaryGradientStart
//             : ColorsManager.primaryGradientStartDark;
//
//     final Color gradientEnd =
//         isLight
//             ? ColorsManager.primaryGradientEnd
//             : ColorsManager.primaryGradientEndDark;
//
//     final Color headerColor = gradientStart;
//
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (_, __) {
//         return Stack(
//           children: [
//             /// BASE gradient background
//             Container(
//               decoration: BoxDecoration(
//                 color: pageBackground,
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors:
//                       isLight
//                           ? [
//                             gradientStart.withOpacity(0.12),
//                             gradientEnd.withOpacity(0.08),
//                             pageBackground,
//                           ]
//                           : [
//                             gradientStart.withOpacity(0.18),
//                             gradientEnd.withOpacity(0.12),
//                             pageBackground,
//                           ],
//                 ),
//               ),
//             ),
//
//             /// NEW FLOATING EMOJI OBJECTS
//             ..._objects.map((obj) {
//               final t = _controller.value * obj.speed;
//
//               // Floating up/down motion
//               final double dyOffset = sin(t * 2 * pi) * obj.verticalOffset;
//
//               // Horizontal drift
//               final double dxOffset = cos(t * 2 * pi) * obj.horizontalOffset;
//
//               // Slow rotation
//               final double rotation =
//                   (sin(t * 2 * pi) * obj.rotationAmount) * (pi / 180);
//
//               return Positioned(
//                 top: (obj.dy * MediaQuery.of(context).size.height) + dyOffset,
//                 left: (obj.dx * MediaQuery.of(context).size.width) + dxOffset,
//                 child: Transform.rotate(
//                   angle: rotation,
//                   child: Text(
//                     obj.emoji,
//                     style: TextStyle(
//                       fontSize: obj.size.sp,
//                       color:
//                           Theme.of(context).brightness == Brightness.light
//                               ? Colors.black.withOpacity(0.22)
//                               : Colors.white.withOpacity(0.18),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//
//             /// Optional solid header (for blurred app bars)
//             if (widget.useAppBarBlur)
//               Container(
//                 height: kToolbarHeight + 12.h,
//                 color: headerColor.withOpacity(0.96),
//               ),
//
//             /// MAIN CONTENT
//             SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   top: widget.useAppBarBlur ? kToolbarHeight : 0,
//                 ),
//                 child: widget.child,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// /// Model for a floating emoji object
// class _FloatingObject {
//   final String emoji;
//   final double size;
//   final double dx;
//   final double dy;
//   final double verticalOffset;
//   final double horizontalOffset;
//   final double rotationAmount;
//   final double speed;
//
//   _FloatingObject({
//     required this.emoji,
//     required this.size,
//     required this.dx,
//     required this.dy,
//     required this.verticalOffset,
//     required this.horizontalOffset,
//     required this.rotationAmount,
//     required this.speed,
//   });
// }
