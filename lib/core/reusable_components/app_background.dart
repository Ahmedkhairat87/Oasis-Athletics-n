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
  final bool useAppBarBlur;

  const AppBackground({
    super.key,
    required this.child,
    this.useAppBarBlur = false,
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

    // Emoji objects used
    final icons = [
      "⚽", // Football
      "🎾", // Tennis
      "🏊", // Swimming
      "🤸", // Gymnastics
      "✏️", // Pencil
      "🏋️", // Weightlifting
      "👟", // Running shoe
      "📚", // Books
      "🎽", // Sports jersey
    ];

    final rand = Random();

    // 12 floating objects placed around screen
    _objects = List.generate(12, (i) {
      return _FloatingObject(
        emoji: icons[i % icons.length],
        size: rand.nextInt(28) + 36, // 36–64 px
        dx: rand.nextDouble(),
        dy: rand.nextDouble(),
        verticalOffset: rand.nextInt(16) + 8, // 8–24 px float space
        horizontalOffset: rand.nextInt(10) + 4, // slight drift
        rotationAmount: (rand.nextDouble() * 12) - 6, // -6° to +6°
        speed:
            rand.nextDouble() * 0.6 +
            0.4, // 0.4–1.0 (animation speed influence)
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
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color pageBackground = Theme.of(context).scaffoldBackgroundColor;

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
        return Stack(
          children: [
            /// BASE gradient background
            Container(
              decoration: BoxDecoration(
                color: pageBackground,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:
                      isLight
                          ? [
                            gradientStart.withOpacity(0.12),
                            gradientEnd.withOpacity(0.08),
                            pageBackground,
                          ]
                          : [
                            gradientStart.withOpacity(0.85),
                            gradientEnd.withOpacity(0.80),
                            pageBackground,
                          ],
                ),
              ),
            ),

            /// NEW FLOATING EMOJI OBJECTS
            ..._objects.map((obj) {
              final t = _controller.value * obj.speed;

              // Floating up/down motion
              final double dyOffset = sin(t * 2 * pi) * obj.verticalOffset;

              // Horizontal drift
              final double dxOffset = cos(t * 2 * pi) * obj.horizontalOffset;

              // Slow rotation
              final double rotation =
                  (sin(t * 2 * pi) * obj.rotationAmount) * (pi / 180);

              return Positioned(
                top: (obj.dy * MediaQuery.of(context).size.height) + dyOffset,
                left: (obj.dx * MediaQuery.of(context).size.width) + dxOffset,
                child: Transform.rotate(
                  angle: rotation,
                  child: Text(
                    obj.emoji,
                    style: TextStyle(
                      fontSize: obj.size.sp,
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.black.withOpacity(0.22)
                              : Colors.white.withOpacity(0.18),
                    ),
                  ),
                ),
              );
            }),

            /// Optional solid header (for blurred app bars)
            if (widget.useAppBarBlur)
              Container(
                height: kToolbarHeight + 12.h,
                color: headerColor.withOpacity(0.96),
              ),

            /// MAIN CONTENT
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  top: widget.useAppBarBlur ? kToolbarHeight : 0,
                ),
                child: widget.child,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Model for a floating emoji object
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
