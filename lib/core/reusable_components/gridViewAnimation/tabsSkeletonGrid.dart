import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabsSkeletonGrid extends StatefulWidget {
  final int itemCount;
  const TabsSkeletonGrid({super.key, this.itemCount = 6});

  @override
  State<TabsSkeletonGrid> createState() => _TabsSkeletonGridState();
}

class _TabsSkeletonGridState extends State<TabsSkeletonGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final base =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06);
    final highlight =
        isDark
            ? Colors.white.withOpacity(0.16)
            : Colors.black.withOpacity(0.10);

    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = _c.value;

        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          physics: const BouncingScrollPhysics(),
          itemCount: widget.itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (_, i) {
            // subtle moving gradient
            final begin = Alignment(-1.0 + (2 * t), -1);
            final end = Alignment(1.0 + (2 * t), 1);

            return ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: begin,
                    end: end,
                    colors: [base, highlight, base],
                    stops: const [0.1, 0.5, 0.9],
                  ),
                  border: Border.all(
                    color: (isDark ? Colors.white : Colors.black).withOpacity(
                      0.06,
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // icon placeholder
                      Container(
                        width: 40.r,
                        height: 40.r,
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.white : Colors.black)
                              .withOpacity(0.10),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 10.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.white : Colors.black)
                              .withOpacity(0.10),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 10.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.white : Colors.black)
                              .withOpacity(0.08),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
