// lib/ui/messages/send_messages_screen.dart
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oasisathletic/core/apiControl/apiManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/colors_Manager.dart';
import '../../../core/model/newMessageModels/Departments/DepartmentEmployee.dart';
import '../../../core/model/newMessageModels/mainCategories/ToTypes.dart';
import '../../../core/model/regStdModels/stdData.dart';
import '../../../core/reusable_components/app_background.dart';
import '../../../core/services/sideMenu/messagesServices/getDepartmentsServices.dart';
import '../../../core/services/sideMenu/messagesServices/getEmpsServices.dart';
import '../../../core/services/sideMenu/messagesServices/sendMessageServices/sendMessageServices.dart';
import '../Home/mianwrapper.dart';
import 'messages.dart';

/// Messages screen: choose child -> recipient type -> recipient -> subject -> message -> send
class sendMessagesScreen extends StatefulWidget {
  static const routeName = '/sendMessagesScreen';
  const sendMessagesScreen({super.key});

  @override
  State<sendMessagesScreen> createState() => _sendMessagesScreenState();
}

class _sendMessagesScreenState extends State<sendMessagesScreen> {
  // ✅ بيانات من SharedPreferences / API
  List<stdData> students = [];
  stdData? selectedStudent;

  List<ToCategory> allCategories = [];
  List<ToCategory> categories = [];
  ToCategory? selectedCategory;

  List<DepartmentEmployee> employees = [];
  DepartmentEmployee? selectedEmployee;

  bool loadingStudents = true;
  bool loadingCategories = false;
  bool loadingEmployees = false;

  final List<File> attachments = [];
  final int maxAttachments = 5;

  String token = "";

