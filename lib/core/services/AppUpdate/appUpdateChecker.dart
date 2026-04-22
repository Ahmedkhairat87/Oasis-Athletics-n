import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../reusable_components/errorsDialogs/appDialog.dart';

class AppUpdateChecker {
  static bool _dialogOpen = false;

  /// Replace these with your real store links
  static const String _androidStoreUrl =
      'https://play.google.com/store/apps/details?id=com.oasisdemaadi.oasisathletics';
  static const String _iosStoreUrl =
      'https://apps.apple.com/eg/app/oasis-athletics/id6753315911';

  static Future<void> checkAndShow({
    required BuildContext context,
    required String? androidVersion,
    required String? iosVersion,
    required dynamic urgentUpdateAndroid,
    required dynamic urgentUpdateIOS,
  }) async {
    if (!context.mounted) return;
    if (_dialogOpen) return;

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    final bool isAndroid = Platform.isAndroid;
    final bool isIOS = Platform.isIOS;

    if (!isAndroid && !isIOS) return;

    final String apiVersion =
    isAndroid ? (androidVersion ?? '').trim() : (iosVersion ?? '').trim();

    final bool forceUpdate = _toInt(
      isAndroid ? urgentUpdateAndroid : urgentUpdateIOS,
    ) ==
        1;

    if (apiVersion.isEmpty) return;

    final needsUpdate = _isApiVersionHigher(
      currentVersion: currentVersion,
      apiVersion: apiVersion,
    );

    if (!needsUpdate) return;

    final prefs = await SharedPreferences.getInstance();

    /// for non-force update:
    /// if user cancelled this same api version before, don't show again
    final dismissedKey = isAndroid
        ? 'dismissed_android_update_version'
        : 'dismissed_ios_update_version';

    final dismissedVersion = prefs.getString(dismissedKey);

    if (!forceUpdate && dismissedVersion == apiVersion) {
      return;
    }

    _dialogOpen = true;

    try {
      if (forceUpdate) {
        await _showForceUpdateDialog(
          context: context,
          apiVersion: apiVersion,
        );
      } else {
        final confirmed = await ModernActionSheet.confirm(
          context,
          title: 'update_available_title'.tr(),
          message: 'update_available_message'.tr(
            namedArgs: {'version': apiVersion},
          ),
          cancelText: 'later_button'.tr(),
          confirmText: 'update_button'.tr(),
          icon: Icons.system_update_rounded,
          barrierDismissible: true,
        );

        if (confirmed) {
          await _openStore();
        } else {
          await prefs.setString(dismissedKey, apiVersion);
        }
      }
    } finally {
      _dialogOpen = false;
    }
  }

  static Future<void> _showForceUpdateDialog({
    required BuildContext context,
    required String apiVersion,
  }) async {
    await ModernActionSheet.singleAction(
      context,
      title: 'update_required_title'.tr(),
      message: 'update_required_message'.tr(
        namedArgs: {'version': apiVersion},
      ),
      actionText: 'update_button'.tr(),
      icon: Icons.system_update_rounded,
      barrierDismissible: false,
      onAction: () async {
        await _openStore();
      },
    );
  }

  static Future<void> _openStore() async {
    final url = Platform.isIOS ? _iosStoreUrl : _androidStoreUrl;
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static bool _isApiVersionHigher({
    required String currentVersion,
    required String apiVersion,
  }) {
    final currentParts = _normalize(currentVersion);
    final apiParts = _normalize(apiVersion);

    final maxLength =
    currentParts.length > apiParts.length ? currentParts.length : apiParts.length;

    for (int i = 0; i < maxLength; i++) {
      final current = i < currentParts.length ? currentParts[i] : 0;
      final api = i < apiParts.length ? apiParts[i] : 0;

      if (api > current) return true;
      if (api < current) return false;
    }

    return false;
  }

  static List<int> _normalize(String version) {
    return version
        .split('.')
        .map((e) => int.tryParse(e.trim()) ?? 0)
        .toList();
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}