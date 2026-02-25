import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/home_screen/Home/notificationCenter.dart';
import 'package:oasisathletic/ui/home_screen/Home/widget/notificationCenterController.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_style.dart';
import 'core/reusable_components/Notifiers/theme_mode_provider.dart';
import 'core/reusable_components/Checkers/globalOfflineListener.dart';
import 'core/reusable_components/Checkers/globalNavigatorKey.dart';
import 'core/reusable_components/Checkers/networkController.dart';

import 'core/services/FCM-Token-Service.dart';
import 'core/services/pushNotifications_router.dart';

import 'ui/login_screen/login.dart';
import 'ui/home_screen/Home/mianwrapper.dart';
import 'ui/drawer/settings.dart';
import 'ui/drawer/bus_registeration.dart';
import 'ui/drawer/canteen_charge.dart';
import 'ui/drawer/payment_Information.dart';
import 'ui/home_screen/sideMenu/Gallery/galleryAlbums.dart';
import 'ui/home_screen/sideMenu/Gallery/widget/cart_screen.dart';
import 'ui/home_screen/sideMenu/newsLetter/NewsLetterScreen.dart';
import 'ui/home_screen/MSGScreens/sendMessagesScreen.dart';
import 'ui/home_screen/MSGScreens/messages.dart';
import 'ui/home_screen/Home/student_inside_tabs/student_inside.dart';
import 'ui/home_screen/sideMenu/Gallery/widget/provider/cart_provider.dart';
import 'ui/home_screen/sideMenu/parentProfile/parentProfile/parent_profile_screen.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
String? currentRouteName;

class AppLockWatcher extends StatefulWidget {
  final Widget child;
  const AppLockWatcher({super.key, required this.child});

  @override
  State<AppLockWatcher> createState() => _AppLockWatcherState();
}

class _AppLockWatcherState extends State<AppLockWatcher> with WidgetsBindingObserver {
  DateTime? _pausedAt;
  static const Duration _lockAfter = Duration(seconds: 2);

  bool _navigating = false;

