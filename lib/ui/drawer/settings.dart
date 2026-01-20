import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../core/reusable_components/Notifiers/theme_mode_provider.dart';
import '../../core/reusable_components/app_background.dart';

import '../../core/reusable_components/language_dropdown.dart';
import '../../core/reusable_components/setting_tile.dart';

class Settings extends StatefulWidget {
  static const routeName = '/settings';
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notificationsEnabled = true;

  Future<void> _contactSupport() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@oasisdemaadi.com',
      query: 'subject=Support Request',
    );

    try {
      final launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) throw Exception();
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr('unable_to_open_email'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    final themeProvider = context.watch<ThemeModeProvider>();
    final isDarkMode = themeProvider.isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.2),
        elevation: 0,
        title: Text(tr('settings'), style: TextStyle(color: textColor)),
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Stack(
        children: [
          /// Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.blue.withOpacity(0.05),
                ],
              ),
            ),
          ),

          /// Decorative bubbles
          Positioned(top: -50, left: -50, child: _bubble(150.w)),
          Positioned(bottom: -60, right: -60, child: _bubble(200.w)),

          /// Main content
          AppBackground(
            child: Padding(
              padding: EdgeInsets.only(
                top: kToolbarHeight + MediaQuery.of(context).padding.top + 20.h,
                left: 20.w,
                right: 20.w,
              ),
              child: ListView(
                children: [
                  /// Theme
                  SettingTile(
                    icon: Icons.dark_mode_rounded,
                    title: tr('theme'),
                    trailing: Switch(
                      value: isDarkMode,
                      activeThumbColor: Colors.blueAccent,
                      onChanged: (value) => themeProvider.toggleTheme(value),
                    ),
                  ),
                  _divider(),

                  /// Language
                  SettingTile(
                    icon: Icons.language_rounded,
                    title: tr('language'),
                    trailing: LanguageDropdown(isDarkMode: isDarkMode),
                  ),
                  _divider(),

                  /// Notifications
                  SettingTile(
                    icon: Icons.notifications_active,
                    title: tr('notifications'),
                    trailing: Switch(
                      value: _notificationsEnabled,
                      activeThumbColor: Colors.blueAccent,
                      onChanged:
                          (value) =>
                              setState(() => _notificationsEnabled = value),
                    ),
                  ),
                  _divider(),

                  /// Change password
                  SettingTile(
                    icon: Icons.password,
                    title: tr('change_password'),
                    onTap: () {
                      // TODO: navigate to change password screen
                    },
                  ),
                  _divider(),

                  /// Contact support
                  SettingTile(
                    icon: Icons.support_agent,
                    title: tr('contact_support'),
                    onTap: _contactSupport,
                  ),
                  _divider(),

                  /// App version
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Text(
                        'App Version 1.0.0',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color:
                              isDarkMode
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent.withOpacity(0.3),
            Colors.white.withOpacity(0.05),
          ],
        ),
      ),
    );
  }

  Widget _divider() =>
      Divider(color: Colors.black.withOpacity(0.05), height: 8.h, thickness: 1);
}
