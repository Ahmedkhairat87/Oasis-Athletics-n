import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../../bloc/nav_drawer_state.dart';
import '../../../bloc/drawer_event.dart';
import '../../../bloc/nav_drawer_bloc.dart';
import '../../../core/colors_Manager.dart';

class _NavigationItem {
  final NavItem item;
  final String title;
  final IconData icon;

  _NavigationItem(this.item, this.title, this.icon);
}

class NavDrawerWidget extends StatelessWidget {
  NavDrawerWidget({super.key});

  /// Drawer Items
  final List<_NavigationItem> _listItems = [
    _NavigationItem(NavItem.homeView, "Home", IconlyBold.home),
    _NavigationItem(NavItem.appointmentsView, "Profile", IconlyBold.profile),
    _NavigationItem(NavItem.busRegView, "Orders", IconlyBold.category),
    _NavigationItem(NavItem.canteenChargeView, "Cart", IconlyBold.bag_2),
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final Color secondaryBlue =
        isLight
            ? ColorsManager.primaryGradientEnd
            : ColorsManager.primaryGradientEndDark;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryBlue.withOpacity(0.08),
              accentMint.withOpacity(0.10),
              accentSun.withOpacity(0.09),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(
              context,
              primaryBlue: primaryBlue,
              secondaryBlue: secondaryBlue,
              accentSky: accentSky,
            ),

            /// Items
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _listItems.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder:
                    (BuildContext context, int index) =>
                        BlocBuilder<NavDrawerBloc, NavDrawerState>(
                          builder:
                              (BuildContext context, NavDrawerState state) =>
                                  _buildItem(_listItems[index], state, index),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Animated multicolor header
  Widget _buildHeader(
    BuildContext context, {
    required Color primaryBlue,
    required Color secondaryBlue,
    required Color accentSky,
  }) {
    return SizedBox(
      height: 190.h,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.9, end: 1.0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            alignment: Alignment.bottomLeft,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, secondaryBlue, accentSky],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: 18.h,
            top: 32.h,
          ),
          child: Row(
            children: [
              // avatar
              Container(
                width: 60.w,
                height: 60.w,
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
                  child: const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/91388754?v=4',
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // name / email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'FlexZ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'amirBayat.dev@gmail',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.86),
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999.r),
                        color: Colors.white.withOpacity(0.14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 18,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Oasis Athletics',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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

  /// Build Each Drawer Item
  Widget _buildItem(_NavigationItem data, NavDrawerState state, int index) =>
      _makeListItem(data, state, index);

  /// Each Drawer Item – joyful multicolor + animation
  Widget _makeListItem(_NavigationItem data, NavDrawerState state, int index) {
    final bool selected = data.item == state.selectedItem;

    final Color accentSky = ColorsManager.accentSky;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentPurple = ColorsManager.accentPurple;

    final Color bgSelected = Colors.white.withOpacity(0.96);
    final Color bgUnselected = Colors.white.withOpacity(0.50);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.97, end: 1.0),
      duration: Duration(milliseconds: 220 + index * 40),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 8),
            child: child,
          ),
        );
      },
      child: Builder(
        builder: (BuildContext context) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient:
                  selected
                      ? LinearGradient(
                        colors: [
                          bgSelected,
                          ColorsManager.accentMint.withOpacity(0.16),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                      : null,
              color: selected ? null : bgUnselected,
              border: Border.all(
                color:
                    selected
                        ? accentSky.withOpacity(0.9)
                        : Colors.black12.withOpacity(0.1),
                width: selected ? 1.4 : 0.6,
              ),
              boxShadow:
                  selected
                      ? [
                        BoxShadow(
                          color: accentSky.withOpacity(0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ]
                      : [],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 2.h,
              ),
              leading: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                      selected
                          ? LinearGradient(
                            colors: [accentSky, accentMint, accentSun],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                  color: selected ? null : Colors.black.withOpacity(0.04),
                ),
                child: Icon(
                  data.icon,
                  size: 20.w,
                  color:
                      selected ? Colors.white : accentPurple.withOpacity(0.8),
                ),
              ),
              title: Text(
                data.title,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  fontSize: 14.sp,
                  color:
                      selected ? accentPurple : Colors.black.withOpacity(0.65),
                ),
              ),
              onTap: () => _handleItemClick(context, data.item),
            ),
          );
        },
      ),
    );
  }

  /// Tap OnEach item Handler
  void _handleItemClick(BuildContext context, NavItem item) {
    BlocProvider.of<NavDrawerBloc>(context).add(NavigateTo(item));
    Navigator.pop(context);
  }
}
