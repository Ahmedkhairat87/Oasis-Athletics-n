import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FcmService {
  FirebaseMessaging? _messaging;
  static const _prefsKey = 'fcm_token';

  Future<void> init() async {
    _messaging ??= FirebaseMessaging.instance;

    await _messaging!.requestPermission(alert: true, badge: true, sound: true);

    await _saveCurrentToken();

    _messaging!.onTokenRefresh.listen((newToken) async {
      if (newToken.isEmpty) return;

      await _saveTokenToPrefs(newToken);
      print('🔄 FCM TOKEN refreshed & saved: $newToken');

      await _syncTokenIfLoggedIn(newToken);
    });
  }

  Future<void> _saveCurrentToken() async {
    _messaging ??= FirebaseMessaging.instance;
    final token = await _messaging!.getToken();
    if (token == null || token.isEmpty) return;

    await _saveTokenToPrefs(token);
    print('✅ FCM TOKEN saved: $token');
  }

  static Future<void> _saveTokenToPrefs(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, token);
  }

  static Future<String> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsKey) ?? '';
  }

  static Future<String> getOrFetchToken() async {
    final saved = await getSavedToken();
    if (saved.isNotEmpty) return saved;

    await FirebaseMessaging.instance.requestPermission(
      alert: true, badge: true, sound: true,
    );

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) return '';

    await _saveTokenToPrefs(token);
    return token;
  }

  Future<void> _syncTokenIfLoggedIn(String fcmToken) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('token') ?? '';
    if (authToken.isEmpty) return;

    // TODO call API
  }
}