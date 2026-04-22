// lib/core/reusable_components/athletics_tab_report_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../colors_Manager.dart';
import 'athletics_tab_report.dart';

class AthleticsTabReportCard extends StatelessWidget {
  final AthleticsReport report;
  final int index;
  final VoidCallback onView;
  final DateFormat dateFormat;

  AthleticsTabReportCard({
    super.key,
    required this.report,
    required this.index,
    required this.onView,
    DateFormat? dateFormat,
  }) : dateFormat = dateFormat ?? DateFormat.yMMMd();

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color primaryBlue = ColorsManager.primaryGradientStart;
    final Color primaryBlueEnd = ColorsManager.primaryGradientEnd;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentCoral = ColorsManager.accentCoral;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;

    final Color cardBaseColor =
        isLight ? Colors.white : ColorsManager.darkFields;
    final bool isRead = report.isRead;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 6),
          child: Transform.scale(scale: value, child: child),
        );
      },
      child: Container(
        decoration:
            isLight
                ? BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryBlue.withOpacity(0.08),
                      primaryBlueEnd.withOpacity(0.06),
                      accentSky.withOpacity(0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
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
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: cardBaseColor.withOpacity(0.96),
            borderRadius: BorderRadius.circular(14.r),
            border:
                isLight
                    ? Border.all(
                      color: (isRead ? accentMint : accentCoral).withOpacity(0.7),
                      width: 1.3,
                    )
                    : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // small index circle (fixed size) – colorful & animated
              _AnimatedIndexCircle(
                index: index,
                isRead: isRead,
                accentMint: accentMint,
                accentCoral: accentCoral,
              ),

              SizedBox(width: 12.w),

              // main content - flexible to avoid overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: title + View button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // title (takes remaining space)
                        Expanded(
                          child: Text(
                            'Report ${report.id}',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                            color:
                                isLight
                                    ? primaryBlue
                                    : Theme.of(context).colorScheme.onSurface,
                          ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(width: 8.w),

                        // View button – joyful gradient pill
                        _ViewButton(
                          onView: onView,
                          primaryBlue: primaryBlue,
                          accentMint: accentMint,
                          accentSun: accentSun,
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    // Second row: published (wraps) + status badge aligned to right
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // published text - allow wrapping and multiple lines without overflow
                        Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14.r,
                                color: accentSun.withOpacity(0.9),
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: Text(
                                  'Published: ${dateFormat.format(report.publishedAt)}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 8.w),

                        // status badge (compact, colorful, animated)
                        _StatusBadge(isRead: isRead),
                      ],
                    ),

                    SizedBox(height: 6.h),

                    // read date line (if any) - date only
                    Text(
                      report.readAt != null
                          ? 'Read on: ${dateFormat.format(report.readAt!)}'
                          : 'Not read yet',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated colorful index circle (left side)
class _AnimatedIndexCircle extends StatelessWidget {
  const _AnimatedIndexCircle({
    required this.index,
    required this.isRead,
    required this.accentMint,
    required this.accentCoral,
  });

  final int index;
  final bool isRead;
  final Color accentMint;
  final Color accentCoral;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = isRead ? accentMint : accentCoral;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 0.9,
            colors: [
              activeColor.withOpacity(0.15),
              activeColor.withOpacity(0.9),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: activeColor.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: activeColor, width: 1.4.w),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// Joyful gradient "View" button with subtle tap feel
class _ViewButton extends StatelessWidget {
  const _ViewButton({
    required this.onView,
    required this.primaryBlue,
    required this.accentMint,
    required this.accentSun,
  });

  final VoidCallback onView;
  final Color primaryBlue;
  final Color accentMint;
  final Color accentSun;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999.r),
          gradient: LinearGradient(
            colors: [primaryBlue, accentMint, accentSun],
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(999.r),
          onTap: onView,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Text(
              'View',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Colorful animated status badge
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isRead});

  final bool isRead;

  @override
  Widget build(BuildContext context) {
    final Color accentMint = ColorsManager.accentMint;
    final Color accentCoral = ColorsManager.accentCoral;

    final Color activeColor = isRead ? accentMint : accentCoral;
    final String label = isRead ? 'Read' : 'Unread';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: activeColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: activeColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isRead ? Icons.check_circle : Icons.mark_email_unread,
              size: 13.r,
              color: activeColor,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: activeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
