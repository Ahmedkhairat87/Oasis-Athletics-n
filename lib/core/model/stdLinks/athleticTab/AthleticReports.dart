// lib/ui/home_screen/widgets/student_inside_tabs/academicSupport/athletics_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/colors_Manager.dart';
import '../../../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../../../core/services/stdProfile/stdAthleticServices/StdAthleticLinksService.dart';
import '../../../../ui/webView-attachmentopener/openAttachment.dart';

class AthleticsReport {
  final String id;
  final DateTime publishedAt;
  DateTime? readAt; // null => not read yet
  final String fileName;
  final String filePath;

  AthleticsReport({
    required this.id,
    required this.publishedAt,
    this.readAt,
    required this.fileName,
    required this.filePath,
  });

  bool get isRead => readAt != null;
}

class AthleticsTab extends StatefulWidget {
  const AthleticsTab({super.key});

  @override
  State<AthleticsTab> createState() => _AthleticsTabState();
}

class _AthleticsTabState extends State<AthleticsTab> {
  bool loading = false;
  List<AthleticsReport> _reports = [];

  // show date only
  final DateFormat _df = DateFormat.yMMMd();

  @override
  void initState() {
    super.initState();
    loadAthleticReports();
  }

  // --------- helpers ----------
  DateTime _safeParseDate(String? s, {DateTime? fallback}) {
    final f = fallback ?? DateTime(2000);
    if (s == null) return f;
    final t = s.trim();
    if (t.isEmpty || t.toLowerCase() == 'null') return f;
    return DateTime.tryParse(t) ?? f;
  }

  Future<void> loadAthleticReports() async {
    setState(() => loading = true);

    final stdId = studentNotifier.value.stdId.toString();

    final data = await StdAthleticLinksService.getAthleticReports(stdId: stdId);

    if (!mounted) return;

    setState(() {
      loading = false;
      _reports = [];

      if (data?.stdAthleticsReports != null &&
          data!.stdAthleticsReports!.isNotEmpty) {
        _reports =
            data.stdAthleticsReports!.map((e) {
              final filePath = (e.filePath ?? '').trim();
              return AthleticsReport(
                id: (e.reportType ?? '').trim(),
                publishedAt: _safeParseDate(e.uploadDate),
                readAt:
                    (e.parentRead == 1 && e.readedDate != null)
                        ? _safeParseDate(e.readedDate)
                        : null,
                fileName: filePath.isNotEmpty ? filePath.split('/').last : '',
                filePath: filePath,
              );
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // joyful palette
    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;

    // make a descending copy (newest first)
    final reports = [..._reports]
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
      child:
          loading
              ? const Center(child: CircularProgressIndicator())
              : reports.isEmpty
              ? Center(
                child: Text(
                  'No reports yet',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              )
              : TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  final double t = value.clamp(0.0, 1.0);
                  return Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, (1 - t) * 8),
                      child: child,
                    ),
                  );
                },
                child: ListView.separated(
                  padding: EdgeInsets.only(top: 0, bottom: 12.h),
                  physics: const BouncingScrollPhysics(),
                  itemCount: reports.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final r = reports[index];
                    return _reportCard(context, r, index, primaryBlue);
                  },
                ),
              ),
    );
  }

  Widget _reportCard(
    BuildContext context,
    AthleticsReport r,
    int index,
    Color primaryBlue,
  ) {
    final Color accentMint = ColorsManager.accentMint;
    final Color accentCoral = ColorsManager.accentCoral;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentPurple = ColorsManager.accentPurple;

    final bool isRead = r.isRead;
    final Color statusColor = isRead ? accentMint : accentCoral;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 200 + index * 40),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final double t = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 8),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface.withOpacity(0.96),
              statusColor.withOpacity(0.05),
            ],
          ),
          border: Border.all(color: statusColor.withOpacity(0.6), width: 1),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    statusColor.withOpacity(0.9),
                    statusColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Report ${r.id.isNotEmpty ? r.id : (index + 1)}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: primaryBlue,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(width: 8.w),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          minimumSize: Size(64.w, 36.h),
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                        onPressed:
                            r.filePath.isEmpty
                                ? null
                                : () => _onViewReport(context, r),
                        child: Text(
                          'View',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14.r,
                              color: accentSky.withOpacity(0.9),
                            ),
                            SizedBox(width: 6.w),
                            Flexible(
                              child: Text(
                                'Published: ${_df.format(r.publishedAt)}',
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

                      _statusBadge(isRead, statusColor),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  Text(
                    r.readAt != null
                        ? 'Read on: ${_df.format(r.readAt!)}'
                        : 'Not read yet',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(
                        context,
                      ).textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),

                  // Optional file name line (keeps UI, only adds info)
                  if (r.fileName.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Text(
                      r.fileName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: accentPurple.withOpacity(0.75),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(bool isRead, Color statusColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999.r),
        gradient: LinearGradient(
          colors: [statusColor.withOpacity(0.9), statusColor.withOpacity(0.75)],
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.35),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        isRead ? 'Read' : 'Unread',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  void _onViewReport(BuildContext context, AthleticsReport r) {
    // mark as read locally (UI only)
    setState(() {
      r.readAt ??= DateTime.now();
    });

    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;

    final Color accentMint = ColorsManager.accentMint;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentCoral = ColorsManager.accentCoral;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.9, end: 1.0),
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.42,
              minChildSize: 0.2,
              maxChildSize: 0.9,
              builder: (_, controller) {
                return SingleChildScrollView(
                  controller: controller,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 48.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999.r),
                            gradient: LinearGradient(
                              colors: [accentSky, accentMint],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      Text(
                        'Report ${r.id.isNotEmpty ? r.id : ''}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: primaryBlue,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Published: ${_df.format(r.publishedAt)}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall?.color?.withOpacity(0.9),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.surface.withOpacity(0.98),
                              accentSky.withOpacity(0.08),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: primaryBlue.withOpacity(0.12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'File: ${r.fileName.isNotEmpty ? r.fileName : '-'}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Tap Download to open the report in WebView.',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color?.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 18.h),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed:
                                  r.filePath.isEmpty
                                      ? null
                                      : () {
                                        Navigator.pop(context);
                                        openAttachment(context, r.filePath);
                                      },
                              icon: Icon(Icons.file_download, size: 18.r),
                              label: Text(
                                'Download',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.h,
                                  horizontal: 12.w,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                backgroundColor: accentCoral,
                                foregroundColor: Colors.white,
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      Row(
                        children: [
                          const Spacer(),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