  // === UI state ===
  // RecipientType selectedRecipientType = RecipientType.teacher;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  Future<void> initScreen() async {
    await loadToken();
    await loadStudents();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
  }

  Future<void> loadStudents() async {
    final result = await getStudentsFromPrefs();

    if (result.isNotEmpty) {
      selectedStudent = result.first;
      await loadDepartments(selectedStudent!);
    }

    setState(() {
      students = result;
      loadingStudents = false;
    });

    print("✅ Loaded students: ${students.length}");
    print("✅ Loaded categories count: ${categories.length}");
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<List<stdData>> getStudentsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("students");

    if (data == null || data.isEmpty) return [];

    final List decoded = jsonDecode(data);

    return decoded.map((e) => stdData.fromJson(e)).toList();
  }

  Future<void> loadDepartments(stdData student) async {
    setState(() {
      loadingCategories = true;
      categories.clear();
      employees.clear();
      selectedCategory = null;
      selectedEmployee = null;
    });

    try {
      final response = await GetDepartmentsService.GetDepartmentsResponse(
        token: token,
        selectedStd: "${student.stdId}|${student.oasisAthleticFlag}",
      );

      setState(() {
        categories = response.toTypes ?? [];
        loadingCategories = false;
      });
    } catch (e) {
      print("❌ Error Loading Departments: $e");
      setState(() => loadingCategories = false);
    }
  }

  Future<void> loadEmployees(ToCategory category) async {
    if (selectedStudent == null) return;
    setState(() {
      loadingEmployees = true;
      employees.clear();
      selectedEmployee = null;
    });

    try {
      print(APIManager.getDepartmentsEmps);
      final response = await GetEmpsService.GetEmployeeResponse(
        token: token,
        selectedStd:
        "${selectedStudent!.stdId}|${selectedStudent!.oasisAthleticFlag}",
        toCategNo: category.msgCategNo.toString(),
      );

      setState(() {
        employees = response.toDepartment ?? [];
        loadingEmployees = false;
      });
    } catch (e) {
      print("❌ Error Loading Employees: $e");
      setState(() => loadingEmployees = false);
    }
  }

  //image and files attach func
  Future<void> pickAttachment({bool isImage = false}) async {
    if (attachments.length >= maxAttachments) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Maximum 5 files allowed")));
      return;
    }

    try {
      if (isImage) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          setState(() {
            attachments.add(File(pickedFile.path));
          });
        }
      } else {
        final result = await FilePicker.platform.pickFiles(allowMultiple: true);

        if (result != null) {
          final files =
          result.files
              .where((f) => f.path != null)
              .map((f) => File(f.path!))
              .toList();

          setState(() {
            final remaining = maxAttachments - attachments.length;
            attachments.addAll(files.take(remaining));
          });
        }
      }
    } catch (e) {
      print("❌ Attachment Error: $e");
    }
  }

  Future<void> _onSend() async {
    if (selectedStudent == null || selectedCategory == null || selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Please fill out all fields"), backgroundColor: Colors.red),
      );
      return;
    }

    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Please write a message"), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final response = await SendMessageService.sendMessageWithAttachments(
        token: token,
        empNo: selectedEmployee!.empNo.toString(),
        matNo: selectedEmployee!.matNo.toString(),
        forGrade: selectedStudent!.currentGrade.toString(),
        fromStdId: selectedStudent!.stdId.toString(),
        noteSubject: _subjectController.text,
        body: _messageController.text,
        toType: selectedCategory!.msgCategNo.toString(),
        attachments: attachments,
      );

      final int result = int.tryParse(response.data.toString()) ?? 0;

      if (result <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Failed to send message"), backgroundColor: Colors.red),
        );
        return;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Message sent successfully"), backgroundColor: Colors.green),
      );

      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;

      final nav = Navigator.of(context);
      nav.pushNamedAndRemoveUntil(MainWrapper.routeName, (route) => false);
      nav.pushNamed(Messages.routeName);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Server error while sending"), backgroundColor: Colors.red),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryBlue = ColorsManager.primaryGradientStart;

    return Scaffold(
      body: AppBackground(
        useAppBarBlur: false,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                SizedBox(height: 6.h),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.iconTheme.color,
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'New Message',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // ✅ Make the content scrollable to prevent RenderFlex overflow
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- select student (child) ---
                        _sectionTitle('Select child'),
                        SizedBox(height: 8.h),
                        SizedBox(
                          height: 120.h,
                          child: loadingStudents
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: students.length,
                            separatorBuilder: (_, __) => SizedBox(width: 8.w),
                            itemBuilder: (context, index) {
                              final student = students[index];
                              final selected = selectedStudent?.stdId == student.stdId;
                              return GestureDetector(
                                onTap: () {
                                  setState(() => selectedStudent = student);
                                  loadDepartments(student);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 120.w,
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? primaryBlue.withOpacity(0.12)
                                        : theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: selected ? primaryBlue : Colors.transparent,
                                      width: selected ? 1.4 : 0,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 32.r,
                                        backgroundImage: NetworkImage(student.stdPicture ?? ""),
                                        onBackgroundImageError: (_, __) {},
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        student.stdFirstname ?? "",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // --- recipient type buttons ---
                        _sectionTitle('Send to'),
                        SizedBox(height: 8.h),
                        _sectionTitle('Choose Department'),
                        SizedBox(height: 8.h),

                        loadingCategories
                            ? const Center(child: CircularProgressIndicator())
                            : DropdownButtonFormField<ToCategory>(
                          isExpanded: true,
                          initialValue: selectedCategory,
                          hint: const Text("Select Department"),
                          items: categories.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  e.msgCategDesc ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                            if (value != null) loadEmployees(value);
                          },
                        ),

                        SizedBox(height: 12.h),

                        // --- recipient dropdown ---
                        _sectionTitle('Choose recipient'),
                        SizedBox(height: 8.h),
                        DropdownButtonFormField<DepartmentEmployee>(
                          isExpanded: true,
                          initialValue: selectedEmployee,
                          hint: const Text("Select Employee"),
                          items: employees.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  e.matDesc ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => selectedEmployee = value),
                        ),

                        SizedBox(height: 12.h),

                        // --- Subject ---
                        _sectionTitle('Subject'),
                        SizedBox(height: 8.h),
                        _GlassTextField(
                          controller: _subjectController,
                          hintText: 'Subject (optional)',
                          minLines: 1,
                          maxLines: 3,
                        ),

                        SizedBox(height: 12.h),

                        // --- Message ---
                        _sectionTitle('Message'),
                        SizedBox(height: 8.h),

                        // ✅ Give the message field a fixed height inside a scroll view
                        SizedBox(
                          height: 220.h,
                          child: _GlassTextField(
                            controller: _messageController,
                            hintText: 'Write your message here...',
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Attachments
                        _sectionTitle('Attachments'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.image),
                              onPressed: () => pickAttachment(isImage: true),
                            ),
                            IconButton(
                              icon: const Icon(Icons.attach_file),
                              onPressed: () => pickAttachment(),
                            ),
                            Text("${attachments.length}/5 attached"),
                          ],
                        ),
                        SizedBox(height: 12.h),

                        // Send button
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _onSend,
                                icon: const Icon(Icons.send),
                                label: const Text('Send'),
                              ),
                            ),
                          ],
                        ),

                        if (attachments.isNotEmpty) ...[
                          SizedBox(height: 12.h),
                          SizedBox(
                            height: 90,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: attachments.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final file = attachments[index];
                                final fileName = file.path.split('/').last;

                                return Stack(
                                  children: [
                                    Container(
                                      width: 90,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          file.path.endsWith(".jpg") || file.path.endsWith(".png")
                                              ? Image.file(
                                            file,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          )
                                              : const Icon(
                                            Icons.insert_drive_file,
                                            size: 35,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            fileName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            attachments.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Align(
    alignment: Alignment.centerLeft,
    child: Text(title, style: TextStyle(fontWeight: FontWeight.w700)),
  );
}

/// Reusable frosted / liquid glass text field wrapper.
///
/// It uses ClipRRect + BackdropFilter for true frosted glass over the animated AppBackground,
/// and adds a semi-transparent gradient, faint border and soft shadow to increase readability.
class _GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool expands;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;

  const _GlassTextField({
    required this.controller,
    required this.hintText,
    this.expands = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    // tweak these to taste
    final double blurSigma = 10.0;
    final Color overlayStart = Colors.white.withOpacity(0.08);
    final Color overlayEnd = Colors.white.withOpacity(0.04);
    final BorderRadius borderRadius = BorderRadius.circular(12.r);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          // the core glass layer
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [overlayStart, overlayEnd],
            ),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white.withOpacity(0.10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(6.w),
          child: Material(
            // use Material to ensure text selection/keyboard overlay looks native
            color: Colors.transparent,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              expands: expands,
              maxLines: expands ? null : maxLines,
              minLines: minLines,
              maxLength: maxLength,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
                counterText: '',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
