// lib/core/reusable_components/labeled_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.controller,
    this.hint = '',
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  InputDecoration _decoration() {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: _decoration(),
    );
  }
}
