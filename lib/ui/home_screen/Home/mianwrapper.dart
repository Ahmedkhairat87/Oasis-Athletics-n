import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/apiControl/apiManager.dart';
import '../../../core/apiControl/apiServiceProvider.dart';
import '../../../core/colors_Manager.dart';
import '../../../core/model/regStdModels/RegStResponse.dart';
import '../../../core/model/regStdModels/SideMenu.dart';
import '../../../core/model/regStdModels/stdData.dart';
import '../../../core/reusable_components/Errors/ErrorRetryDialog.dart';
import '../../../core/reusable_components/Errors/apiGuard.dart';
import '../../../core/reusable_components/Errors/checkInternetConnection.dart';
import '../../../core/reusable_components/Errors/globalOfflineListener.dart';
import '../../../core/reusable_components/Errors/networkController.dart';
import '../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../core/reusable_components/app_background.dart';
import '../../../core/services/loginServices/AuthLogoutService.dart';
import '../../../core/services/regStudentsServices/getRegStd.dart';

import '../../login_screen/login.dart';
import 'students_screen.dart';
import 'widget/home_drawer.dart';

class MainWrapper extends StatefulWidget {
  static const routeName = '/dashboard';
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => MainWrapperState();
}

class MainWrapperState extends State<MainWrapper> {
  bool _loading = false;
  StreamSubscription<bool>? _netSub;
  bool _isOnline = true;
  bool _wasOnline = true;
  Timer? _autoRefetchDebounce;

  List<stdData> _students = [];
  List<SideMenu> _sideMenuList = [];

  @override
  void initState() {
    super.initState();

    // مهم: تأكد إن controller شغال
    NetworkController.I.start();

    // خزن الحالة الحالية
    _isOnline = NetworkController.I.isOnline;

    // اسمع التغييرات واعمل rebuild
    _wasOnline = NetworkController.I.isOnline;

    _netSub = NetworkController.I.onlineStream.listen((online) {
      if (!mounted) return;

      setState(() => _isOnline = online);

      // ✅ detect offline -> online
      final cameBackOnline = !_wasOnline && online;
      _wasOnline = online;

      if (cameBackOnline) {
        // prevent quick duplicate triggers (resume / wifi rebind)
        _autoRefetchDebounce?.cancel();
        _autoRefetchDebounce = Timer(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          if (_loading) return; // don't spam
          _fetchRegStd(showErrorDialog: false, force: true); // ✅ silent auto refresh
        });
      }
    });

