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
import '../../core/reusable_components/errorsDialogs/appDialog.dart';
import '../../core/reusable_components/generalErrorDialog.dart';
import '../../core/reusable_components/login_background.dart';
import '../../core/reusable_components/role_selector.dart';
import '../../core/reusable_components/text_field.dart';
import '../../core/services/FCM-Token-Service.dart';
import '../../core/services/apiExceptions.dart';
import '../../core/services/loginServices/AuthLoginService.dart';
import '../../core/setMobileData.dart';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  // ✅ make them PUBLIC (no underscore)
  static const kToken = 'token';
  static const kEmpName = 'empName';
  static const kBioEnabled = 'bio_enabled';
  static const kBioAsked = 'bio_asked';


  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Save token + username
Future<void> saveUserData(String token, String empName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(LoginScreen.kToken, token);
  await prefs.setString(LoginScreen.kEmpName, empName);

  // ✅ optional: store last user id to show on biometrics card (like screenshot)
  // if you want to show it, call this also in _loginPressed with userController.text
  // await prefs.setString('last_user', userId);
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late TextEditingController userController;
  late TextEditingController passController;
  late TextEditingController mailController;
  late GlobalKey<FormState> formKey;
  bool _autoStarted = false;
  bool _authInProgress = false;
  static const int maxBioFails = 3;
  static const String kBioFailCount = 'bio_fail_count';
  final LocalAuthentication _auth = LocalAuthentication();

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

  // ---------------------------
  // ✅ Session/Biometrics gate
  // ---------------------------
  bool _checkingSession = true;
  bool _hasSession = false;
  bool _bioEnabled = false;
  bool _bioBusy = false;
  bool _authAutoTriggered = false;

  String _lastUserId = '';



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

    // ✅ bootstrap session check + auto-biometrics (once)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_autoStarted) return;
      _autoStarted = true;
      _bootstrapAuthGate();
    });
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
        return 'parent'.tr();
      case UserRole.student:
        return 'student'.tr();
      case UserRole.teacher:
        return 'teacher'.tr();
      case UserRole.coach:
        return 'coach'.tr();
      case UserRole.admin:
        return 'admin'.tr();
      case UserRole.coordinator:
        return 'coordinator'.tr();
      default:
        return '';
    }
  }
  // ✅ Bootstrap: check if token exists + bio enabled -> auto auth once
  Future<void> _bootstrapAuthGate() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(LoginScreen.kToken) ?? '';
    final bioEnabled = prefs.getBool(LoginScreen.kBioEnabled) ?? false;
    final lastUser = prefs.getString('last_user') ?? '';

    if (!mounted) return;

    setState(() {
      _checkingSession = false;
      _hasSession = token.isNotEmpty;
      _bioEnabled = bioEnabled;
      _lastUserId = lastUser;
    });

    final fails = prefs.getInt(kBioFailCount) ?? 0;
    if (_hasSession && _bioEnabled && fails < maxBioFails && !_authAutoTriggered) {
      _authAutoTriggered = true;
      if (_bioBusy || _authInProgress) return;
      await _loginWithBiometrics();
    }
  }

  // ✅ Call local_auth and stay on screen if failed (show message)
  Future<void> _loginWithBiometrics() async {
    if (_bioBusy || _authInProgress) return;

    setState(() {
      _bioBusy = true;
      _loginErrorText = null;
    });

    final ok = await _authenticateForLogin();
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();

    if (ok) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('suppress_lock_until',
          DateTime.now().add(const Duration(seconds: 4)).millisecondsSinceEpoch);

      await prefs.setInt(kBioFailCount, 0);
      Navigator.of(context).pop(true);
      //Navigator.pushReplacementNamed(context, MainWrapper.routeName);
      return;
    }
    else {
      // ✅ increment fails
      final fails = (prefs.getInt(kBioFailCount) ?? 0) + 1;
      await prefs.setInt(kBioFailCount, fails);

      if (fails >= maxBioFails) {
        // ✅ too many fails -> force login again
        await prefs.setInt(kBioFailCount, 0);
        await prefs.setBool(LoginScreen.kBioEnabled, false);
        await _forceLogoutLocalOnly();

        if (!mounted) return;
        setState(() {
          _hasSession = false;
          _bioEnabled = false;
          _authAutoTriggered = false;
          _loginErrorText = 'too_many_failed_attempts'.tr();
        });

        // No navigation needed: your UI will switch to normal login because showBioGate becomes false
      } else {
        _setLoginError(
          'authentication_failed_try_again'.tr(
            namedArgs: {
              'current': '$fails',
              'max': '$maxBioFails',
            },
          ),
        );
      }
    }

    if (mounted) setState(() => _bioBusy = false);
  }
  Future<bool> _authenticateForLogin() async {
    if (_authInProgress) return false;
    _authInProgress = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auth_in_progress', true);

    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) return false; // means no biometrics AND no device credentials available

      final ok = await _auth.authenticate(
        localizedReason: 'confirm_to_continue'.tr(),
        options: const AuthenticationOptions(
          biometricOnly: false, // ✅ allows PIN/pattern/password
          stickyAuth: false,
          useErrorDialogs: true,
        ),
      );

      return ok;
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    } finally {
      _authInProgress = false;
      await prefs.setBool('auth_in_progress', false);
    }
  }

  Future<void> _forceLogoutLocalOnly() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(LoginScreen.kToken);
    await prefs.remove(LoginScreen.kEmpName);
  }

  // ✅ Ask once (after real login) if user wants app lock
  Future<void> _maybeAskEnableBiometrics() async {
    final prefs = await SharedPreferences.getInstance();

    final alreadyAsked = prefs.getBool(LoginScreen.kBioAsked) ?? false;
    if (alreadyAsked) return;

    await prefs.setBool(LoginScreen.kBioAsked, true);

    final supported = await _auth.isDeviceSupported();
    if (!supported) {
      await prefs.setBool(LoginScreen.kBioEnabled, false);
      return;
    }

    if (!mounted) return;

    final enable = await ModernActionSheet.confirm(
      context,
      title: "faceIDtitle".tr(),
      message:"faceIDMsg".tr(),
      cancelText: "faceIDCancel".tr(),
      confirmText: "faceIDOK".tr(),
      icon: Icons.face_rounded,
      footNote: "faceIdOptionMsg".tr(),
    );

    if (!enable) {
      await prefs.setBool(LoginScreen.kBioEnabled, false);
      return;
    }

    // ✅ NOW authenticate once to confirm
    try {
      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'confirm_biometric_setup'.tr(),
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        await prefs.setBool(LoginScreen.kBioEnabled, true);
      } else {
        await prefs.setBool(LoginScreen.kBioEnabled, false);
      }
    } catch (e) {
      await prefs.setBool(LoginScreen.kBioEnabled, false);
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

    final showBioGate = !_checkingSession && _hasSession && _bioEnabled;

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

                        if (showBioGate) ...[
                          SizedBox(height: 14.h),

                          Text(
                            'Enter the password for your account',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: scheme.onSurface.withOpacity(0.55),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6.h),

                          if (_lastUserId.isNotEmpty)
                            Text(
                              _lastUserId,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: scheme.onSurface.withOpacity(0.75),
                              ),
                            ),

                          SizedBox(height: 20.h),

                          Container(
                            width: 140.w,
                            height: 140.w,
                            decoration: BoxDecoration(
                              color: scheme.onSurface.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.face,
                                  size: 52.sp,
                                  color: scheme.onSurface.withOpacity(0.25),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Face ID',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),

                          SizedBox(
                            width: 330.w,
                            height: 44.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: scheme.elements,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              onPressed: _bioBusy ? null : _loginWithBiometrics,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: _bioBusy
                                    ? Row(
                                  key: const ValueKey('bio-loading'),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      'Checking…',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                )
                                    : Text(
                                  'Use Face ID',
                                  key: const ValueKey('bio-text'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 10.h),

                          TextButton(
                            onPressed: () async {
                              await _forceLogoutLocalOnly();
                              if (!mounted) return;
                              setState(() {
                                _hasSession = false;
                                _bioEnabled = false;
                                _authAutoTriggered = false;
                              });
                            },
                            child: Text('sign_in_again'.tr())
                          ),

                          SizedBox(height: 8.h),
                        ] else ...[
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

                          SizedBox(height: 8.h),

                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: (selectedRole != null) ? 1.0 : 0.9,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 330.w,
                                minHeight: 52.h,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: (selectedRole != null)
                                        ? scheme.elements
                                        : Theme.of(context).disabledColor,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(double.infinity, 52.h),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 12.h,
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  onPressed:
                                  (!_inputsEnabled || _isLoggingIn) ? null : _loginPressed,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: _isLoggingIn
                                        ? Row(
                                      key: const ValueKey('loading'),
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 16.r,
                                          height: 16.r,
                                          child: const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Flexible(
                                          child: Text(
                                            'Signing in…',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                        : FittedBox(
                                      key: const ValueKey('text'),
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "login".tr(),
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
                            ),
                          ),
                        ],

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (child, animation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, -0.08),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(parent: animation, curve: Curves.easeOut),
                              ),
                              child: FadeTransition(opacity: animation, child: child),
                            );
                          },
                          child: (_loginErrorText == null || _loginErrorText!.isEmpty)
                              ? const SizedBox.shrink()
                              : Padding(
                            key: const ValueKey('login-error'),
                            padding: EdgeInsets.only(
                              top: 10.h,
                              left: 24.w,
                              right: 24.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline_rounded,
                                  size: 16.sp,
                                  color: Colors.redAccent,
                                ),
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

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 8.h,
              right: 12.w,
              child: Material(
                color: Colors.transparent,
                child: PopupMenuButton<Locale>(
                  tooltip: 'language'.tr(),
                  icon: Icon(
                    Icons.language,
                    color: scheme.elements,
                    size: 24.sp,
                  ),
                  onSelected: (Locale locale) async {
                    await context.setLocale(locale);
                    if (mounted) setState(() {});
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: const Locale('en'),
                      child: Text(
                        '🇬🇧 English',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    PopupMenuItem(
                      value: const Locale('fr'),
                      child: Text(
                        '🇫🇷 Français',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ],
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
      message: 'under_construction_message'.tr(),
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
            "selectRole".tr(),
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
                child: Text('change_role'.tr(), style: TextStyle(fontSize: 13.sp))
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
                    if (value == null || value.isEmpty) return "empty_password".tr();
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

  /// ✅ LOGIN LOGIC (your original, with storing last_user + asking biometrics)
  Future<void> _loginPressed() async {
    if (!formKey.currentState!.validate()) return;
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
          _setLoginError('notifications_required_signin'.tr()
        );
        return;
      }

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

        // ✅ 1) CHECK ACCOUNT STATUS BEFORE SAVING TOKEN
        final appAccountStatus = userData?.appAccountStatus ?? 1; // int? in your model
        final accountStatus = userData?.accountStatus ?? 1;

        if (appAccountStatus == 0 || accountStatus == 0) {
          // make sure nothing saved locally
          await _forceLogoutLocalOnly();

          // show message and STOP
          _setLoginError("financeError".tr());
          return;
        }

        final empName = userData?.fatherFullname ?? "";
        final token = response.token ?? "";

        // ✅ save session
        await saveUserData(token, empName);

        // ✅ save last_user for FaceID screen label
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('last_user', userController.text);

        // ✅ ask enable biometrics (once)
        await _maybeAskEnableBiometrics();

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, MainWrapper.routeName);
        return;
      }

      _setLoginError('generic_error_try_again'.tr());
    } catch (e, st) {
      debugPrint("LOGIN ERROR: $e");
      debugPrintStack(stackTrace: st);

      if (e is ApiException) {
        final code = e.statusCode ?? -1;

        if (code == 204) _setLoginError('wrong_username_or_password'.tr());
        else if (code == 401 || code == 403) _setLoginError('access_denied_contact_support'.tr());
        else if (code == 404) _setLoginError('service_not_available'.tr());
        else if (code >= 500) _setLoginError('server_error_try_later'.tr());
        else _setLoginError('no_internet_connection'.tr());
      } else {
        final msg = e.toString().toLowerCase();
        if (msg.contains('socketexception') || msg.contains('no internet') || msg.contains('network')) {
          _setLoginError('no_internet_connection'.tr());
        } else if (msg.contains('timeout')) {
          _setLoginError('request_timed_out'.tr());
        } else {
          _setLoginError('unexpected_error'.tr());
        }
      }
    } finally {
      if (!mounted) return;
      setState(() => _isLoggingIn = false);
    }
  }
}
