import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/home_screen/Home/student_inside_tabs/tabs/student_book/student_book_details.dart';
import 'package:oasisathletic/ui/home_screen/Home/student_inside_tabs/tabs/student_book/student_book_send.dart';
import '../../../../../../../core/colors_Manager.dart';
import '../../../../../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../../../../../core/reusable_components/app_background.dart';
import '../../../../../../core/model/stdLinks/stdBook/InboxResponse.dart';
import '../../../../../../core/model/stdLinks/stdBook/SentResponse.dart';
import '../../../../../../core/services/stdProfile/stdLinksServices/studentBook/student_book_service.dart';

class StudentBookScreen extends StatefulWidget {
  static const routeName = '/student-book';
  const StudentBookScreen({super.key});

  @override
  State<StudentBookScreen> createState() => _StudentBookScreenState();
}

class _StudentBookScreenState extends State<StudentBookScreen> {
  bool loading = true;
  String selectedTab = "Inbox";

  List<InboxResponse> inboxMessages = [];
  List<SentResponse> sentMessages = [];

  @override
  void initState() {
    super.initState();
    _fetchStudentBook();
  }

  Future<void> _fetchStudentBook() async {
    setState(() => loading = true);

    final stdId = studentNotifier.value.stdId?.toString() ?? '';
    final result = await StudentBookService.getStudentBook(stdId: stdId);

    if (!mounted) return;

    setState(() {
      inboxMessages = result?.data ?? [];
      sentMessages = result?.data2 ?? [];
      loading = false;
    });
  }

