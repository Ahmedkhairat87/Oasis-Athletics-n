import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicalStatusChip extends StatelessWidget {
  final bool isRead;
  final Color color;
  final String readLabel;
  final String unreadLabel;
  final IconData readIcon;
  final IconData unreadIcon;

  const MedicalStatusChip({
    super.key,
    required this.isRead,
    required this.color,
    this.readLabel = 'Read',
    this.unreadLabel = 'Unread',
    this.readIcon = Icons.check_circle,
    this.unreadIcon = Icons.mark_email_unread,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = isRead ? color : Colors.redAccent;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999.r),
        color: isRead ? color.withOpacity(0.12) : Colors.red.withOpacity(0.10),
        border: Border.all(color: activeColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isRead ? readIcon : unreadIcon, size: 14.sp, color: activeColor),
          SizedBox(width: 4.w),
          Text(
            isRead ? readLabel : unreadLabel,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: activeColor,
            ),
          ),
        ],
      ),
    );
  }
}
