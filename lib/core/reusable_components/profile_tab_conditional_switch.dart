// lib/core/reusable_components/conditional_switch.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConditionalSwitch extends StatelessWidget {
  const ConditionalSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.child,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
        if (value && child != null) ...[SizedBox(height: 8.h), child!],
      ],
    );
  }
}
