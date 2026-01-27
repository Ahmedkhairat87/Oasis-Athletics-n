import 'package:flutter/material.dart';
import 'medical_form_text_editor_sheet.dart';

class PreviewEditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final String? hint;
  final int sheetLines;

  const PreviewEditField({
    super.key,
    required this.label,
    required this.controller,
    required this.enabled,
    this.hint,
    this.sheetLines = 8,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () => showTextEditorSheet(
        context,
        title: label,
        targetController: controller,
        maxLines: sheetLines,
      )
          : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                (controller.text.trim().isEmpty)
                    ? (hint ?? 'Tap to enter')
                    : controller.text.trim(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.open_in_full,
              size: 18,
              color: enabled ? Colors.grey.shade700 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}