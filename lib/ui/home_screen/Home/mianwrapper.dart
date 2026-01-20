import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/apiControl/apiManager.dart';
import '../../../core/apiControl/apiServiceProvider.dart';
import '../../../core/model/regStdModels/RegStResponse.dart';
import '../../../core/model/regStdModels/SideMenu.dart';
import '../../../core/model/regStdModels/stdData.dart';
import '../../../core/reusable_components/Errors/ErrorRetryDialog.dart';
import '../../../core/reusable_components/Errors/apiGuard.dart';
import '../../../core/reusable_components/Errors/checkInternetConnection.dart';
import '../../../core/reusable_components/Errors/globalOfflineListener.dart';
import '../../../core/reusable_components/Errors/networkController.dart';
import '../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../core/services/regStudentsServices/getRegStd.dart';

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
    _netSub = NetworkController.I.onlineStream.listen((online) {
      if (!mounted) return;
      setState(() => _isOnline = online);
    });

    _bootstrap();
  }

  @override
  void dispose() {
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

  Future<void> _fetchRegStd({bool showErrorDialog = true}) async {
    if (_loading) return;
    setState(() => _loading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
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
      request:
          () => APIServices().apiRequest(APIManager.regStd, {
            "token": token,
            "deviceID": "1",
            "DeviceType": 1,
          }),
      onTryAgain: () => _fetchRegStd(showErrorDialog: true),
    );

    if (!mounted) return;

    // لو ApiGuard رجّع null (يعني dialog اتعرض/اتقفل) أو request فشل
    if (res == null || res["success"] != true || res["data"] == null) {
      setState(() => _loading = false);
      return;
    }

    // ✅ نفس منطق Getregstd.getRegStd القديم
    final RegStdResponse parsed = RegStdResponse.fromJson(res["data"]);

    final newStudents = parsed.data ?? <stdData>[];
    final newSideMenu = parsed.sideMenu ?? <SideMenu>[];

    // ✅ cache
    await _saveCache(students: newStudents, sideMenu: newSideMenu);

    // ✅ update UI
    setState(() {
      _students = newStudents;
      _sideMenuList = newSideMenu;
      _loading = false;
    });

    // ✅ update notifier
    studentsNotifier.value = newStudents;
  }

  @override
  Widget build(BuildContext context) {
    return GlobalOfflineListener(
      child: Scaffold(
        appBar: _buildStyledAppBar(context),
        drawer: HomeDrawer(
          sideMenuList: _sideMenuList,
          isLoading: _loading,
          isOnline: _isOnline,
        ),
        body: StudentsScreen(
          key: ValueKey(
            '${_students.length}-${_sideMenuList.length}-${_loading ? 1 : 0}',
          ),
          students: _students,
          isRefreshing: _loading,
          onRefresh: () => _fetchRegStd(showErrorDialog: true),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildStyledAppBar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white.withOpacity(0.65),
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
        IconButton(
          tooltip: 'Refresh',
          onPressed:
              _loading ? null : () => _fetchRegStd(showErrorDialog: true),
          icon: const Icon(Icons.refresh),
        ),
      ],
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.96),
                  Colors.white.withOpacity(0.92),
                  Colors.white.withOpacity(0.88),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.04),
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
