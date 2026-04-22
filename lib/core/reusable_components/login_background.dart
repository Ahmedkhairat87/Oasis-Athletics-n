import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors_Manager.dart';

/// PREMIUM LOGIN BACKGROUND (Educational + Sportive Theme)
/// Floating emojis + drifting + rotation + glow.
class LoginBackground extends StatefulWidget {
  final bool showTopBlueBar;

  const LoginBackground({super.key, this.showTopBlueBar = false});

  @override
  State<LoginBackground> createState() => _LoginBackgroundState();
}

class _LoginBackgroundState extends State<LoginBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final List<_FloatingObject> _objects;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat(reverse: true);

    // Educational + Sportive emoji set
    const icons = [
      "⚽", // Football
      "🎾", // Tennis
      "🏀", // Basketball
      "🤸", // Gymnastics
      "🏊", // Swimming
      "✏️", // Pencil
      "📚", // Books
      "👟", // Running shoe
      "🏋️", // Weightlifting
      "🎽", // Sports jersey
    ];

    final rand = Random();

    _objects = List.generate(22, (i) {
      return _FloatingObject(
        emoji: icons[i % icons.length],
        baseSize: rand.nextInt(32) + 46, // 46–78
        dx: rand.nextDouble(), // 0.0–1.0
        dy: rand.nextDouble(), // 0.0–1.0
        verticalMotion: rand.nextInt(14) + 8,
        horizontalMotion: rand.nextInt(10) + 4,
        rotationAmount: (rand.nextDouble() * 16) - 8, // -8° → +8°
        speed: rand.nextDouble() * 0.6 + 0.4,
        opacity: rand.nextDouble() * 0.16 + 0.10,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Prevent objects from drifting into the login form center area.
  bool _isInLoginArea(double dy) {
    return dy > 0.28 && dy < 0.72;
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color bg =
        isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground;

    final gradStart =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final gradEnd =
        isLight
            ? ColorsManager.primaryGradientEnd
            : ColorsManager.primaryGradientEndDark;

    final screen = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:
                      isLight
                          ? [
                            gradStart.withOpacity(0.20),
                            gradEnd.withOpacity(0.12),
                            bg,
                          ]
                          : [
                            gradStart.withOpacity(0.10),
                            gradEnd.withOpacity(0.06),
                            bg,
                          ],
                ),
              ),
            ),

            // Floating & animated emoji objects
            ..._objects.map((obj) {
              final t = _controller.value * obj.speed;

              final offsetX = cos(t * 2 * pi) * obj.horizontalMotion;
              final offsetY = sin(t * 2 * pi) * obj.verticalMotion;

              final rotation =
                  sin(t * 2 * pi) * obj.rotationAmount * (pi / 180);

              // Adjusted positions to avoid login form collision
              double adjustedDx = obj.dx;
              double adjustedDy = obj.dy;

              if (_isInLoginArea(adjustedDy)) {
                adjustedDx += adjustedDx > 0.5 ? 0.28 : -0.28;
              }

              return Positioned(
                top: adjustedDy * screen.height + offsetY,
                left: adjustedDx * screen.width + offsetX,
                child: Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.identity()
                        ..rotateZ(rotation)
                        ..scale(1 + sin(t * 2 * pi) * 0.06),
                  child: Opacity(
                    opacity: obj.opacity,
                    child: Text(
                      obj.emoji,
                      style: TextStyle(
                        fontSize: obj.baseSize.sp,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.20),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),

            if (widget.showTopBlueBar)
              Container(
                height: kToolbarHeight + 20,
                color: gradStart.withOpacity(0.90),
              ),
          ],
        );
      },
    );
  }
}

/// Model: Floating animated emoji object
class _FloatingObject {
  final String emoji;
  final double baseSize;
  final double dx;
  final double dy;
  final double verticalMotion;
  final double horizontalMotion;
  final double rotationAmount;
  final double speed;
  final double opacity;

  const _FloatingObject({
    required this.emoji,
    required this.baseSize,
    required this.dx,
    required this.dy,
    required this.verticalMotion,
    required this.horizontalMotion,
    required this.rotationAmount,
    required this.speed,
    required this.opacity,
  });
}
