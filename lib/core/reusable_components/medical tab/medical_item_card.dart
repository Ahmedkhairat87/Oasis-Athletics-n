import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicalItemCard extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const MedicalItemCard({
    super.key,
    required this.child,
    this.borderColor,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: padding ?? EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: (backgroundColor ?? scheme.surface.withOpacity(0.98)),
        border: Border.all(
          color: (borderColor ?? scheme.outline.withOpacity(0.5)),
        ),
      ),
      child: child,
    );
  }
}
