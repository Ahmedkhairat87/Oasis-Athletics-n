import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicalDownloadButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? tooltip;
  final String? label;

  const MedicalDownloadButton({
    super.key,
    required this.onPressed,
    this.tooltip,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Theme.of(context).colorScheme.primary;

    if (label == null) {
      // Icon-only (used inside list items)
      return IconButton(
        onPressed: onPressed,
        icon: Icon(Icons.file_download, size: 20.sp, color: iconColor),
        tooltip: tooltip ?? 'Download',
      );
    }

    // Text + icon button (used in InBody / dialogs)
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.file_download),
      label: Text(label!),
    );
  }
}
