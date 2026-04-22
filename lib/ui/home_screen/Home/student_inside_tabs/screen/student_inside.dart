
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/home_screen/Home/student_inside_tabs/tabs/stdSchoolAcademicTab.dart';
import 'package:oasisathletic/ui/home_screen/Home/student_inside_tabs/tabs/forms/forms_tab.dart';
import 'package:oasisathletic/ui/home_screen/Home/student_inside_tabs/tabs/medicalTab/screen/medical_tab.dart';
import 'package:oasisathletic/ui/home_screen/Home/student_inside_tabs/tabs/profile_tab.dart';
import 'package:oasisathletic/ui/home_screen/Home/student_inside_tabs/tabs/schedule_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/model/regStdModels/stdData.dart';
import '../../../../../core/model/stdLinks/StdFullData.dart';
import '../../../../../core/model/stdLinks/StdLinks.dart';
import '../../../../../core/model/stdLinks/StdMainLinks.dart';
import '../../../../../core/model/stdLinks/StdSports.dart';
import '../../../../../core/reusable_components/Checkers/checkInternetConnection.dart';
import '../../../../../core/reusable_components/app_background.dart';
import '../../../../../core/reusable_components/gridViewAnimation/tabsBarSkeketon.dart';
import '../../../../../core/reusable_components/gridViewAnimation/tabsSkeletonGrid.dart';
import '../../../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../../../core/reusable_components/student_header.dart';
import '../../../../../core/services/stdProfile/stdLinksServices/stdLinksServices.dart';
import 'dart:async';
import 'dart:io';

import '../../../../../core/reusable_components/errorsDialogs/ErrorRetryDialog.dart';
import '../tabs/academicSupportTab/academicSupportDasboardTab.dart';
import '../tabs/athleticsTab/athletics_tab.dart';
import '../tabs/meals_tab.dart';
import '../widgets/studentInside_tabbar.dart';
import '../widgets/students_inside_tabs.dart'; // ErrorRetrySheet

class StudentInside extends StatefulWidget {
  const StudentInside({super.key});

  static const routeName = '/studentInside';

  @override
  State<StudentInside> createState() => _StudentInsideState();
}

