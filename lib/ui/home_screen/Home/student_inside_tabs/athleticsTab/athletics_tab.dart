import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/colors_Manager.dart';
import '../../../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../../../core/services/stdProfile/stdAthleticServices/StdAthleticLinksService.dart';
import '../../../../webView-attachmentopener/openAttachment.dart';

class AthleticsReport {
  final String id;
  final DateTime publishedAt;
  DateTime? readAt; // null => not read yet
  final String fileName; // pretend file
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
  bool get isLight => Theme.of(context).brightness == Brightness.light;
  Color get titleColor =>
      isLight
          ? ColorsManager.primaryGradientStart
          : Theme.of(context).colorScheme.onSurface;
  // mock reports - replace with API data later

  bool loading = false;
  List<AthleticsReport> _reports = [];
  // show date only
  final DateFormat _df = DateFormat.yMMMd();

  @override
  void initState() {
    super.initState();
    loadAthleticReports();
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
              return AthleticsReport(
                id: e.reportType ?? '',
                publishedAt: DateTime.parse(e.uploadDate!),
                readAt:
                    e.parentRead == 1 && e.readedDate != null
                        ? DateTime.parse(e.readedDate!)
                        : null,
                fileName: e.filePath?.split('/').last ?? '',
                filePath: e.filePath ?? '',
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

    // Outer padding: only horizontal and small bottom — no top padding so list is flush with parent
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
    final Color titleColor = isLight
        ? primaryBlue
        : Theme.of(context).colorScheme.onSurface;

    final bool isRead = r.isRead;
    final Color statusColor = isRead ? accentMint : accentCoral;

    return TweenAnimationBuilder<double>(
      // ✅ same fix here: 0 → 1 and clamp
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
            // small index circle (fixed size) with gradient
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
                          'Report ${r.id}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(width: 8.w),

                      // View button
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
                        onPressed: () => _onViewReport(context, r),
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

                  // Second row: published (wraps) + status badge aligned to right
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // published text - allow wrapping and multiple lines without overflow
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

                      // status badge (kept compact)
                      _statusBadge(isRead, statusColor),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // read date line (if any) - date only
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
    // mark as read (update readAt)
    setState(() {
      r.readAt ??= DateTime.now();
    });

    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentCoral = ColorsManager.accentCoral;

    // show bottom sheet with details + download button
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return TweenAnimationBuilder<double>(
          // this TweenAnimationBuilder only scales, no opacity → safe
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
                      // handle
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
                        'Report ${r.id}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: titleColor,
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

                      // fake preview / metadata
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
                              'File: ${r.fileName}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'This is a placeholder preview for the report file. In production you would show a PDF preview or similar.',
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
                              onPressed: () {
                                Navigator.pop(context); // close bottom sheet
                                openAttachment(
                                  context,
                                  r.filePath,
                                ); // open WebView
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
                            onPressed: () {
                              Navigator.pop(context);
                              openAttachment(context, r.filePath);
                            },
                            child: Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: titleColor,
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

  void _simulateDownload(
    BuildContext context,
    AthleticsReport r,
    Color accentCoral,
  ) async {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('Starting download ${r.fileName}...'),
        backgroundColor: accentCoral.withOpacity(0.9),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 900));

    scaffold.hideCurrentSnackBar();
    scaffold.showSnackBar(
      SnackBar(
        content: Text('Downloaded ${r.fileName}'),
        backgroundColor: accentCoral.withOpacity(0.9),
      ),
    );
  }
}
