// lib/ui/login_screen/login.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/home_screen/Home/mianwrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/assets_manager.dart';
import '../../core/model/loginModels/LoginResponse.dart';
import '../../core/reusable_components/app_colors_extension.dart';
import '../../core/reusable_components/generalErrorDialog.dart'; // UnderConstructionDialog
import '../../core/reusable_components/login_background.dart';
import '../../core/reusable_components/role_selector.dart';
import '../../core/reusable_components/text_field.dart';
import '../../core/services/FCM-Token-Service.dart';
import '../../core/services/apiExceptions.dart';
import '../../core/services/loginServices/AuthLoginService.dart';
import '../../core/setMobileData.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Save token + username
Future<void> saveUserData(String token, String empName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("token", token);
  await prefs.setString("empName", empName);

}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late TextEditingController userController;
  late TextEditingController passController;
  late TextEditingController mailController;
  late GlobalKey<FormState> formKey;

  UserRole? selectedRole;
  late FocusNode userFocusNode;

  late final AnimationController _switchController;

  static const String emailRegex =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$";

  // ✅ inline error + loading state
  String? _loginErrorText;
  bool _isLoggingIn = false;

  // ✅ inputs enabled only after role selected
  bool get _inputsEnabled => selectedRole != null;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    userController = TextEditingController();
    passController = TextEditingController();
    mailController = TextEditingController();

    userFocusNode = FocusNode();

    _switchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    // ✅ clear inline error as user types
    userController.addListener(_clearLoginError);
    passController.addListener(_clearLoginError);
  }

  @override
  void dispose() {
    userController.removeListener(_clearLoginError);
    passController.removeListener(_clearLoginError);

    userController.dispose();
    passController.dispose();
    mailController.dispose();
    userFocusNode.dispose();
    _switchController.dispose();
    super.dispose();
  }

  void _clearLoginError() {
    if (_loginErrorText != null) {
      setState(() => _loginErrorText = null);
    }
  }

  void _setLoginError(String msg) {
    if (!mounted) return;
    final t = msg.trim();
    setState(() => _loginErrorText = t.isEmpty ? "Something went wrong." : t);
  }

  // Helper to convert UserRole -> readable label
  String _roleLabel(UserRole? r) {
    if (r == null) return '';
    switch (r) {
      case UserRole.parent:
        return 'Parent';
      case UserRole.student:
        return 'Student';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.coach:
        return 'Coach';
      case UserRole.admin:
        return 'Admin';
      case UserRole.coordinator:
        return 'Coordinator';
      default:
        return r.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget transitionBuilder(Widget child, Animation<double> animation) {
      final inOffset = Tween<Offset>(
        begin: const Offset(0, 0.08),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
      final outOffset = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, -0.04),
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

      return SlideTransition(
        position: animation.status == AnimationStatus.reverse ? outOffset : inOffset,
        child: FadeTransition(opacity: animation, child: child),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (details) {
          final result = HitTestResult();
          WidgetsBinding.instance.hitTest(result, details.globalPosition);

          final tappedEditable = result.path.any((hit) {
            final name = hit.target.runtimeType.toString();
            return name.contains("RenderEditable");
          });

          if (!tappedEditable) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            LoginBackground(showTopBlueBar: false),

            Positioned(
              top: 40.h,
              right: 20.w,
              child: PopupMenuButton<Locale>(
                icon: Icon(Icons.language, color: scheme.elements),
                onSelected: (Locale locale) => context.setLocale(locale),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: Locale('en'), child: Text('🇬🇧 English')),
                  PopupMenuItem(value: Locale('fr'), child: Text('🇫🇷 Français')),
                ],
              ),
            ),

            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Form(
                  key: formKey,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AssetsManager.logo, width: 150.w),
                        SizedBox(height: 18.h),

                        Text(
                          "welcome".tr(),
                          style: TextStyle(
                            fontSize: 32.sp,
                            color: scheme.textMainBlack,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 420),
                          transitionBuilder: (child, animation) =>
                              transitionBuilder(child, animation),
                          layoutBuilder: (currentChild, previousChildren) {
                            return Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                ...previousChildren,
                                if (currentChild != null) currentChild,
                              ],
                            );
                          },
                          child: selectedRole == null
                              ? _buildRoleSelectorCard(scheme)
                              : _buildCredentialsCard(scheme),
                        ),

                        // ✅ inline error (small)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (child, animation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, -0.08),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                              child: FadeTransition(opacity: animation, child: child),
                            );
                          },
                          child: (_loginErrorText == null || _loginErrorText!.isEmpty)
                              ? const SizedBox.shrink()
                              : Padding(
                            key: const ValueKey('login-error'),
                            padding: EdgeInsets.only(top: 10.h, left: 24.w, right: 24.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline_rounded,
                                    size: 16.sp, color: Colors.redAccent),
                                SizedBox(width: 6.w),
                                Flexible(
                                  child: Text(
                                    _loginErrorText!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 14.h),

                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 260),
                          opacity: selectedRole == null ? 1.0 : 0.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Text(
                              selectedRole == null ? 'Please choose a role to continue' : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: scheme.onSurface.withOpacity(0.6),
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // ✅ Login button with modern loading
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: (selectedRole != null) ? 1.0 : 0.9,
                          child: SizedBox(
                            width: 330.w,
                            height: 44.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: (selectedRole != null)
                                    ? scheme.elements
                                    : Theme.of(context).disabledColor,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),

                              // ✅ FIX: use _isLoggingIn (not _isLoading)
                              onPressed: (!_inputsEnabled || _isLoggingIn)
                                  ? null
                                  : _loginPressed,

                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: _isLoggingIn
                                    ? Row(
                                  key: const ValueKey('loading'),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 16.r,
                                      height: 16.r,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      'Signing in…',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                )
                                    : Text(
                                  "login".tr(),
                                  key: const ValueKey('text'),
                                  style: TextStyle(
                                    color: scheme.textMainWhite,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUnderConstruction() {
    UnderConstructionDialog.show(
      context,
      message: 'This module will be available soon.',
    );
  }

  Widget _buildRoleSelectorCard(ColorScheme scheme) {
    return Container(
      key: const ValueKey('roleSelector'),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.96),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      width: 360.w,
      child: Column(
        children: [
          RoleSelector(
            initialRole: selectedRole,
            onRoleChanged: (role) {
              if (role != UserRole.parent) {
                _showUnderConstruction();
                return;
              }
              setState(() {
                selectedRole = role;
                _loginErrorText = null;
              });
            },
          ),
          SizedBox(height: 8.h),
          Text(
            'Select your role to continue',
            style: TextStyle(
              fontSize: 13.sp,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialsCard(ColorScheme scheme) {
    return Container(
      key: const ValueKey('credentials'),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.96),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      width: 360.w,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999.r),
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.06),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.badge, size: 18.sp, color: scheme.primary),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          _roleLabel(selectedRole),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              TextButton(
                onPressed: _isLoggingIn
                    ? null
                    : () {
                  setState(() {
                    selectedRole = null;
                    userController.clear();
                    passController.clear();
                    _loginErrorText = null;
                  });
                },
                child: Text('Change role', style: TextStyle(fontSize: 13.sp)),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: AbsorbPointer(
              absorbing: (!_inputsEnabled || _isLoggingIn),
              child: Opacity(
                opacity: (_inputsEnabled && !_isLoggingIn) ? 1.0 : 0.65,
                child: CustomTextField(
                  hint: "enter_user_id".tr(),
                  hintIcon: Icons.person,
                  controller: userController,
                  keyboardType: TextInputType.number,
                  validator: (_) => null,
                  focusNode: userFocusNode,
                  onTap: () {
                    if (!userFocusNode.hasFocus) userFocusNode.requestFocus();
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: AbsorbPointer(
              absorbing: (!_inputsEnabled || _isLoggingIn),
              child: Opacity(
                opacity: (_inputsEnabled && !_isLoggingIn) ? 1.0 : 0.65,
                child: CustomTextField(
                  hint: "enterPassword".tr(),
                  hintIcon: Icons.lock,
                  controller: passController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "empty_password".tr();
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: _isLoggingIn ? null : () => _openResetSheet(context, scheme),
                  child: Text(
                    "forget_password".tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: scheme.textMainBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openResetSheet(BuildContext context, ColorScheme scheme) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        color: scheme.surface,
        child: Column(
          children: [
            Container(
              height: 56.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "reset".tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: scheme.textMainBlack,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: scheme.elements),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.h),
            SizedBox(
              width: 350.w,
              child: CustomTextField(
                hint: "enter_email".tr(),
                hintIcon: Icons.email,
                controller: mailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "empty_email".tr();
                  if (!RegExp(emailRegex).hasMatch(value)) return "not_valid_email".tr();
                  return null;
                },
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: 350.w,
              child: Text(
                "reset_note".tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: scheme.textMainBlack,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.elements,
                minimumSize: Size(330.w, 40.h),
              ),
              onPressed: () {},
              child: Text(
                "reset".tr(),
                style: TextStyle(
                  color: scheme.textMainWhite,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ LOGIN LOGIC (same base logic, fixed loading)
  Future<void> _loginPressed() async {
    if (!formKey.currentState!.validate()) return;

    // ✅ prevent double taps
    if (_isLoggingIn) return;

    setState(() {
      _isLoggingIn = true;
      _loginErrorText = null;
    });

    try {
      final deviceData = await getDeviceData();
      final deviceId = deviceData["deviceId"] ?? "unknown";
      final deviceType = deviceData["deviceType"] ?? "0";
      final fcmToken = await FcmService.getOrFetchToken();

      if (fcmToken.isEmpty) {
        _setLoginError(
          'Notifications are required to sign in. Please enable notifications and try again.',
        );
        return;
      }

      print("📌 Using saved FCM token on login: $fcmToken");

      final response = await AuthLoginService.login(
        username: userController.text,
        password: passController.text,
        deviceId: deviceId,
        DeviceType: deviceType,
        fcmToken: fcmToken,
      );

      if (!mounted) return;

      if (response.token != null && response.token!.isNotEmpty) {
        final userData =
        response.data != null && response.data!.isNotEmpty ? response.data!.first : null;

        final empName = userData?.fatherFullname ?? "";
        final token = response.token ?? "";

        await saveUserData(token, empName);

        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          MainWrapper.routeName,
          arguments: {
            "empName": empName,
            "token": token,
            "role": selectedRole.toString(),
          },
        );
        return;
      }

      _setLoginError('An error occurred. Please try again.');
    } catch (e, st) {
      debugPrint("LOGIN ERROR: $e");
      debugPrintStack(stackTrace: st);

      if (e is ApiException) {
        final code = e.statusCode ?? -1;

        if (code == 204) {
          // ✅ invalid credentials
          _setLoginError('Wrong username or password.');
        }

        else if (code == 401 || code == 403) {
          _setLoginError('Access denied. Please contact support.');
        }
        else if (code == 404) {
          _setLoginError('Service not available. Please try again later.');
        }
        else if (code >= 500) {
          _setLoginError('Server error. Please try again later.');
        }
        else {
          _setLoginError('Server error. Please try again later-.');
        }
      }
      else {
        // Non-ApiException (rare, but keep safe)
        final msg = e.toString().toLowerCase();

        if (msg.contains('socketexception') ||
            msg.contains('no internet') ||
            msg.contains('network')) {
          _setLoginError('No internet connection. Please check your network.');
        }
        else if (msg.contains('timeout')) {
          _setLoginError('Request timed out. Please try again.');
        }
        else {
          _setLoginError('Unexpected error. Please try again later.');
        }
      }
    } finally {
      if (!mounted) return;
      setState(() => _isLoggingIn = false);
    }
  }



}