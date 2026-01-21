// lib/core/reusable_components/Errors/globalOfflineListener.dart
import 'dart:async';
import 'package:flutter/material.dart';

import 'ErrorRetryDialog.dart';
import 'globalNavigatorKey.dart';
import 'networkController.dart';

class GlobalOfflineListener extends StatefulWidget {
  final Widget child;
  const GlobalOfflineListener({super.key, required this.child});

  @override
  State<GlobalOfflineListener> createState() => _GlobalOfflineListenerState();
}

class _GlobalOfflineListenerState extends State<GlobalOfflineListener> {
  StreamSubscription<bool>? _sub;
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();

    _sub = NetworkController.I.onlineStream.listen((isOnline) {
      if (!isOnline) {
        _showOfflineSheet();
      } else {
        _closeIfOpen();
      }
    });
  }

  Future<void> _showOfflineSheet() async {
    if (_sheetOpen) return;

    final ctx = rootNavKey.currentContext;
    if (ctx == null) return;

    _sheetOpen = true;

    // show modern sheet
    await ErrorRetrySheet.show(
      ctx,
      title: 'You are offline',
      message: 'No internet connection. Please check your network.',
      cancelText: 'Close',
      tryAgainText: 'Retry',
      onTryAgain: () async {
        // retry here just re-check internet, if online sheet closes by listener
        await NetworkController.I.start();
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

    // close top-most route if it's the bottom sheet
    if (nav.canPop()) {
      nav.pop();
    }
    _sheetOpen = false;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
