// lib/core/reusable_components/student_tab_pages.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentTabPages extends StatelessWidget {
  const StudentTabPages({
    super.key,
    required this.pages,
    required this.controller,
    this.onPageChanged,
  });

  final List<Widget> pages;
  final PageController controller;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: pages.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 420),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            final offsetAnim = Tween<Offset>(
              begin: Offset(0.0, 0.05),
              end: Offset.zero,
            ).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offsetAnim, child: child),
            );
          },
          child: Container(
            key: ValueKey(index),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header/title (each page may include its own header inside the widget)
                Expanded(child: pages[index]),
              ],
            ),
          ),
        );
      },
    );
  }
}
