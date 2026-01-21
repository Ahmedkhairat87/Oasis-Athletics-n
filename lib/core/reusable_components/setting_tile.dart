import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'Notifiers/theme_mode_provider.dart';

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      leading: Icon(
        icon,
        color: isDarkMode ? Colors.white70 : Colors.blueGrey.shade700,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    );
  }
}
