import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/colors_Manager.dart';


InputDecoration medicalInputDecoration(
    BuildContext context,
    String label,
    ) {
  return InputDecoration(
    labelText: label,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
    ),
    filled: true,
    fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.98),
    contentPadding:
    EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
  );
}

Widget sectionHeader(String title, {String? subtitle}) {
  return Padding(
    padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
          ),
      ],
    ),
  );
}

Widget smallHint(String text) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Text(
      text,
      style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
    ),
  );
}

Widget sectionCard(BuildContext context, Widget child,
    {EdgeInsets? padding}) {
  final isLight = Theme.of(context).brightness == Brightness.light;

  final start = isLight
      ? ColorsManager.primaryGradientStart
      : ColorsManager.primaryGradientStartDark;
  final end = isLight
      ? ColorsManager.primaryGradientEnd
      : ColorsManager.primaryGradientEndDark;

  return Container(
    width: double.infinity,
    padding: padding ?? EdgeInsets.all(12.w),
    decoration:
        isLight
            ? BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  start.withOpacity(0.06),
                  end.withOpacity(0.03),
                ],
              ),
              border: Border.all(color: Colors.black.withOpacity(0.04)),
            )
            : BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.35),
              ),
            ),
    child: child,
  );
}

Widget editableWrapper(bool enabled, Widget child) {
  return AbsorbPointer(
    absorbing: !enabled,
    child: Opacity(
      opacity: enabled ? 1.0 : 0.98,
      child: child,
    ),
  );
}