  Future<void> _openInboxMessage(InboxResponse msg) async {
    final taSer = (msg.taSer ?? 0).toInt();
    final replyBody = await StudentBookService.updateStdMsgFlag(taSer: taSer);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentBookDetailsScreen(
          inboxMessage: msg,
          isSent: false,
          replyBody: replyBody,
        ),
      ),
    ).then((_) => _fetchStudentBook());
  }

  void _openSentMessage(SentResponse msg) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentBookDetailsScreen(
          sentMessage: msg,
          isSent: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final studentName = studentNotifier.value.stdFirstname ?? '';
    final unreadCount = inboxMessages.where((e) => (e.viewedIMG ?? 0) == 1).length;

    final Color primaryBlue = isDark
        ? ColorsManager.primaryGradientStartDark
        : ColorsManager.primaryGradientStart;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentSun = ColorsManager.accentSun;

    return Scaffold(
      extendBodyBehindAppBar: false,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_outlined),
        label: Text('new_message'.tr()),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const StudentBookNewMessageScreen(),
            ),
          );
          _fetchStudentBook();
        },
      ),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black54 : Colors.white.withOpacity(0.15),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'student_book'.tr(),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white70 : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: AppBackground(
        useAppBarBlur: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            children: [
              _ModernHeaderCard(
                studentName: studentName,
                selectedTab: selectedTab,
                unreadCount: inboxMessages.length,
                sentCount: sentMessages.length,
                primaryBlue: primaryBlue,
                accentMint: accentMint,
                accentSky: accentSky,
                accentSun: accentSun,
              ),
              SizedBox(height: 16.h),
              _buildTopTabs(
                isDark: isDark,
                primaryBlue: primaryBlue,
                accentSky: accentSky,
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                  onRefresh: _fetchStudentBook,
                  child: _buildMessagesList(isDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopTabs({
    required bool isDark,
    required Color primaryBlue,
    required Color accentSky,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          _buildTopTab(
            title: "Inbox".tr(),
            isDark: isDark,
            selected: selectedTab == "Inbox",
            onTap: () => setState(() => selectedTab = "Inbox"),
            primaryBlue: primaryBlue,
            accentSky: accentSky,
          ),
          _buildTopTab(
            title: 'sent'.tr(),
            isDark: isDark,
            selected: selectedTab == "Sent",
            onTap: () => setState(() => selectedTab = "Sent"),
            primaryBlue: primaryBlue,
            accentSky: accentSky,
          ),
        ],
      ),
    );
  }

  Widget _buildTopTab({
    required String title,
    required bool isDark,
    required bool selected,
    required VoidCallback onTap,
    required Color primaryBlue,
    required Color accentSky,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            gradient: selected
                ? LinearGradient(
              colors: [
                primaryBlue,
                accentSky,
              ],
            )
                : null,
            color: selected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: selected
                ? [
              BoxShadow(
                color: primaryBlue.withOpacity(0.18),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ]
                : [],
          ),
          child: Text(
            title.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : (isDark ? Colors.white70 : Colors.black54),
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesList(bool isDark) {
    if (selectedTab == "Inbox") {
      if (inboxMessages.isEmpty) {
        return _EmptyStateCard(
          title: 'no_messages_found'.tr(),
          subtitle: "refresh".tr(),
        );
      }

      return ListView.builder(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: inboxMessages.length,
        itemBuilder: (context, index) {
          final msg = inboxMessages[index];
          final isUnread = (msg.viewedIMG ?? 0) == 1;

          return _StudentBookMessageCard(
            title: msg.subject ?? '',
            subtitle: msg.body ?? '',
            sender: msg.empName ?? '',
            date: msg.editDate ?? '',
            department: msg.matDesc ?? '',
            isUnread: isUnread,
            onTap: () => _openInboxMessage(msg),
          );
        },
      );
    }

    if (sentMessages.isEmpty) {
      return _EmptyStateCard(
        title: 'no_messages_found'.tr(),
        subtitle: "noSent".tr(),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemCount: sentMessages.length,
      itemBuilder: (context, index) {
        final msg = sentMessages[index];

        return _StudentBookMessageCard(
          title: msg.subject ?? '',
          subtitle: msg.body ?? '',
          sender: msg.empName ?? '',
          date: msg.editDate ?? '',
          department: msg.matDesc ?? '',
          isUnread: false,
          onTap: () => _openSentMessage(msg),
        );
      },
    );
  }
}

class _ModernHeaderCard extends StatelessWidget {
  final String studentName;
  final String selectedTab;
  final int unreadCount;
  final int sentCount;
  final Color primaryBlue;
  final Color accentMint;
  final Color accentSky;
  final Color accentSun;

  const _ModernHeaderCard({
    required this.studentName,
    required this.selectedTab,
    required this.unreadCount,
    required this.sentCount,
    required this.primaryBlue,
    required this.accentMint,
    required this.accentSky,
    required this.accentSun,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.04),
          ]
              : [
            Colors.white.withOpacity(0.92),
            Colors.blue.shade50.withOpacity(0.72),
          ],
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : primaryBlue.withOpacity(0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54.w,
            height: 54.w,
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
            ),
            child: const Icon(Icons.menu_book_rounded, color: Colors.white),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'student_book'.tr(),
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  studentName.isEmpty
                      ? 'Parent ↔ Teacher communication'
                      : '$studentName • Parent ↔ Teacher communication',
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.72),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _CountPill(
                label: 'inbox'.tr(),
                value: unreadCount,
                color: primaryBlue,
              ),
              SizedBox(height: 8.h),
              _CountPill(
                label: 'sent'.tr(),
                value: sentCount,
                color: accentSun,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _CountPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: color,
          fontSize: 11.5.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StudentBookMessageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String sender;
  final String date;
  final String department;
  final bool isUnread;
  final VoidCallback onTap;

  const _StudentBookMessageCard({
    required this.title,
    required this.subtitle,
    required this.sender,
    required this.date,
    required this.department,
    required this.isUnread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = ColorsManager.primaryGradientStart;
    final accent = ColorsManager.accentSky;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Ink(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                  Colors.white.withOpacity(0.06),
                  Colors.white.withOpacity(0.03),
                ]
                    : [
                  Colors.white,
                  Colors.blue.shade50.withOpacity(0.55),
                ],
              ),
              border: Border.all(
                color: isUnread
                    ? primary.withOpacity(0.35)
                    : (isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.05)),
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        gradient: LinearGradient(
                          colors: [
                            primary.withOpacity(0.16),
                            accent.withOpacity(0.14),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.person_outline_rounded,
                        color: primary,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  sender,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.5.sp,
                                  ),
                                ),
                              ),
                              if (isUnread)
                                Container(
                                  width: 10.r,
                                  height: 10.r,
                                  margin: EdgeInsets.only(left: 8.w),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.redAccent.withOpacity(0.35),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            department,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.65),
                              fontSize: 12.5.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.35,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.72),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        date,
                        style: TextStyle(
                          color: primary,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16.sp,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.45),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyStateCard({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final primary = ColorsManager.primaryGradientStart;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 50.h),
        Container(
          padding: EdgeInsets.all(22.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.9),
            border: Border.all(
              color: primary.withOpacity(0.08),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withOpacity(0.10),
                ),
                child: Icon(
                  Icons.mark_email_read_outlined,
                  size: 34.sp,
                  color: primary,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  height: 1.4,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.72),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}