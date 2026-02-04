import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/home_screen/sideMenu/parentProfile/parentProfile/parent_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_style.dart';
import 'core/reusable_components/Notifiers/theme_mode_provider.dart';

import 'core/reusable_components/Errors/globalOfflineListener.dart';
import 'core/reusable_components/Errors/globalNavigatorKey.dart';
import 'core/reusable_components/Errors/networkController.dart';

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
import 'core/reusable_components/Errors/networkController.dart';
import 'core/reusable_components/Errors/globalOfflineListener.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);


  try {
    print("🟡 Before Firebase.initializeApp");

    // If you DO have firebase_options.dart, use this instead:
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await Firebase.initializeApp();

    print("🟢 Firebase.initializeApp DONE");

    print("🟡 Before FcmService.init");
    await FcmService().init();
    print("🟢 FcmService.init DONE");
    await PushRouter.init();
  } catch (e, st) {
    print("🔴 Startup error: $e");
    print(st);
  }

  // ✅ start once
  NetworkController.I.start();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';
  final startRoute =
      token.isEmpty ? LoginScreen.routeName : MainWrapper.routeName;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeModeProvider()),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: MyApp(initialRoute: startRoute),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) {

        // ✅ Run once after first frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          PushRouter.processPendingIfAny();
        });

        return GlobalOfflineListener(
          child: MaterialApp(
            navigatorKey: rootNavKey, // ✅ مهم جداً
            title: 'Oasis Athletics',
            debugShowCheckedModeBanner: false,
            themeMode: context.watch<ThemeModeProvider>().themeMode,
            theme: AppStyle.lightMode,
            darkTheme: AppStyle.darkMode,
            initialRoute: initialRoute,
            routes: {
              MainWrapper.routeName: (_) => const MainWrapper(),
              LoginScreen.routeName: (_) => LoginScreen(),
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
