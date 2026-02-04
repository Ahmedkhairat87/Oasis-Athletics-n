import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/Utilities/fontsHelper.dart';
import '../../../../core/colors_Manager.dart';
import '../../../../core/model/regStdModels/SideMenu.dart';

// ✅ skeleton reusable
import '../../../../core/reusable_components/gridViewAnimation/tabsSkeletonGrid.dart';

import 'package:oasisathletic/ui/drawer/canteen_charge.dart';
import 'package:oasisathletic/ui/home_screen/sideMenu/Gallery/galleryAlbums.dart';
import 'package:oasisathletic/ui/home_screen/sideMenu/newsLetter/NewsLetterScreen.dart';
import 'package:oasisathletic/ui/webView-attachmentopener/WebViewScreen.dart';
import '../../../drawer/settings.dart';
import '../../MSGScreens/messages.dart';

class HomeDrawer extends StatefulWidget {
  final List<SideMenu> sideMenuList;
  final bool isLoading;
  final bool isOnline;

  const HomeDrawer({
    super.key,
    required this.sideMenuList,
    required this.isLoading,
    required this.isOnline,
  });

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int selectedIndex = -1;

  bool get _disabled => widget.isLoading || !widget.isOnline;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSideMenuTap(BuildContext context, SideMenu item, int index) {
    if (_disabled) return; // ✅ ممنوع الضغط وقت offline/loading

    setState(() => selectedIndex = index);

    final linkName = (item.lnkNameEn ?? '').trim();
    final url = _pickLocalizedUrl(
      context,
      en: item.lnkURLEn,
      fr: item.lnkURLFr,
    );

    Navigator.pop(context);

    if (_isUrl(url)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => WebViewScreen(
                title: linkName.isNotEmpty ? linkName : "open".tr(),
                url: url,
              ),
        ),
      );
      return;
    }

    if (linkName.contains('Messages')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Messages()),
      );
    } else if (linkName.contains('Newsletter')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NewsLetterScreen()),
      );
    } else if (linkName.contains('Canteen\n Charge')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CanteenCharge()),
      );
    } else if (linkName.contains('School Gallery')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GalleryAlbums()),
      );
    } else if (linkName.contains('settings')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Settings()),
      );
    }
  }

  String _pickLocalizedUrl(BuildContext context, {String? en, String? fr}) {
    final lang = context.locale.languageCode.toLowerCase();
    final enUrl = (en ?? '').trim();
    final frUrl = (fr ?? '').trim();

    if (lang == 'fr') return frUrl.isNotEmpty ? frUrl : enUrl;
    return enUrl.isNotEmpty ? enUrl : frUrl;
  }

  bool _isUrl(String s) {
    final uri = Uri.tryParse(s.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final sideMenu = widget.sideMenuList;

    final Color primaryBlue = ColorsManager.primaryGradientStart;
    final Color secondaryBlue = ColorsManager.primaryGradientEnd;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentSun = ColorsManager.accentSun;

    return Drawer(
      child: Container(
        decoration:
            isLight
                ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryBlue.withOpacity(0.10),
                      accentMint.withOpacity(0.12),
                      accentSun.withOpacity(0.10),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                )
                : BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                ),
        child: Column(
          children: [
            _buildHeader(
              context,
              primaryBlue: primaryBlue,
              secondaryBlue: secondaryBlue,
              accentSky: accentSky,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              child: Container(
                decoration:
                    isLight
                        ? BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(18.r),
                          boxShadow: [
                            BoxShadow(
                              color: primaryBlue.withOpacity(0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        )
                        : BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withOpacity(0.35),
                          ),
                        ),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.home_rounded,
                          color:
                              isLight
                                  ? accentSky
                                  : Theme.of(context).colorScheme.onSurface,
                        ),
                        title: Text(
                          'Home'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                isLight
                                    ? Colors.black87
                                    : Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: fsp(context, 14, max: 16),
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.person_rounded,
                          color:
                              isLight
                                  ? accentSun
                                  : Theme.of(context).colorScheme.onSurface,
                        ),
                        title: Text(
                          'Profile'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                isLight
                                    ? Colors.black87
                                    : Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: fsp(context, 14, max: 16),
                          ),
                        ),
                        onTap:
                            () =>
                                Navigator.pushNamed(context, '/parentprofile'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 4),

            // ✅ محتوى القائمة: skeleton لو offline/loading
            Expanded(
              child: Stack(
                children: [
                  if (_disabled)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      child: const TabsSkeletonGrid(itemCount: 6),
                    )
                  else if (sideMenu.isEmpty)
                    const Center(
                      child: Text(
                        "No menu items",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  else
                    GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      itemCount: sideMenu.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        final item = sideMenu[index];
                        final iconPath = (item.lnkPhotoEn ?? "").trim();

                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.96, end: 1.0),
                          duration: Duration(milliseconds: 220 + index * 40),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            final opacity = value.clamp(0.0, 1.0);
                            return Opacity(
                              opacity: opacity,
                              child: Transform.translate(
                                offset: Offset(0, (1 - opacity) * 10),
                                child: child,
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap:
                                    () => _handleSideMenuTap(
                                      context,
                                      item,
                                      index,
                                    ),
                                child:
                                    iconPath.isNotEmpty
                                        ? Ink.image(
                                          image: NetworkImage(iconPath),
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                          height: double.infinity,
                                        )
                                        : Container(
                                          color: Colors.black12,
                                          child: Center(
                                            child: Icon(
                                              Icons.menu,
                                              size: 30.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  // ✅ banner صغيرة فوق لو Offline
                  if (!widget.isOnline)
                    Positioned(
                      left: 12.w,
                      right: 12.w,
                      top: 8.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wifi_off_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 8.w),
                            const Expanded(
                              child: Text(
                                "You are offline",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required Color primaryBlue,
    required Color secondaryBlue,
    required Color accentSky,
  }) {
    return SizedBox(
      height: 170.h,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.9, end: 1.0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          final opacity = value.clamp(0.0, 1.0);
          return Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: value,
              alignment: Alignment.bottomLeft,
              child: child,
            ),
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, secondaryBlue, accentSky],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 18.w,
            right: 18.w,
            top: 32.h,
            bottom: 18.h,
          ),
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      ColorsManager.accentSun,
                      ColorsManager.accentMint,
                      ColorsManager.accentSky,
                      primaryBlue,
                      ColorsManager.accentSun,
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.95),
                    child: Text(
                      'Hi',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: fsp(context, 16, max: 18),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello!',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fsp(context, 24, max: 30),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Welcome to Oasis Athletics',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.86),
                        fontSize: fsp(context, 13, max: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
