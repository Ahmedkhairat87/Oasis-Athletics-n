import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/core/reusable_components/app_colors_extension.dart';

class NewsletterWidget extends StatelessWidget {
  final String schoolYear;
  final String date;
  final VoidCallback view;

  const NewsletterWidget({
    super.key,
    required this.schoolYear,
    required this.date,
    required this.view,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color:
          isDark
              ? colors.fields.withOpacity(0.85)
              : Colors.white.withOpacity(0.85),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🏫 School Year
            Text(
              schoolYear,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? colors.textMainWhite : colors.textMainBlack,
              ),
              overflow: TextOverflow.ellipsis,
            ),

            // 📅 Date
            Text(
              date,
              style: TextStyle(
                fontSize: 15.sp,
                color:
                    isDark
                        ? colors.textMainWhite.withOpacity(0.9)
                        : colors.textMainBlack,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),

            // 📄 “View Letter” button
            ElevatedButton.icon(
              onPressed: view,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.btnBackMainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                minimumSize: Size(90.w, 36.h),
                elevation: 2,
              ),
              icon: Icon(
                Icons.text_snippet_outlined,
                color: colors.textMainWhite,
                size: 18.sp,
              ),
              label: Text(
                'View Letter',
                style: TextStyle(
                  color: colors.textMainWhite,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