  bool _isOnLogin() => currentRouteName == LoginScreen.routeName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // ✅ lock immediately on app start if token exists + app lock enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lockIfNeeded(ignoreElapsed: true);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
/*
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // ✅ only consider real backgrounding
    if (state == AppLifecycleState.paused) {
      _pausedAt = DateTime.now();
      return;
    }

    // ❌ ignore inactive (FaceID sheet, control center, calls, etc.)
    if (state == AppLifecycleState.inactive) return;

    if (state != AppLifecycleState.resumed) return;

    final pausedAt = _pausedAt;
    if (pausedAt == null) return;

    final elapsed = DateTime.now().difference(pausedAt);
    if (elapsed < _lockAfter) return;

    // ✅ if already on login, don't redirect
    if (_isOnLogin()) return;

    // ✅ avoid multiple redirects
    if (_navigating) return;

    final prefs = await SharedPreferences.getInstance();

// ✅ ignore lifecycle spam while FaceID sheet is open
    final authInProgress = prefs.getBool('auth_in_progress') ?? false;
    if (authInProgress) return;

// ✅ cooldown after unlock/navigation (prevents login ↔ mainwrapper loop)
    final suppressUntilMs = prefs.getInt('suppress_lock_until') ?? 0;
    if (DateTime.now().millisecondsSinceEpoch < suppressUntilMs) return;

// ✅ keys must be PUBLIC in LoginScreen (kToken / kBioEnabled)
    final token = prefs.getString(LoginScreen.kToken) ?? "";
    final bioEnabled = prefs.getBool(LoginScreen.kBioEnabled) ?? false;

// ✅ only lock when session exists AND biometrics enabled
    if (token.isEmpty || !bioEnabled) return;



    // ✅ only lock when session exists AND biometrics enabled
    if (token.isEmpty || !bioEnabled) return;

    _navigating = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      rootNavKey.currentState?.pushNamedAndRemoveUntil(
        LoginScreen.routeName,
            (_) => false,
      );

      Future.delayed(const Duration(milliseconds: 700), () {
        _navigating = false;
      });
    });
  }
*/

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      _pausedAt = DateTime.now();
      return;
    }

    if (state == AppLifecycleState.inactive) return;
    if (state != AppLifecycleState.resumed) return;

    await _lockIfNeeded(ignoreElapsed: false);
  }

  Future<void> _lockIfNeeded({bool ignoreElapsed = false}) async {
    if (_isOnLogin()) return;
    if (_navigating) return;

    final prefs = await SharedPreferences.getInstance();

    // ignore lifecycle spam while auth sheet is open
    final authInProgress = prefs.getBool('auth_in_progress') ?? false;
    if (authInProgress) return;

    // cooldown after successful unlock
    final suppressUntilMs = prefs.getInt('suppress_lock_until') ?? 0;
    if (DateTime.now().millisecondsSinceEpoch < suppressUntilMs) return;

    final token = prefs.getString(LoginScreen.kToken) ?? "";
    final bioEnabled = prefs.getBool(LoginScreen.kBioEnabled) ?? false;

    if (token.isEmpty || !bioEnabled) return;

    if (!ignoreElapsed) {
      final pausedAt = _pausedAt;
      if (pausedAt == null) return;

      final elapsed = DateTime.now().difference(pausedAt);
      if (elapsed < _lockAfter) return;
    }

    _navigating = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rootNavKey.currentState?.pushNamedAndRemoveUntil(
        LoginScreen.routeName,
            (_) => false,
      );

      Future.delayed(const Duration(milliseconds: 700), () {
        _navigating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

Future<String> _resolveStartRoute() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString(LoginScreen.kToken) ?? '';

  // ✅ If session exists, go to dashboard directly (FaceID gate handled inside LoginScreen only if enabled)
  if (token.isNotEmpty) return MainWrapper.routeName;

  return LoginScreen.routeName;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
  ));

  try {
    await Firebase.initializeApp();
    await FcmService().init();
    await PushRouter.init();
  } catch (e, st) {
    debugPrint("🔴 Startup error: $e");
    debugPrint(st.toString());
  }

  NetworkController.I.start();

  final startRoute = await _resolveStartRoute();

  runApp(
    AppLockWatcher(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => ThemeModeProvider()),
          ChangeNotifierProvider(
            create: (_) => NotificationCenterController(),
          ),
        ],
        child: EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('fr')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: MyApp(initialRoute: startRoute),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  static bool _pushProcessedOnce = false;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) {
        if (!_pushProcessedOnce) {
          _pushProcessedOnce = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            PushRouter.processPendingIfAny();
          });
        }

        return GlobalOfflineListener(
          child: MaterialApp(
            navigatorKey: rootNavKey,
            navigatorObservers: [routeObserver, _RouteNameObserver()],
            title: 'Oasis Athletics',
            debugShowCheckedModeBanner: false,
            themeMode: context.watch<ThemeModeProvider>().themeMode,
            theme: AppStyle.lightMode,
            darkTheme: AppStyle.darkMode,
            initialRoute: initialRoute,
            routes: {
              MainWrapper.routeName: (_) => const MainWrapper(),
              LoginScreen.routeName: (_) => const LoginScreen(),
              Settings.routeName: (_) => Settings(),
              BusRegisteration.routeName: (_) => BusRegisteration(),
              GalleryAlbums.routeName: (_) => GalleryAlbums(),
              CanteenCharge.routeName: (_) => CanteenCharge(),
              PaymentInformation.routeName: (_) => PaymentInformation(),
              NewsLetterScreen.routeName: (_) => NewsLetterScreen(),
              sendMessagesScreen.routeName: (_) => const sendMessagesScreen(),
              Messages.routeName: (_) => Messages(),
              StudentInside.routeName: (_) => StudentInside(),
              CartScreen.routeName: (_) => const CartScreen(),
              ParentProfileScreen.routeName: (_) => ParentProfileScreen(),
              NotificationCenterScreen.routeName: (_) => NotificationCenterScreen(),
            },
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          ),
        );
      },
    );
  }
}

class _RouteNameObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    currentRouteName = route.settings.name;
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    currentRouteName = newRoute?.settings.name;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    currentRouteName = previousRoute?.settings.name;
  }
}