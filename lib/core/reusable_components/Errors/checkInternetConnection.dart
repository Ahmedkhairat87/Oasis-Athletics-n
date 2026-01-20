import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkGuard {
  static Future<bool> hasInternet({
    Duration dnsTimeout = const Duration(seconds: 2),
  }) async {
    final conn = await Connectivity().checkConnectivity();
    if (conn == ConnectivityResult.none) return false;

    // Optional: verify actual internet (DNS)
    try {
      final r = await InternetAddress.lookup('example.com').timeout(dnsTimeout);
      return r.isNotEmpty && r.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
