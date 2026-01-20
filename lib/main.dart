import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_style.dart';
import 'core/reusable_components/Notifiers/theme_mode_provider.dart';

import 'core/reusable_components/Errors/globalOfflineListener.dart';
import 'core/reusable_components/Errors/globalNavigatorKey.dart';
import 'core/reusable_components/Errors/networkController.dart';

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
import 'ui/home_screen/widgets/student_inside.dart';
import 'ui/home_screen/sideMenu/parentProfile/parentProfile.dart';
import 'ui/home_screen/sideMenu/Gallery/widget/provider/cart_provider.dart';
import 'core/reusable_components/Errors/networkController.dart';
import 'core/reusable_components/Errors/globalOfflineListener.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

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
        return GlobalOfflineListener(
          child: MaterialApp(
            navigatorKey: rootNavKey, // ✅ مهم جداً
            title: 'Oasis Parents',
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
              Parentprofile.routeName: (_) => Parentprofile(),
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

/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  final String startRoute =
  token.isEmpty ? LoginScreen.routeName : MainWrapper.routeName;

  // ✅ start global network listener
  await NetworkController.I.start();

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    final String startRoute =
    token.isEmpty ? LoginScreen.routeName : MainWrapper.routeName;

    // ✅ START GLOBAL NETWORK LISTENER (مرة واحدة)
    await NetworkController.I.start();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
          ChangeNotifierProvider<ThemeModeProvider>(create: (_) => ThemeModeProvider()),
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


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<ThemeModeProvider>(create: (_) => ThemeModeProvider()),
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

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MaterialApp(
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
            Parentprofile.routeName: (_) => Parentprofile(),
          },

          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          // ✅ أهم سطر: يخلي الـ dialog يظهر فوق أي شاشة
          builder: (context, child) {
            return GlobalOfflineListener(
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
*/
/*
        return GlobalOfflineListener(
          child: MaterialApp(
            title: 'Oasis Athletics',
            debugShowCheckedModeBanner: false,

            // ✅ VERY IMPORTANT: use SAME global key
            navigatorKey: rootNavKey,

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
              Parentprofile.routeName: (_) => Parentprofile(),
            },

            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          ),
        );
*/ /*

      },
    );
  }
}*/
