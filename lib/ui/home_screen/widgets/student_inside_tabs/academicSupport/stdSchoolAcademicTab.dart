// lib/ui/home_screen/widgets/student_inside_tabs/academic_tab.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/colors_Manager.dart';
import '../../../../../core/reusable_components/profile_tab_golden_card.dart';
import '../../../../../core/reusable_components/profile_tab_section_title.dart';
import '../../../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../../../core/services/stdProfile/SchoolAcademicLinksServices/StdSchoolAcademicLinksService.dart';
import '../../../../webView-attachmentopener/openAttachment.dart'; // adjust path if needed

class stdSchoolAcademicTab extends StatefulWidget {
  const stdSchoolAcademicTab({super.key});

  @override
  State<stdSchoolAcademicTab> createState() => _AcademicTabState();
}

class _AcademicTabState extends State<stdSchoolAcademicTab> {
  List<_LinkItem> _links = [];
  bool _loading = true;

  static const String _prefsKey = 'academic_links';

  @override
  void initState() {
    super.initState();
    loadAcademicLinks();
  }

  Future<void> loadAcademicLinks() async {
    setState(() => _loading = true);

    final stdId = studentNotifier.value.stdId.toString();

    final data = await StdSchoolAcademicLinksService.getAcademicLinks(
      stdId: stdId,
    );

    if (!mounted) return;

    setState(() {
      var responseData = data;
      _loading = false;

      if (data?.academicLinks != null && data!.academicLinks!.isNotEmpty) {
        _links =
            data.academicLinks!
                .where((e) => e.sublinkUrlnameE != null)
                .map(
                  (e) => _LinkItem(
                    url: e.sublinkUrlnameE!,
                    title: e.sublinkDescE,
                    schoolYear: null, // not provided by API
                  ),
                )
                .toList();
      } else {
        _links = [];
      }
    });
  }

  /// Determine current school year string like "2025/2026".
  String _currentSchoolYear() {
    final now = DateTime.now();
    final year = now.year;
    return now.month >= 9 ? '$year/${year + 1}' : '${year - 1}/$year';
  }

  Future<void> _loadLinks() async {
    setState(() => _loading = true);

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    final currentYear = _currentSchoolYear();

    if (raw == null || raw.isEmpty) {
      setState(() {
        _links = [];
        _loading = false;
      });
      return;
    }

    try {
      final List decoded = jsonDecode(raw);
      final List<_LinkItem> items =
          decoded.map((e) => _LinkItem.fromJson(e)).toList();

      // Filter by school year (keep items with no schoolYear or matching current)
      final filtered =
          items.where((item) {
            if (item.schoolYear == null || item.schoolYear!.isEmpty) {
              return true;
            }
            return item.schoolYear == currentYear;
          }).toList();

      setState(() {
        _links = filtered;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _links = [];
        _loading = false;
      });
    }
  }

  Future<void> _refresh() async => _loadLinks();

  void _open(String url) {
    openAttachment(context, url); // uses your existing viewer
  }

  void _actions(_LinkItem item) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.open_in_new),
                title: const Text('Open'),
                onTap: () {
                  Navigator.pop(ctx);
                  _open(item.url);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy link'),
                onTap: () {
                  Navigator.pop(ctx);
                  Clipboard.setData(ClipboardData(text: item.url));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Copied to clipboard")),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _icon(String url) {
    final u = url.toLowerCase();
    if (u.endsWith('.pdf')) return const Icon(Icons.picture_as_pdf, size: 36);
    if (u.endsWith('.png') || u.endsWith('.jpg') || u.endsWith('.jpeg')) {
      return const Icon(Icons.image, size: 36);
    }
    return const Icon(Icons.link, size: 36);
  }

  @override
  Widget build(BuildContext context) {
    final schoolYear = _currentSchoolYear();
    final isLight = Theme.of(context).brightness == Brightness.light;

    // Joyful palette (copied from AcademicSupportTab)
    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentPurple = ColorsManager.accentPurple;

    return SingleChildScrollView(
      //padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          final double t = value.clamp(0.0, 1.0);
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, (1 - t) * 10),
              child: child,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle('Academic Links'),
            SizedBox(height: 12.h),

            // Main GoldCard container like AcademicSupportTab
            GoldCard(
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TOP ROW: Icon + Title + school year
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                primaryBlue,
                                accentSky,
                                accentMint,
                                accentSun,
                                primaryBlue,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryBlue.withOpacity(0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.link,
                            color: Colors.white,
                            size: 28.r,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'Academic Links — $schoolYear',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    // LIST AREA (keeps your logic exactly)
                    SizedBox(
                      // give the inner list a bounded height similar to other tabs
                      height: 350.h,
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        child:
                            _loading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : _links.isEmpty
                                ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(height: 60.h),
                                    Center(
                                      child: Text(
                                        "No academic links available",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Center(
                                      child: Text(
                                        "Links from the stage coordinator will appear here.",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                : ListView.separated(
                                  itemCount: _links.length,
                                  separatorBuilder:
                                      (_, __) => SizedBox(height: 10.h),
                                  itemBuilder: (context, i) {
                                    final item = _links[i];

                                    // Liquid / multi-color card row — matches AcademicSupportTab style
                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 260,
                                      ),
                                      curve: Curves.easeOut,
                                      padding: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            accentSky.withOpacity(0.12),
                                            accentMint.withOpacity(0.10),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        border: Border.all(
                                          color: accentMint.withOpacity(0.9),
                                          width: 0.6.w,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryBlue.withOpacity(
                                              0.06,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          onTap: () => _open(item.url),
                                          onLongPress: () => _actions(item),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 12.h,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 56.w,
                                                  height: 56.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12.r,
                                                        ),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        primaryBlue.withOpacity(
                                                          0.14,
                                                        ),
                                                        accentSky.withOpacity(
                                                          0.10,
                                                        ),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: _icon(item.url),
                                                  ),
                                                ),
                                                SizedBox(width: 12.w),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item.title ?? item.url,
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 14.sp,
                                                          color: primaryBlue,
                                                        ),
                                                      ),
                                                      SizedBox(height: 6.h),
                                                      Text(
                                                        item.url,
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 11.sp,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.open_in_new,
                                                    color: accentSun,
                                                  ),
                                                  onPressed:
                                                      () => _open(item.url),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}

class _LinkItem {
  final String url;
  final String? title;
  final String? schoolYear;

  _LinkItem({required this.url, this.title, this.schoolYear});

  factory _LinkItem.fromJson(Map<String, dynamic> j) => _LinkItem(
    url: j['url'] ?? '',
    title: j['title'],
    schoolYear: j['schoolYear'],
  );

  Map<String, dynamic> toJson() => {
    'url': url,
    'title': title,
    'schoolYear': schoolYear,
  };
}
