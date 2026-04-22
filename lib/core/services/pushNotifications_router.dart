import 'package:firebase_messaging/firebase_messaging.dart';
import '../../ui/drawer/canteen_charge.dart';
import '../../ui/home_screen/Home/mianwrapper.dart';
import '../../ui/home_screen/sideMenu/Gallery/galleryAlbums.dart';
import '../../ui/home_screen/sideMenu/newsLetter/NewsLetterScreen.dart';
import '../reusable_components/Checkers/globalNavigatorKey.dart';
import '../../ui/home_screen/MSGScreens/messages.dart';
import '../../ui/home_screen/Home/student_inside_tabs/screen/student_inside.dart';

class PushRouter {
  static Map<String, dynamic>? _pendingData;
  static bool _processingPending = false;
  static DateTime? _lastOpenAt;
  static const Duration _openDebounce = Duration(milliseconds: 700);

  static Future<void> init() async {
    // Foreground (app open): you can show local notification later
    FirebaseMessaging.onMessage.listen((msg) {
      print('📩 Foreground push data: ${msg.data}');
      // no navigation here by default
    });

    // Background: user tapped
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      print('👉 onMessageOpenedApp data: ${msg.data}');
      _routeFromMessage(msg);
    });

    // Killed: app launched by tap
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      print('🚀 getInitialMessage data: ${initial.data}');
      _routeFromMessage(initial);
    }
  }

  static void processPendingIfAny() {
    if (_processingPending) return;
    if (_pendingData == null) return;

    _processingPending = true;
    final targetRoute = _pendingData!['_targetRoute']?.toString();
    final arguments = _pendingData!['_arguments'];

    _pendingData = null;

    if (targetRoute == null || targetRoute.isEmpty) {
      _processingPending = false;
      return;
    }
    if (arguments is! Map<String, dynamic>) {
      _processingPending = false;
      return;
    }

    _openOnTopOfMainWrapper(targetRoute: targetRoute, arguments: arguments);
    _processingPending = false;
  }


  static void _routeFromMessage(RemoteMessage msg) {
    final raw = _extractArgsString(msg);
    if (raw == null || raw.trim().isEmpty) return;

    final parts = raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.length < 2) return;

    final action = parts[1];
    final route = _actionToRoute[action];

    if (route == null) {
      print('⚠️ Unknown action: $action raw=$raw');
      return;
    }

    final args = _buildArgs(action: action, raw: raw, parts: parts);

    // ✅ single path (handles queueing too)
    _openOnTopOfMainWrapper(targetRoute: route, arguments: args);
  }


  static String? _extractArgsString(RemoteMessage msg) {
    final d = msg.data;

    final v = d['TitleLocArgs'] ??
        d['titleLocArgs'] ??
        d['title_loc_args'] ??
        d['args'] ??
        d['payload'];

    return v?.toString();
  }


  static const Map<String, String> _actionToRoute = {
    'goToMsg': Messages.routeName,
    'goToStdBook': StudentInside.routeName,
    'goToNews' : NewsLetterScreen.routeName,
    'goToGallery' :  GalleryAlbums.routeName,
    'goToCanteenPayment':CanteenCharge.routeName

  };




  //Navigation helper
  static void _openOnTopOfMainWrapper({
    required String targetRoute,
    required Map<String, dynamic> arguments,
  }) {
    final nav = rootNavKey.currentState;
    if (nav == null) {
      _pendingData = {'_targetRoute': targetRoute, '_arguments': arguments};
      return;
    }

    final now = DateTime.now();
    final last = _lastOpenAt;
    if (last != null && now.difference(last) < _openDebounce) {
      return;
    }
    _lastOpenAt = now;

    // Ensure Home base exists then push target
    nav.pushNamedAndRemoveUntil(MainWrapper.routeName, (route) => false);
    nav.pushNamed(targetRoute, arguments: arguments);
  }



  static Map<String, dynamic> _buildArgs({
    required String action,
    required String raw,
    required List<String> parts,
  }) {
    final base = {'rawArgs': raw, 'parts': parts, 'action': action};

    switch (action) {
      case 'goToStdBook':
        return {
          ...base,
          'studentId': parts.length > 2 ? parts[2] : null,
          'name': parts.length > 3 ? parts[3] : null,
          'photoUrl': parts.length > 4 ? parts[4] : null,
          'email': parts.length > 5 ? parts[5] : null,
          'password': parts.length > 6 ? parts[6] : null,
          'gradeOrLevel': parts.length > 7 ? parts[7] : null,
        };

      case 'goToMsg':
      default:
      // goToMsg,0 -> keep value in case you need it later
        return {...base, 'value': parts.length > 2 ? parts[2] : null};
    }
  }


  static void _routeFromRaw(String raw) {
    final parts = raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.length < 2) return;

    final action = parts[1];
    final route = _actionToRoute[action];

    if (route == null) {
      print('⚠️ Unknown action: $action raw=$raw');
      return;
    }

    final args = _buildArgs(action: action, raw: raw, parts: parts);

    _openOnTopOfMainWrapper(
      targetRoute: route,
      arguments: args,
    );
  }

}
