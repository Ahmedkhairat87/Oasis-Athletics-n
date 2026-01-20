// lib/ui/home_screen/widgets/student_inside_tabs/meals_tab.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/colors_Manager.dart';

enum MealStatus { allPlate, mostPlate, tasted, none }

class DayMeals {
  final DateTime date;
  final MealStatus breakfast;
  final MealStatus lunch;
  final MealStatus dinner;

  DayMeals({
    required this.date,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });
}

class MealsTab extends StatefulWidget {
  const MealsTab({super.key});

  @override
  State<MealsTab> createState() => _MealsTabState();
}

class _MealsTabState extends State<MealsTab> with TickerProviderStateMixin {
  late final TabController _monthsController;
  final int _monthsRange = 6;
  late final List<DateTime> _months;
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  final Map<String, DayMeals> _mockData = {};

  @override
  void initState() {
    super.initState();

    _months = List.generate(_monthsRange * 2 + 1, (i) {
      final offset = i - _monthsRange;
      final d = DateTime(DateTime.now().year, DateTime.now().month + offset);
      return DateTime(d.year, d.month);
    });

    _selectedMonth = _months[_monthsRange];

    _monthsController = TabController(
      length: _months.length,
      vsync: this,
      initialIndex: _monthsRange,
    );

    _generateMockData();
  }

  @override
  void dispose() {
    _monthsController.dispose();
    super.dispose();
  }

  void _generateMockData() {
    for (final month in _months) {
      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      for (int d = 1; d <= daysInMonth; d++) {
        final date = DateTime(month.year, month.month, d);
        final key = _keyFor(date);
        final seed = date.day + month.month;

        MealStatus pick(int offset) {
          final v = (seed + offset) % 4;
          return MealStatus.values[v];
        }

        _mockData[key] = DayMeals(
          date: date,
          breakfast: pick(0),
          lunch: pick(1),
          dinner: pick(2),
        );
      }
    }
  }

