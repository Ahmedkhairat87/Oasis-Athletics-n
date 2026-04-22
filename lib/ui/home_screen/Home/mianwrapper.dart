import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oasisathletic/ui/home_screen/Home/widget/notificationAppBarButton.dart';
import 'package:oasisathletic/ui/home_screen/Home/widget/notificationCenterController.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/apiControl/apiManager.dart';
import '../../../core/apiControl/apiServiceProvider.dart';
import '../../../core/colors_Manager.dart';
import '../../../core/model/regStdModels/RegStResponse.dart';
import '../../../core/model/regStdModels/SideMenu.dart';
import '../../../core/model/regStdModels/stdData.dart';
import '../../../core/reusable_components/Checkers/apiGuard.dart';
import '../../../core/reusable_components/Checkers/checkInternetConnection.dart';
import '../../../core/reusable_components/Checkers/globalOfflineListener.dart';
import '../../../core/reusable_components/Checkers/networkController.dart';
import '../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../core/reusable_components/app_background.dart';
import '../../../core/services/AppUpdate/appUpdateChecker.dart';
import '../../../core/services/loginServices/AuthLogoutService.dart';

import '../../login_screen/login.dart';
import '../../webView-attachmentopener/agreementWebView.dart';
import 'notificationCenter.dart';
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
  bool _fetchInFlight = false;
  DateTime? _lastFetchAt;

  bool _bootstrapping = false;
  bool _didInitialFetch = false;
  bool _hasLoadedOnce = false;
  int _regStdFailCount = 0;
  static const int _maxRegStdFailures = 2;

  StreamSubscription<bool>? _netSub;
  bool _isOnline = true;
  bool _wasOnline = true;
  Timer? _autoRefetchDebounce;
  int _unreadCount = 0;
  List<stdData> _students = [];
  List<SideMenu> _sideMenuList = [];

  @override
  void initState() {
    super.initState();

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
        // ✅ skip auto-refresh during first bootstrap to avoid duplicate calls
        if (_bootstrapping || !_didInitialFetch) return;
        // prevent quick duplicate triggers (resume / wifi rebind)
        _autoRefetchDebounce?.cancel();
        _autoRefetchDebounce = Timer(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          if (_loading) return; // don't spam
          if (!_hasLoadedOnce) return; // only refresh after a successful load
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

    _bootstrapping = true;
    await _loadCachedData();

    final shouldShow = _students.isEmpty && _sideMenuList.isEmpty;
    await _fetchRegStd(showErrorDialog: shouldShow);
    _didInitialFetch = true;
    _bootstrapping = false;
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
    bool isRetry = false,
  }) async {
    // ✅ hard guard against duplicate calls
    if (_fetchInFlight) return;
    // ✅ if already loading, allow only when forced (auto-reconnect)
    if (_loading && !force) return;
    // ✅ tiny throttle to avoid double fire on init/resume
    final last = _lastFetchAt;
    if (last != null && DateTime.now().difference(last) < const Duration(milliseconds: 500)) {
      return;
    }
    _lastFetchAt = DateTime.now();
    _fetchInFlight = true;

    // ✅ when called from reconnect, don't trust isOnline snapshot instantly
    final online = await NetworkGuard.hasInternet();
    if (!online) {
      if (mounted) setState(() => _loading = false);
      _fetchInFlight = false;
      return;
    }

    if (mounted) setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        if (!mounted) return;
        setState(() => _loading = false);

        await _forceRelogin();
        _fetchInFlight = false;
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
        onTryAgain: () => _fetchRegStd(showErrorDialog: true, isRetry: true),
      );

      if (!mounted) return;

      if (res == null || res["success"] != true || res["data"] == null) {
        setState(() => _loading = false);
        if (showErrorDialog) {
          _regStdFailCount += isRetry ? 1 : 0;
          if (_regStdFailCount >= _maxRegStdFailures) {
            await _forceRelogin();
          }
        }
        _fetchInFlight = false;
        return;
      }

      final RegStdResponse parsed = RegStdResponse.fromJson(res["data"]);
      _unreadCount = parsed.unReadedCount ?? 0;
// ✅ 1) account blocked → force relogin immediately
      final blocked = await _forceLogoutIfBlocked(parsed);
      if (blocked) {
        if (mounted) setState(() => _loading = false);
        return;
      }




// ✅ 2) agreement redirect (uses outer "res" because flag/url are outside parsed.data)
      // after you validated res success and res["data"] exists


