// lib/ui/home_screen/widgets/student_inside_tabs/medical_form_fields.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/colors_Manager.dart';

/// Reusable small widgets used by MedicalForm:
/// - SectionHeader
/// - SmallHint
/// - SectionCard
/// - inputDecoration
/// - BloodGroupChips
/// - CheckboxListFromMap

Widget SectionHeader(String title, {String? subtitle}) {
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

Widget SmallHint(String text) {
  return Padding(
    padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
    child: Text(
      text,
      style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
    ),
  );
}

class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const SectionCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color start =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final Color end =
        isLight
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
                  colors: [start.withOpacity(0.06), end.withOpacity(0.03)],
                ),
                border: Border.all(color: Colors.black.withOpacity(0.04)),
              )
              : BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withOpacity(0.35),
                ),
              ),
      child: child,
    );
  }
}

InputDecoration inputDecoration(BuildContext context, String label) {
  return InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
    fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.98),
    filled: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
  );
}

/// BloodGroupChips - stateless widget that accepts selected value and callback.
class BloodGroupChips extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const BloodGroupChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final groups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children:
          groups.map((g) {
            final selectedChip = selected == g;
            return ChoiceChip(
              label: Text(
                g,
                style: TextStyle(
                  color: selectedChip ? Colors.white : Colors.black,
                ),
              ),
              selected: selectedChip,
              onSelected: (_) => onChanged(g),
              selectedColor: ColorsManager.primaryGradientStart,
              backgroundColor: Theme.of(context).colorScheme.surface,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            );
          }).toList(),
    );
  }
}

/// CheckboxListFromMap - list of CheckboxListTile generated from Map<String,bool>
class CheckboxListFromMap extends StatelessWidget {
  final Map<String, bool> items;
  final void Function(String key, bool value) onChanged;

  const CheckboxListFromMap({
    super.key,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          items.keys.map((k) {
            return CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(k, style: TextStyle(fontSize: 13.sp)),
              value: items[k],
              activeColor: ColorsManager.accentMint,
              onChanged: (v) => onChanged(k, v ?? false),
            );
          }).toList(),
    );
  }
}