  String _keyFor(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  // ✨ joyful colors for meal status
  Color _statusColor(MealStatus s) {
    switch (s) {
      case MealStatus.allPlate:
        return ColorsManager.accentMint; // happy green
      case MealStatus.mostPlate:
        return ColorsManager.accentSky; // soft blue
      case MealStatus.tasted:
        return ColorsManager.accentSun; // warm yellow/orange
      case MealStatus.none:
        return ColorsManager.accentCoral; // friendly red
    }
  }

  String _statusLabel(MealStatus s) {
    switch (s) {
      case MealStatus.allPlate:
        return 'All Plate';
      case MealStatus.mostPlate:
        return 'Most of the Plate';
      case MealStatus.tasted:
        return 'Tasted his meal only';
      case MealStatus.none:
        return 'None';
    }
  }

  String _statusEmoji(MealStatus s) {
    switch (s) {
      case MealStatus.allPlate:
        return '🍽️';
      case MealStatus.mostPlate:
        return '🍛';
      case MealStatus.tasted:
        return '👅';
      case MealStatus.none:
        return '🚫';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentPurple = ColorsManager.accentPurple;

    return SafeArea(
      top: false, // content directly under app bar
      child: TweenAnimationBuilder<double>(
        // ✅ animate from 0 → 1 and clamp before Opacity
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          final double t = value.clamp(0.0, 1.0);
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, (1 - t) * 10),
              child: child,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Guide — LIQUID GLASS FROSTED CARD
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Stack(
                  children: [
                    // blurred background behind the glass
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        // container is intentionally empty - blur applies to background content
                        color: Colors.transparent,
                        width: double.infinity,
                        height: null,
                      ),
                    ),

                    // the actual glass card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        // subtle frosted color that adapts to theme
                        color:
                            isLight
                                ? Colors.white.withOpacity(0.18)
                                : Colors.black.withOpacity(0.26),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color:
                              isLight
                                  ? Colors.white.withOpacity(0.12)
                                  : Colors.white.withOpacity(0.06),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                isLight
                                    ? primaryBlue.withOpacity(0.06)
                                    : Colors.black.withOpacity(0.5),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors:
                              isLight
                                  ? [
                                    Colors.white.withOpacity(0.12),
                                    Colors.white.withOpacity(0.06),
                                  ]
                                  : [
                                    Colors.black.withOpacity(0.22),
                                    Colors.black.withOpacity(0.12),
                                  ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // subtle inner highlight bar to create "liquid" surface
                          Container(
                            height: 4.h,
                            margin: EdgeInsets.only(bottom: 10.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999.r),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors:
                                    isLight
                                        ? [
                                          Colors.white.withOpacity(0.35),
                                          Colors.white.withOpacity(0.05),
                                        ]
                                        : [
                                          Colors.white.withOpacity(0.12),
                                          Colors.white.withOpacity(0.03),
                                        ],
                              ),
                            ),
                          ),

                          Text(
                            'Meal Rating Guide',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color:
                                  isLight
                                      ? Colors.black87
                                      : Colors.white.withOpacity(0.95),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          _guideRow(
                            MealStatus.allPlate,
                            'All Plate: Student ate everything served',
                          ),
                          SizedBox(height: 6.h),
                          _guideRow(
                            MealStatus.mostPlate,
                            'Most of the Plate: Student ate half the meal',
                          ),
                          SizedBox(height: 6.h),
                          _guideRow(
                            MealStatus.tasted,
                            'Tasted his meal only: Student tried a few bites',
                          ),
                          SizedBox(height: 6.h),
                          _guideRow(
                            MealStatus.none,
                            'None: Student didn\'t eat at all',
                          ),
                        ],
                      ),
                    ),

                    // faint glossy reflection in top-right to enhance liquid effect
                    Positioned(
                      right: 8.w,
                      top: 8.h,
                      child: Container(
                        width: 56.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999.r),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors:
                                isLight
                                    ? [
                                      Colors.white.withOpacity(0.24),
                                      Colors.white.withOpacity(0.06),
                                    ]
                                    : [
                                      Colors.white.withOpacity(0.10),
                                      Colors.white.withOpacity(0.02),
                                    ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Months tab bar
            SizedBox(
              height: 52.h,
              child: TabBar(
                controller: _monthsController,
                isScrollable: true,
                indicatorPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 6.h,
                ),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                    colors: [
                      primaryBlue.withOpacity(0.14),
                      accentSky.withOpacity(0.16),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                labelColor: accentPurple,
                unselectedLabelColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.7),
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
                tabs:
                    _months.map((m) {
                      final label = DateFormat.yMMM().format(m);
                      return Tab(text: label);
                    }).toList(),
                onTap: (idx) {
                  setState(() {
                    _selectedMonth = _months[idx];
                  });
                },
              ),
            ),

            // Calendar area
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                child: _buildCalendarForMonth(
                  context,
                  _selectedMonth,
                  primaryBlue,
                  accentSun,
                  accentSky,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guideRow(MealStatus s, String text) {
    final color = _statusColor(s);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.9, end: 1.0),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              gradient: LinearGradient(
                colors: [color.withOpacity(0.18), color.withOpacity(0.10)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: color.withOpacity(0.9)),
            ),
            child: Center(
              child: Text(_statusEmoji(s), style: TextStyle(fontSize: 18.sp)),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withOpacity(0.95),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarForMonth(
    BuildContext context,
    DateTime month,
    Color primaryBlue,
    Color accentSun,
    Color accentSky,
  ) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstWeekday = first.weekday; // 1 = Mon, 7 = Sun

    // display weeks starting from Sunday
    final int leadingEmpty = (firstWeekday % 7); // sunday->0, monday->1, ...
    final totalCells = leadingEmpty + daysInMonth;
    final paddingToFullWeeks = (7 - (totalCells % 7)) % 7;

    final Color surface = Theme.of(context).colorScheme.surface;

    return Column(
      children: [
        // Weekday labels (no extra vertical spacing)
        Row(
          children: List.generate(7, (i) {
            final labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
            return Expanded(
              child: Center(
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 6.h),

        // Grid calendar
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                colors: [
                  surface.withOpacity(0.98),
                  accentSky.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: primaryBlue.withOpacity(0.10)),
            ),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 6.w,
                crossAxisSpacing: 6.w,
                childAspectRatio: 0.68,
              ),
              itemCount: totalCells + paddingToFullWeeks,
              itemBuilder: (context, index) {
                final dayNumber = index - leadingEmpty + 1;
                final isValidDay = dayNumber >= 1 && dayNumber <= daysInMonth;
                if (!isValidDay) return const SizedBox.shrink();

                final dayDate = DateTime(month.year, month.month, dayNumber);
                final key = _keyFor(dayDate);
                final dayMeals = _mockData[key];

                Color? indicator;
                if (dayMeals != null) {
                  if (dayMeals.breakfast == MealStatus.none ||
                      dayMeals.lunch == MealStatus.none ||
                      dayMeals.dinner == MealStatus.none) {
                    indicator = _statusColor(MealStatus.none);
                  } else if (dayMeals.breakfast == MealStatus.allPlate &&
                      dayMeals.lunch == MealStatus.allPlate &&
                      dayMeals.dinner == MealStatus.allPlate) {
                    indicator = _statusColor(MealStatus.allPlate);
                  } else {
                    indicator = _statusColor(MealStatus.mostPlate);
                  }
                }

                final today = DateTime.now();
                final bool isToday =
                    dayDate.year == today.year &&
                    dayDate.month == today.month &&
                    dayDate.day == today.day;

                return GestureDetector(
                  onTap: () => _onDayTap(dayDate),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      gradient:
                          isToday
                              ? LinearGradient(
                                colors: [
                                  primaryBlue.withOpacity(0.16),
                                  accentSun.withOpacity(0.18),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                              : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayNumber',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color:
                                isToday
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        if (indicator != null)
                          Container(
                            width: 12.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.r),
                              gradient: LinearGradient(
                                colors: [indicator, indicator.withOpacity(0.8)],
                              ),
                            ),
                          )
                        else
                          SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _onDayTap(DateTime day) {
    final key = _keyFor(day);
    final data =
        _mockData[key] ??
        DayMeals(
          date: day,
          breakfast: MealStatus.tasted,
          lunch: MealStatus.tasted,
          dinner: MealStatus.tasted,
        );

    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentCoral = ColorsManager.accentCoral;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return TweenAnimationBuilder<double>(
          // this one only scales, no opacity → safe
          tween: Tween(begin: 0.9, end: 1.0),
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.38,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            builder: (_, controller) {
              return SingleChildScrollView(
                controller: controller,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // handle
                    Center(
                      child: Container(
                        width: 48.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999.r),
                          gradient: LinearGradient(
                            colors: [primaryBlue, accentMint],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    Text(
                      DateFormat.yMMMMd().format(day),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: primaryBlue,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    _mealStatusRow('Breakfast', data.breakfast),
                    SizedBox(height: 10.h),
                    _mealStatusRow('Lunch', data.lunch),
                    SizedBox(height: 10.h),
                    _mealStatusRow('Dinner', data.dinner),
                    SizedBox(height: 18.h),

                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentCoral,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(
                            'Close',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _mealStatusRow(String label, MealStatus s) {
    final color = _statusColor(s);
    final emoji = _statusEmoji(s);
    final labelText = _statusLabel(s);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Text(
            '$emoji  $labelText',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: color.withOpacity(0.95),
            ),
          ),
        ],
      ),
    );
  }
}
