// lib/core/reusable_components/studentInside_tabbar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors_Manager.dart';

/// Lightweight Tab item model used by StudentInside screen tabbar.
class TabItem {
  final String title;
  final Widget icon;
  final ImageProvider? image;
  const TabItem({required this.title, required this.icon, this.image});
}

/// A horizontally-scrollable, animated tab bar tuned for small screens.
/// This implementation uses a fixed outer height to avoid RenderFlex overflow.
class GoldenTabBar extends StatefulWidget {
  const GoldenTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
    this.controller,
    this.tabWidth = 96,
    this.iconSize = 26,
    this.height = 96,
  });

  final List<TabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final ScrollController? controller;
  final double tabWidth;
  final double iconSize;
  final double height;

  @override
  State<GoldenTabBar> createState() => _GoldenTabBarState();
}

class _GoldenTabBarState extends State<GoldenTabBar> {
  late final ScrollController _internalController;

  ScrollController get _controller => widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = ScrollController();
  }

  @override
  void dispose() {
    _internalController.dispose();
    super.dispose();
  }

  void _centerTab(int index) {
    final double tabWidth = widget.tabWidth.w;
    final double spacing = 12.w;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double target =
        (index * (tabWidth + spacing)) - (screenWidth / 2) + (tabWidth / 2);
    final double max =
        _controller.hasClients ? _controller.position.maxScrollExtent : 0.0;
    final double offset = target.clamp(0.0, max);
    if (_controller.hasClients) {
      _controller.animateTo(
        offset,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void didUpdateWidget(covariant GoldenTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _centerTab(widget.selectedIndex),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final Color primaryBlueEnd =
        isLight
            ? ColorsManager.primaryGradientEnd
            : ColorsManager.primaryGradientEndDark;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentPurple = ColorsManager.accentPurple;

    // Outer fixed-size box avoids parent measuring an unbounded height.
    final outerHeight =
        widget.height.h + 20.h; // extra space for indicator + breathing

    return SizedBox(
      height: outerHeight,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          final double t = value.clamp(0.0, 1.0);
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, (1 - t) * 8),
              child: child,
            ),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Scrollable row positioned at top portion
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: widget.height.h,
                child: ListView.separated(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  itemCount: widget.tabs.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  itemBuilder: (context, index) {
                    final item = widget.tabs[index];
                    final bool selected = index == widget.selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        widget.onTap(index);
                        _centerTab(index);
                      },
                      child: _buildTabItem(
                        item: item,
                        selected: selected,
                        primaryBlue: primaryBlue,
                        primaryBlueEnd: primaryBlueEnd,
                        accentMint: accentMint,
                        accentSun: accentSun,
                        accentSky: accentSky,
                        accentPurple: accentPurple,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Small sliding indicator placed near the bottom of the SizedBox
            /*Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: _buildIndicator(
                  primaryBlue: primaryBlue,
                  primaryBlueEnd: primaryBlueEnd,
                  accentMint: accentMint,
                  accentSun: accentSun,
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required TabItem item,
    required bool selected,
    required Color primaryBlue,
    required Color primaryBlueEnd,
    required Color accentMint,
    required Color accentSun,
    required Color accentSky,
    required Color accentPurple,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Each tab is a fixed-width card with constrained label height (prevents overflow).
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      width: widget.tabWidth.w,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration:
          isDark
              ? BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withOpacity(selected ? 0.5 : 0.35),
                ),
              )
              : BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                gradient:
                    selected
                        ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryBlue.withOpacity(0.16),
                            accentSky.withOpacity(0.14),
                            accentMint.withOpacity(0.10),
                          ],
                        )
                        : LinearGradient(
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.04),
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.02),
                          ],
                        ),
                border: Border.all(
                  color: selected ? primaryBlue : Colors.transparent,
                  width: selected ? 1.2 : 0,
                ),
                boxShadow: [
                  if (selected)
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.14),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  else
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular icon or image
            TweenAnimationBuilder<double>(
              tween: Tween(begin: selected ? 0.95 : 1.0, end: 1.0),
              duration: const Duration(milliseconds: 220),
              builder:
                  (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
              child: Container(
                padding: EdgeInsets.all(selected ? 6.r : 4.r),
                decoration:
                    isDark
                        ? BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.35),
                        )
                        : BoxDecoration(
                          shape: BoxShape.circle,
                          gradient:
                              selected
                                  ? SweepGradient(
                                    colors: [
                                      primaryBlue,
                                      accentSky,
                                      accentMint,
                                      accentSun,
                                      primaryBlue,
                                    ],
                                  )
                                  : null,
                          color:
                              selected
                                  ? null
                                  : Theme.of(context).colorScheme.surface,
                        ),
                child: Container(
                  padding: EdgeInsets.all(selected ? 3.r : 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? Colors.white : Colors.transparent,
                  ),
                  child: _buildIconOrImage(
                    item: item,
                    selected: selected,
                    selectedColor: primaryBlueEnd,
                    unselectedColor: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.85),
                  ),
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // Label with max height — prevents text from pushing contents vertically.
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: (widget.tabWidth - 10).w,
                maxHeight: 30.h,
              ),
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: selected ? 13.sp : 12.sp,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color:
                      isDark
                          ? Theme.of(context).colorScheme.onSurface
                          : (selected
                              ? accentPurple
                              : Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.85)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator({
    required Color primaryBlue,
    required Color primaryBlueEnd,
    required Color accentMint,
    required Color accentSun,
  }) {
    final int tabCount = widget.tabs.length;
    double xAlign = 0;
    if (tabCount > 1) {
      xAlign = (widget.selectedIndex / (tabCount - 1)) * 2 - 1;
    }

    return AnimatedAlign(
      alignment: Alignment(xAlign, 0),
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutQuad,
      child: Container(
        width: 26.w,
        height: 4.h,
        decoration:
            Theme.of(context).brightness == Brightness.dark
                ? BoxDecoration(
                  borderRadius: BorderRadius.circular(999.r),
                  color: Theme.of(context).colorScheme.onSurface,
                )
                : BoxDecoration(
                  borderRadius: BorderRadius.circular(999.r),
                  gradient: LinearGradient(
                    colors: [primaryBlue, primaryBlueEnd, accentMint, accentSun],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.22),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildIconOrImage({
    required TabItem item,
    required bool selected,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    if (item.image != null) {
      return ClipOval(
        child: Image(
          image: item.image!,
          width: widget.iconSize.r,
          height: widget.iconSize.r,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return SizedBox(
        width: widget.iconSize.r,
        height: widget.iconSize.r,
        child: Center(child: item.icon),
      );
      //return Icon(item.icon, size: widget.iconSize.r, color: selected ? selectedColor : unselectedColor);
    }
  }
}
