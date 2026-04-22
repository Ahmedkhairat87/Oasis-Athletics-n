import 'dart:async';
import 'package:flutter/material.dart';

import '../errorsDialogs/ErrorRetryDialog.dart';
import 'globalNavigatorKey.dart';
import 'networkController.dart';

class GlobalOfflineListener extends StatefulWidget {
  final Widget child;
  const GlobalOfflineListener({super.key, required this.child});

  @override
  State<GlobalOfflineListener> createState() => _GlobalOfflineListenerState();
}

class _GlobalOfflineListenerState extends State<GlobalOfflineListener>
    with WidgetsBindingObserver {
  StreamSubscription<bool>? _sub;
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _sub = NetworkController.I.onlineStream.listen((isOnline) {
      if (!isOnline) {
        _showOfflineSheet();
      } else {
        _closeIfOpen();
      }
    });
  }

  // ✅ important: when app resumes from lock
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // ignore fake offline for a moment
      NetworkController.I.setResumeGrace(duration: const Duration(seconds: 3));
      // optional: do a refresh after grace
      Future.delayed(const Duration(seconds: 3), () {
        NetworkController.I.refresh();
      });
    }
  }

  Future<void> _showOfflineSheet() async {
    if (_sheetOpen) return;

    final ctx = rootNavKey.currentContext;
    if (ctx == null) return;

    _sheetOpen = true;

    await ErrorRetrySheet.show(
      ctx,
      title: 'You are offline',
      message: 'No internet connection. Please check your network.',
      cancelText: 'Close',
      tryAgainText: 'Retry',
      onTryAgain: () async {
        await NetworkController.I.refresh(forceEmit: true);
      },
      onCancel: () {},
      barrierDismissible: true,
    );

    _sheetOpen = false;
  }

  void _closeIfOpen() {
    if (!_sheetOpen) return;
    final nav = rootNavKey.currentState;
    if (nav == null) return;

    if (nav.canPop()) nav.pop();
    _sheetOpen = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}