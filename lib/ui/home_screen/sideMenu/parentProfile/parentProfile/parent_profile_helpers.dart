import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    final isEditable = editMode && canEdit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label),
            if (!canEdit) const SizedBox(width: 6),
            if (!canEdit) const Icon(CupertinoIcons.lock, size: 14),
          ],
        ),
        const SizedBox(height: 6),
        isEditable
            ? TextFormField(controller: controller)
            : Text(controller.text),
        const Divider(),
      ],
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
          SizedBox(height: 6.h),
          enabled
              ? DropdownButtonFormField<T>(
            value: value,
            items: items
                .map((e) => DropdownMenuItem<T>(
              value: e,
              child: Text(itemLabel(e)),
            ))
                .toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(border: InputBorder.none),
          )
              : Text(
            value != null ? itemLabel(value!) : '',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
          const Divider(),
        ],
      ),
    );
  }
}