import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 5.w,
            height: 22.h,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool editMode;
  final bool canEdit;

  const EditableField({
    super.key,
    required this.label,
    required this.controller,
    required this.editMode,
    this.canEdit = true,
  });

  String _displayValue(String value) {
    final v = value.trim();
    return v.isEmpty ? '—' : v;
  }

  @override
  Widget build(BuildContext context) {
    final isEditable = editMode && canEdit;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface.withOpacity(0.72),
                  ),
                ),
              ),
              if (!canEdit) ...[
                SizedBox(width: 6.w),
                Icon(
                  CupertinoIcons.lock_fill,
                  size: 14.sp,
                  color: scheme.onSurface.withOpacity(0.55),
                ),
              ],
            ],
          ),
          SizedBox(height: 7.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: double.infinity,
            padding: isEditable
                ? EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h)
                : EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: scheme.surface.withOpacity(0.88),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isEditable
                    ? scheme.primary.withOpacity(0.35)
                    : scheme.outline.withOpacity(0.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isEditable
                ? TextFormField(
              controller: controller,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 14.h,
                ),
                border: InputBorder.none,
                hintText: label,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: scheme.onSurface.withOpacity(0.35),
                ),
              ),
            )
                : Text(
              _displayValue(controller.text),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: controller.text.trim().isEmpty
                    ? scheme.onSurface.withOpacity(0.45)
                    : scheme.onSurface,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final bool enabled;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  const ProfileDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.enabled,
    required this.itemLabel,
    required this.onChanged,
  });

  String _displayValue() {
    if (value == null) return '—';
    final txt = itemLabel(value!).trim();
    return txt.isEmpty ? '—' : txt;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface.withOpacity(0.72),
            ),
          ),
          SizedBox(height: 7.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: double.infinity,
            padding: enabled
                ? EdgeInsets.zero
                : EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: scheme.surface.withOpacity(0.88),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: enabled
                    ? scheme.primary.withOpacity(0.35)
                    : scheme.outline.withOpacity(0.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: enabled
                ? DropdownButtonFormField<T>(
              value: value,
              isExpanded: true,
              items: items
                  .map(
                    (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    itemLabel(e),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
                  .toList(),
              onChanged: onChanged,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 14.h,
                ),
                border: InputBorder.none,
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: scheme.primary,
              ),
            )
                : Text(
              _displayValue(),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: value == null
                    ? scheme.onSurface.withOpacity(0.45)
                    : scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}