    _bootstrap();
  }

  @override
  void dispose() {
    _autoRefetchDebounce?.cancel();
    _netSub?.cancel();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    await _loadCachedData();

    final shouldShow = _students.isEmpty && _sideMenuList.isEmpty;
    await _fetchRegStd(showErrorDialog: shouldShow);
  }

  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();

    final studentsStr = prefs.getString('students');
    final sideMenuStr = prefs.getString('sideMenu');

    final cachedStudents = <stdData>[];
    final cachedSideMenu = <SideMenu>[];

    try {
      if (studentsStr != null && studentsStr.isNotEmpty) {
        final decoded = jsonDecode(studentsStr);
        if (decoded is List) {
          for (final item in decoded) {
            if (item is Map<String, dynamic>) {
              cachedStudents.add(stdData.fromJson(item));
            }
          }
        }
      }
    } catch (_) {}

    try {
      if (sideMenuStr != null && sideMenuStr.isNotEmpty) {
        final decoded = jsonDecode(sideMenuStr);
        if (decoded is List) {
          for (final item in decoded) {
            if (item is Map<String, dynamic>) {
              cachedSideMenu.add(SideMenu.fromJson(item));
            }
          }
        }
      }
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      _students = cachedStudents;
      _sideMenuList = cachedSideMenu;
    });

    if (studentsNotifier.value.isEmpty && _students.isNotEmpty) {
      studentsNotifier.value = _students;
    }
  }

  Future<void> _saveCache({
    required List<stdData> students,
    required List<SideMenu> sideMenu,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'students',
      jsonEncode(students.map((e) => e.toJson()).toList()),
    );

    await prefs.setString(
      'sideMenu',
      jsonEncode(sideMenu.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> _fetchRegStd({
    bool showErrorDialog = true,
    bool force = false,
  }) async {
    // ✅ if already loading, allow only when forced (auto-reconnect)
    if (_loading && !force) return;

    // ✅ when called from reconnect, don't trust isOnline snapshot instantly
    final online = await NetworkGuard.hasInternet();
    if (!online) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    if (mounted) setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        if (!mounted) return;
        setState(() => _loading = false);

        if (showErrorDialog) {
          await ErrorRetrySheet.show(
            context,
            title: 'Missing token',
            message: 'Please login again.',
            onTryAgain: () => _fetchRegStd(showErrorDialog: true),
            onCancel: () {},
          );
        }
        return;
      }

      final res = await ApiGuard.run(
        title: 'Failed to load',
        showDialog: showErrorDialog,
        request: () => APIServices().apiRequest(APIManager.regStd, {
          "token": token,
          "deviceID": "1",
          "DeviceType": 1,
        }),
        onTryAgain: () => _fetchRegStd(showErrorDialog: true),
      );

      if (!mounted) return;

      if (res == null || res["success"] != true || res["data"] == null) {
        setState(() => _loading = false);
        return;
      }

      final RegStdResponse parsed = RegStdResponse.fromJson(res["data"]);
      final newStudents = parsed.data ?? <stdData>[];
      final newSideMenu = parsed.sideMenu ?? <SideMenu>[];

      await _saveCache(students: newStudents, sideMenu: newSideMenu);

      setState(() {
        _students = newStudents;
        _sideMenuList = newSideMenu;
        _loading = false;
      });

      studentsNotifier.value = newStudents;
    } catch (e, st) {
      debugPrint("❌ _fetchRegStd error: $e");
      debugPrint(st.toString());
      if (mounted) setState(() => _loading = false);
    }
  }


  // @override
  // Widget build(BuildContext context) {
  //   return GlobalOfflineListener(
  //     child: Scaffold(
  //       extendBody: true,               // ✅ ADD
  //       extendBodyBehindAppBar: true,   // ✅ ADD
  //       appBar: _buildStyledAppBar(context),
  //       drawer: HomeDrawer(
  //         sideMenuList: _sideMenuList,
  //         isLoading: _loading,
  //         isOnline: _isOnline,
  //       ),
  //       body: AppBackground(            // ✅ WRAP HERE (IMPORTANT)
  //         useAppBarBlur: true,          // ✅ because you have AppBar
  //         child: StudentsScreen(
  //           key: ValueKey(
  //             '${_students.length}-${_sideMenuList.length}-${_loading ? 1 : 0}',
  //           ),
  //           students: _students,
  //           isRefreshing: _loading,
  //           onRefresh: () => _fetchRegStd(showErrorDialog: true),
  //         ),
  //       ),
  //     ),
  //   );
  //   // return GlobalOfflineListener(
  //   //   child: Scaffold(
  //   //     appBar: _buildStyledAppBar(context),
  //   //     drawer: HomeDrawer(
  //   //       sideMenuList: _sideMenuList,
  //   //       isLoading: _loading,
  //   //       isOnline: _isOnline,
  //   //     ),
  //   //     body: StudentsScreen(
  //   //       key: ValueKey(
  //   //         '${_students.length}-${_sideMenuList.length}-${_loading ? 1 : 0}',
  //   //       ),
  //   //       students: _students,
  //   //       isRefreshing: _loading,
  //   //       onRefresh: () => _fetchRegStd(showErrorDialog: true),
  //   //     ),
  //   //   ),
  //   // );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return GlobalOfflineListener(
  //     child: Scaffold(
  //       backgroundColor: Colors.transparent, // ✅ important
  //       extendBody: true,
  //       extendBodyBehindAppBar: true,
  //       appBar: _buildStyledAppBar(context),
  //       drawer: HomeDrawer(
  //         sideMenuList: _sideMenuList,
  //         isLoading: _loading,
  //         isOnline: _isOnline,
  //       ),
  //       body: AppBackground(
  //         useAppBarBlur: false, // ✅
  //         child: SafeArea(
  //           child: StudentsScreen(
  //             key: ValueKey(
  //               '${_students.length}-${_sideMenuList.length}-${_loading ? 1 : 0}',
  //             ),
  //             students: _students,
  //             isRefreshing: _loading,
  //             onRefresh: () => _fetchRegStd(showErrorDialog: true),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return GlobalOfflineListener(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        extendBodyBehindAppBar: true,

        appBar: _buildStyledAppBar(context),
        drawer: HomeDrawer(
          sideMenuList: _sideMenuList,
          isLoading: _loading,
          isOnline: _isOnline,
        ),

        body: AppBackground(
          // background must cover full screen (behind appbar + system bars)
          useAppBarBlur: false,
          useSafeArea: true,
          safeAreaTop: false,
          safeAreaBottom: true,
          child: Padding(
            padding: EdgeInsets.only(top: topPad + kToolbarHeight),
            child: StudentsScreen(
              key: ValueKey(
                '${_students.length}-${_sideMenuList.length}-${_loading ? 1 : 0}',
              ),
              students: _students,
              isRefreshing: _loading,
              onRefresh: () => _fetchRegStd(showErrorDialog: true),
            ),
          ),
        ),
      ),
    );
  }


  PreferredSizeWidget _buildStyledAppBar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        'Dashboard',
        style: TextStyle(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),

      actions: [
        _appBarAction(
          context,
          tooltip: "Refresh",
          onPressed: _loading ? null : () => _fetchRegStd(showErrorDialog: true),
          icon: Icons.refresh_rounded,
          color: ColorsManager.primaryGradientStart,
        ),
        _appBarAction(
          context,
          tooltip: "Sign out",
          onPressed: () => _handleLogout(context),
          icon: Icons.logout_rounded,
          color: Theme.of(context).colorScheme.error,
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _appBarAction(
      BuildContext context, {
        required String tooltip,
        required VoidCallback? onPressed,
        required IconData icon,
        required Color color,
      }) {
    final isDisabled = onPressed == null;

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onPressed,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isDisabled ? 0.45 : 1,
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: color.withOpacity(0.20),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 20,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _handleLogout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success = await ParentLogoutService.logout();
    Navigator.pop(context);

    if (success) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreen.routeName,
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logout failed")),
      );
    }
  }

}