class _StudentInsideState extends State<StudentInside>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late final ScrollController _tabsScrollController;

  bool loading = true;
  late stdData basicStudent;
  StdLinks? stdLinks;
  StdFullData? student;
  StdSports? studentSports;

  List<StdMainLinks> mainLinks = [];
  List<StdSports> sports = [];
  List<TabItem> dynamicTabs = [];

  int _selectedIndex = 0;

  List<TabItem> get _tabs => dynamicTabs;

  @override
  void initState() {
    super.initState();
    _tabsScrollController = ScrollController();

    /// 1) Load basic student from notifier (RegStd API)
    basicStudent = studentNotifier.value;

    /// 2) Don't manually create StdFullData! (غلط)
    ///    Just wait for API StdLinks
    student = null;

    /// 3) Listen for changes in global notifier
    studentNotifier.addListener(() {
      setState(() {
        basicStudent =
            studentNotifier.value; // updates name & photo immediately
      });
    });

    /// 4) Load full details from API
    final id = basicStudent.stdId;
    if (id != null) {
      loadStudentData(id.toString());
    } else {
      loading = false;
    }
  }

  Future<void> loadStudentData(String stdId) async {
    setState(() => loading = true);

    try {
      // ✅ fast-fail offline (علشان Try Again يشتغل صح)
      final ok = await NetworkGuard.hasInternet();
      if (!ok) throw const SocketException('No Internet');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? '';
      if (token.isEmpty) throw Exception("Missing token, please login again.");

      final res = await StudentLinksService.getStudentLinks(
        token: token,
        stdId: stdId,
      );

      if (!mounted) return;

      final fullList = res?.stdFullData ?? [];
      final mainList = res?.stdMainLinks ?? [];
      final sportsList = res?.stdSports ?? [];

      if (fullList.isEmpty) {
        setState(() {
          student = null;
          mainLinks = [];
          sports = [];
          dynamicTabs = [];
          loading = false;
        });
        return;
      }

      setState(() {
        student = fullList.first;
        updateFullStudent(student!);
        studentSports = sportsList.isNotEmpty ? sportsList.first : null;
        mainLinks = mainList;
        sports = sportsList;

        dynamicTabs =
            mainLinks.map((e) {
              final emoji = (e.linkIcon ?? "").trim();
              return TabItem(
                title: (e.linkName ?? "Untitled").trim(),
                icon: Text(
                  emoji.isNotEmpty ? emoji : "❓",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    height: 1.0,
                  ),
                  strutStyle: const StrutStyle(
                    height: 1.0,
                    forceStrutHeight: true,
                    leading: 0,
                  ),
                ),
              );
            }).toList();

        loading = false;
      });
    } on SocketException {
      if (!mounted) return;
      setState(() => loading = false);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ErrorRetrySheet.show(
          context,
          title: 'No Internet',
          message: 'Please check your connection and try again.',
          onTryAgain: () => loadStudentData(stdId),
          onCancel: () {},
        );
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);

      final msg = e.toString().replaceAll('Exception:', '').trim();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ErrorRetrySheet.show(
          context,
          title: 'Failed to load',
          message: msg.isEmpty ? 'Unexpected error occurred.' : msg,
          onTryAgain: () => loadStudentData(stdId),
          onCancel: () {},
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: AppBackground(
        useAppBarBlur: false,
        useSafeArea: false,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            children: [
              /// Header
              Padding(
                padding: EdgeInsets.only(
                  top: statusBarHeight + 12.h,
                  left: 8.w,
                  right: 8.w,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: StudentHeaderFromFull(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.h),

              /// Tabs bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SizedBox(
                  height: 112.h,
                  child: _buildTabsBar(),
                ),
              ),

              SizedBox(height: 8.h),

              /// Body
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: _buildBodyContent(),
                  ),
                ),
              ),

              /// Loading overlay
              if (loading)
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(999.r),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.06),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 14.r,
                          height: 14.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Loading student Data…',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   final double statusBarHeight = MediaQuery.of(context).padding.top;
  //   final double headerContentTopPad = 16.h;
  //   final double headerContentHeight = 90.h;
  //   final double tabOverlap = 46.h;
  //   final double tabBarHeight = 92.h;
  //
  //   final double headerTotal =
  //       statusBarHeight + headerContentTopPad + headerContentHeight;
  //
  //   final double reservedTop =
  //       headerTotal + (tabBarHeight - tabOverlap);
  //
  //   return Scaffold(
  //     body: AppBackground(
  //       useAppBarBlur: false,
  //       child: MediaQuery.removePadding(
  //         removeTop: true,
  //         context: context,
  //         child: Stack(
  //           children: [
  //             Positioned.fill(
  //               top: reservedTop,
  //               child: Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 12.w),
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(12.r),
  //                   child: _buildBodyContent(),
  //                 ),
  //               ),
  //             ),
  //
  //             Positioned(
  //               top: 0,
  //               left: 0,
  //               right: 0,
  //               child: _buildTopHeader(
  //                 context,
  //                 statusBarHeight,
  //                 headerTotal,
  //                 headerContentTopPad,
  //               ),
  //             ),
  //
  //             Positioned(
  //               top: headerTotal - tabOverlap,
  //               left: 12.w,
  //               right: 12.w,
  //               child: SizedBox(
  //                 height: tabBarHeight,
  //                 child: _buildTabsBar(),
  //               ),
  //             ),
  //
  //             if (loading)
  //               Positioned(
  //                 top: statusBarHeight + 12.h,
  //                 left: 0,
  //                 right: 0,
  //                 child: Center(
  //                   child: Container(
  //                     padding: EdgeInsets.symmetric(
  //                       horizontal: 14.w,
  //                       vertical: 8.h,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white.withOpacity(0.75),
  //                       borderRadius: BorderRadius.circular(999.r),
  //                       border: Border.all(
  //                         color: Colors.black.withOpacity(0.06),
  //                       ),
  //                     ),
  //                     child: Row(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         SizedBox(
  //                           width: 14.r,
  //                           height: 14.r,
  //                           child: const CircularProgressIndicator(
  //                             strokeWidth: 2,
  //                           ),
  //                         ),
  //                         SizedBox(width: 8.w),
  //                         Text(
  //                           'Loading student Data…',
  //                           style: TextStyle(fontSize: 12.sp),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTabsBar() {
    if (loading || dynamicTabs.isEmpty) {
      return const TabsBarSkeleton();
    }
    return GoldenTabBar(
      tabs: _tabs,
      selectedIndex: _selectedIndex,
      onTap:
          (i) => setState(() {
            _selectedIndex = i;
            _pageController.jumpToPage(i);
          }),
      controller: _tabsScrollController,
    );
  }

  Widget _buildBodyContent() {
    if (loading || student == null || mainLinks.isEmpty) {
      return const TabsSkeletonGrid(itemCount: 6);
    }

    final pages =
        mainLinks.map((e) {
          switch (e.linkName?.toLowerCase()) {
            case "profile":
              return ProfileTab(
                student: student!,
                stdSports: sports,
              );
            case "academic support":
              return AcademicSupportMainTab();
            case "academic":
              return stdSchoolAcademicTab();
            case "athletics":
              return AthleticsTab();
            case "meals":
              return MealsTab();
            case "medical":
              return MedicalTab();
            case "forms":
              return FormsTab();
            case "schedule":
              return ScheduleTab();
            default:
              return Center(child: Text("No page found for ${e.linkName}"));
          }
        }).toList();

    return StudentTabPages(
      pages: pages,
      controller: _pageController,
      onPageChanged: (i) => setState(() => _selectedIndex = i),
    );
  }

  Widget _buildTopHeader(
      context,
    double statusBar,
    double total,
    double extraTopPad,
  ) {
    return SizedBox(
      height: total,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: extraTopPad),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
              ),
              Expanded(child: StudentHeaderFromFull()),
            ],
          ),
        ),
      ),
    );
  }
}
