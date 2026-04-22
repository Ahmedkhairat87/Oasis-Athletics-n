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

  // ✅ New: ignore offline immediately after resume/unlock
  DateTime _ignoreOfflineUntil = DateTime.fromMillisecondsSinceEpoch(0);

  // ✅ New: require multiple consecutive failures (prevents false offline)
  int _offlineStrikes = 0;

  Future<void> start({Duration pollEvery = const Duration(seconds: 5)}) async {
    // emit initial (but do not instantly show offline after resume)
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

  /// Call this from app lifecycle resume
  void setResumeGrace({Duration duration = const Duration(seconds: 3)}) {
    _ignoreOfflineUntil = DateTime.now().add(duration);
  }

  Future<void> refresh({bool forceEmit = false}) async {
    await _refreshAndEmit(forceEmit: forceEmit);
  }

  Future<void> _refreshAndEmit({bool forceEmit = false}) async {
    // ✅ Step 1: check connectivity type first
    final conn = await Connectivity().checkConnectivity();
    final hasConn = conn != ConnectivityResult.none;

    // If no connectivity at all -> allow offline (but still respect resume grace)
    if (!hasConn) {
      if (DateTime.now().isBefore(_ignoreOfflineUntil) && !forceEmit) {
        return; // ignore quick false offline after unlock
      }
      _offlineStrikes = 2; // treat as confirmed offline
      return _emitIfChanged(false, forceEmit: forceEmit);
    }

    // ✅ Step 2: confirm real internet
    final online = await NetworkGuard.hasInternet();

    if (online) {
      _offlineStrikes = 0;
      return _emitIfChanged(true, forceEmit: forceEmit);
    }

    // online == false but device has connectivity (common on resume)
    if (DateTime.now().isBefore(_ignoreOfflineUntil) && !forceEmit) {
      return; // ignore during grace period
    }

    // ✅ "2 strikes" rule
    _offlineStrikes++;
    if (_offlineStrikes < 2 && !forceEmit) return;

    return _emitIfChanged(false, forceEmit: forceEmit);
  }

  void _emitIfChanged(bool online, {bool forceEmit = false}) {
    if (!forceEmit && online == _lastOnline) return;
    _lastOnline = online;
    _controller.add(online);
  }
}