// Continue normal flow
      final newStudents = parsed.data ?? <stdData>[];
      final newSideMenu = parsed.sideMenu ?? <SideMenu>[];

      await _saveCache(students: newStudents, sideMenu: newSideMenu);
      if (!mounted) return;

      setState(() {
        _students = newStudents;
        _sideMenuList = newSideMenu;
        _loading = false;
        _unreadCount = parsed.unReadedCount ?? 0;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        AppUpdateChecker.checkAndShow(
          context: context,
          androidVersion: parsed.androidVersion,
          iosVersion: parsed.iosVersion,
          urgentUpdateAndroid: parsed.urgentUpdateAndroid,
          urgentUpdateIOS: parsed.urgentUpdateIOS,
        );
      });

      studentsNotifier.value = newStudents;
      _regStdFailCount = 0;
      _hasLoadedOnce = true;

      final dataMap = (res["data"] is Map<String, dynamic>)
          ? Map<String, dynamic>.from(res["data"])
          : <String, dynamic>{};

      await _openAgreementIfNeeded(dataMap);

    } catch (e, st) {
      debugPrint("❌ _fetchRegStd error: $e");
      debugPrint(st.toString());
      if (mounted) setState(() => _loading = false);
    } finally {
      _fetchInFlight = false;
    }
  }

  bool _agreementOpen = false;
  Future<void> _openAgreementIfNeeded(Map<String, dynamic> apiMap) async {
    final flag = (apiMap["requiredFlag"] ?? "0").toString();
    final url = (apiMap["requiredURL"] ?? "").toString().trim();

    if (flag != "1" || url.isEmpty) return;
    if (_agreementOpen) return;

    _agreementOpen = true;

    if (!mounted) {
      _agreementOpen = false;
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (!mounted) return;

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AgreementGateWebView(
              url: url,
              title: "Agreement",
              fetchRegStd: _regStdRawMap, // (I’ll show below)
            ),
          ),
        );
      } finally {
        _agreementOpen = false;
      }
    });
  }
  /*Future<void> _openAgreementIfNeeded(Map<String, dynamic> apiMap) async {
    final flag = (apiMap["requiredFlag"] ?? "0").toString();
    final url = (apiMap["requiredURL"] ?? "").toString().trim();

    if (flag != "1" || url.isEmpty) return;
    if (_agreementOpen) return;

    _agreementOpen = true;

    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AgreementGateWebView(
            url: url,
            title: "Agreement",
            fetchRegStd: () async {
              // Call your same regStd request here and return the map
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('token') ?? '';
              if (token.isEmpty) return null;

              final res = await APIServices().apiRequest(APIManager.regStd, {
                "token": token,
                "deviceID": "1",
                "DeviceType": 1,
              });

              // IMPORTANT: return the object that actually contains requiredFlag/requiredURL
              // If requiredFlag is inside res["data"], return res["data"].
              if (res is Map && res["data"] is Map<String, dynamic>) {
                return Map<String, dynamic>.from(res["data"]);
              }
              if (res is Map<String, dynamic>) return res;

              return null;
            },
          ),
        ),
      );

      _agreementOpen = false;
    });
  }*/
  // Future<void> _openAgreementIfNeeded(Map<String, dynamic> apiRes) async {
  //   if (_redirectingAgreement) return;
  //
  //   final flag = (apiRes["requiredFlag"] ?? "1").toString();
  //   final url = (apiRes["requiredURL"] ?? "https://www.google.com").toString().trim();
  //
  //   if (flag != "1" || url.isEmpty) return;
  //
  //   _redirectingAgreement = true;
  //
  //
  //   if (!mounted) return;
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (_) => WebViewScreen(
  //           url: url,
  //           title: "Agreement",
  //         ),
  //       ),
  //     );
  //
  //     // allow future navigation if a NEW url comes later
  //     _redirectingAgreement = false;
  //   });
  // }

  Future<Map<String, dynamic>?> _regStdRawMap() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) return null;

    final res = await APIServices().apiRequest(APIManager.regStd, {
      "token": token,
      "deviceID": "1",
      "DeviceType": 1,
    });

    if (res is Map && res["data"] is Map<String, dynamic>) {
      return Map<String, dynamic>.from(res["data"]);
    }
    if (res is Map<String, dynamic>) return res;
    return null;
  }

  Future<bool> _forceLogoutIfBlocked(RegStdResponse parsed) async {
    final first = (parsed.data != null && parsed.data!.isNotEmpty) ? parsed.data!.first : null;
    if (first == null) return false;

    // adapt to your model field names
    final appAccountStatus = first.appAccountStatus ?? 1;
    final accountStatus = first.accountStatus ?? 1;

    if (appAccountStatus == 0 || accountStatus == 0) {
      await _forceRelogin();
      return true;
    }
    return false;
  }

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
    final unread = context.watch<NotificationCenterController>().unreadCount;
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
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 6),
          child: NotificationAppBarButton(
            unreadCount: _unreadCount, // from regStd
            onPressed: () async {
              await Navigator.of(context).pushNamed(NotificationCenterScreen.routeName);
              _fetchRegStd(showErrorDialog: false, force: true); // refresh count after return
            },
            color: ColorsManager.primaryGradientStart, // ✅ same family as refresh
          ),
        ),

        // _appBarAction(
        //   context,
        //   tooltip: "Sign out",
        //   onPressed: () => _handleLogout(context),
        //   icon: Icons.logout_rounded,
        //   color: Theme.of(context).colorScheme.error,
        // ),
        // SizedBox(width: 2),
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



  Future<void> _forceRelogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('empName');
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginScreen.routeName,
      (route) => false,
    );
  }

}
