// lib/core/reusable_components/Errors/networkController.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'checkInternetConnection.dart';

class NetworkController {
  NetworkController._();
  static final NetworkController I = NetworkController._();

  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get onlineStream => _controller.stream;

  bool _lastOnline = true;
  bool get isOnline => _lastOnline;

  StreamSubscription? _connSub;
  Timer? _pollTimer;

  Future<void> start({Duration pollEvery = const Duration(seconds: 5)}) async {
    // ✅ emit initial
    await _refreshAndEmit(forceEmit: true);

    _connSub?.cancel();
    _connSub = Connectivity().onConnectivityChanged.listen((_) async {
      await _refreshAndEmit();
    });

    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(pollEvery, (_) async {
      await _refreshAndEmit();
    });
  }

  Future<void> stop() async {
    await _connSub?.cancel();
    _connSub = null;
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> _refreshAndEmit({bool forceEmit = false}) async {
    final online = await NetworkGuard.hasInternet();
    if (!forceEmit && online == _lastOnline) return;

    _lastOnline = online;
    _controller.add(online);
  }
}
