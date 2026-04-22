import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/colors_Manager.dart';
import '../../../../../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../../../../core/services/stdProfile/stdLinksServices/studentBook/student_book_service.dart';

class StudentBookNewMessageScreen extends StatefulWidget {
  const StudentBookNewMessageScreen({super.key});

  @override
  State<StudentBookNewMessageScreen> createState() => _StudentBookNewMessageScreenState();
}

class _StudentBookNewMessageScreenState extends State<StudentBookNewMessageScreen> {
  bool loading = true;
  bool sending = false;

  List<dynamic> departments = [];
  dynamic selectedDepartment;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _prepare() async {
    final stdId = studentNotifier.value.stdId?.toString() ?? '';
    final result = await StudentBookService.prepareNewStdMsg(stdId: stdId);

    if (!mounted) return;

    List<dynamic> list = [];
    if (result is Map<String, dynamic>) {
      list = result["Data"] ?? result["data"] ?? [];
    } else if (result is List) {
      list = result;
    }

    setState(() {
      departments = list;
      loading = false;
    });
  }

  Future<void> _send() async {
    final stdId = studentNotifier.value.stdId?.toString() ?? '';
    final subject = _subjectController.text.trim();
    final body = _messageController.text.trim();

    if (selectedDepartment == null || subject.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_fill_all_fields'.tr())),
      );
      return;
    }

    final matNo = selectedDepartment["mat_no"]?.toString() ?? '';

    setState(() => sending = true);

    final ok = await StudentBookService.sendNewStdMsg(
      stdId: stdId,
      subject: subject,
      body: body,
      matNo: matNo,
    );

    if (!mounted) return;

    setState(() => sending = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('message_sent_successfully'.tr())),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('failed_to_send_message'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentName = studentNotifier.value.stdFirstname ?? '';
    final primary = ColorsManager.primaryGradientStart;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text('new_message'.tr()),
        backgroundColor: isDark ? Colors.black54 : Colors.white.withOpacity(0.12),
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16.w,
            12.h,
            16.w,
            MediaQuery.of(context).viewInsets.bottom + 16.h,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.r),
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.9),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: primary.withOpacity(0.12),
                      child: Icon(Icons.school_outlined, color: primary),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        "${'student'.tr()}: $studentName",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),

              Container(
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
                    _label('choose_department'.tr()),
                    SizedBox(height: 8.h),
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                      ),
                      child: DropdownButtonFormField<dynamic>(
                        value: selectedDepartment,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        decoration: _inputDecoration(context).copyWith(
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.grey.shade50,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        dropdownColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                        hint: Text(
                          'select_department'.tr(),
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                        items: departments.map((e) {
                          return DropdownMenuItem<dynamic>(
                            value: e,
                            child: Text(
                              e["mat_desc"]?.toString() ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedDepartment = value);
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _label('subject'.tr()),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: _subjectController,
                      decoration: _inputDecoration(
                        context,
                        hint: 'subject'.tr(),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _label('message'.tr()),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: _messageController,
                      minLines: 6,
                      maxLines: 10,
                      decoration: _inputDecoration(
                        context,
                        hint: 'write_your_message_here'.tr(),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        onPressed: sending ? null : _send,
                        icon: sending
                            ? SizedBox(
                          width: 16.r,
                          height: 16.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Icon(Icons.send),
                        label: Text(sending ? 'sending'.tr() : 'send'.tr()),
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

  Widget _label(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 13.5.sp,
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, {String? hint}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = ColorsManager.primaryGradientStart;

    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
      hintStyle: TextStyle(
        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.55),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.06),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: primary.withOpacity(0.6),
          width: 1.2,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide.none,
      ),
    );
  }}