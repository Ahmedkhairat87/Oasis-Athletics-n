import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/home_screen/Home/student_inside_tabs/tabs/student_book/widget/expandable_text.dart';
import '../../../../../../../core/colors_Manager.dart';
import '../../../../../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../../../../core/model/stdLinks/stdBook/InboxResponse.dart';
import '../../../../../../core/model/stdLinks/stdBook/SentResponse.dart';
import '../../../../../../core/services/stdProfile/stdLinksServices/studentBook/student_book_service.dart';

class StudentBookDetailsScreen extends StatefulWidget {
  final InboxResponse? inboxMessage;
  final SentResponse? sentMessage;
  final bool isSent;
  final String? replyBody;

  const StudentBookDetailsScreen({
    super.key,
    this.inboxMessage,
    this.sentMessage,
    required this.isSent,
    this.replyBody,
  });

  @override
  State<StudentBookDetailsScreen> createState() => _StudentBookDetailsScreenState();
}

class _StudentBookDetailsScreenState extends State<StudentBookDetailsScreen> {
  late final TextEditingController _replyController;
  bool sending = false;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController(text: widget.replyBody ?? '');
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _sendReply() async {
    final body = _replyController.text.trim();
    if (body.isEmpty) return;

    final taSer = (widget.inboxMessage?.taSer ?? 0).toInt();
    final stdId = studentNotifier.value.stdId?.toString() ?? '';

    setState(() => sending = true);

    final ok = await StudentBookService.sendReply(
      stdId: stdId,
      taSer: taSer,
      body: body,
    );

    if (!mounted) return;

    setState(() => sending = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('reply_sent_successfully'.tr())),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('failed_to_send_reply'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = ColorsManager.primaryGradientStart;

    final title = widget.isSent
        ? (widget.sentMessage?.subject ?? '')
        : (widget.inboxMessage?.subject ?? '');

    final sender = widget.isSent
        ? (widget.sentMessage?.empName ?? '')
        : (widget.inboxMessage?.empName ?? '');

    final date = widget.isSent
        ? (widget.sentMessage?.editDate ?? '')
        : (widget.inboxMessage?.editDate ?? '');

    final body = widget.isSent
        ? (widget.sentMessage?.body ?? '')
        : (widget.inboxMessage?.body ?? '');

    final hasReply = (widget.replyBody ?? '').trim().isNotEmpty;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text('message_details'.tr()),
        backgroundColor: isDark ? Colors.black54 : Colors.white.withOpacity(0.12),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: isDark
                      ? Colors.white.withOpacity(0.06)
                      : Colors.white.withOpacity(0.92),
                  border: Border.all(
                    color: primary.withOpacity(0.10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: primary.withOpacity(0.12),
                          child: Icon(Icons.person_outline_rounded, color: primary),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            sender,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5.sp,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
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
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 14.h),

              _DetailsSectionCard(
                title: 'message'.tr(),
                child: ExpandableText(
                  text: body,
                  trimLines: 5,
                ),
              ),

              SizedBox(height: 14.h),

              if (widget.isSent)
                _DetailsSectionCard(
                  title: 'reply'.tr(),
                  child: Text(
                    'sent_message_no_reply'.tr(),
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 14.sp,
                    ),
                  ),
                )
              else if (hasReply)
                _DetailsSectionCard(
                  title: 'reply'.tr(),
                  child: ExpandableText(
                    text: widget.replyBody ?? '',
                    trimLines: 5,
                  ),
                )
              else
                _DetailsSectionCard(
                  title: 'reply'.tr(),
                  child: Column(
                    children: [
                      TextField(
                        controller: _replyController,
                        minLines: 4,
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText: 'write_your_reply_here'.tr(),
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          onPressed: sending ? null : _sendReply,
                          child: sending
                              ? SizedBox(
                            width: 18.r,
                            height: 18.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Text('send'.tr()),
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

class _DetailsSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailsSectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}