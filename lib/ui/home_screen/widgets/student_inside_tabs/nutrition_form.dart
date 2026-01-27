// lib/ui/home_screen/widgets/student_inside_tabs/nutrition_form.dart
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/colors_Manager.dart';
import '../../../../core/reusable_components/app_background.dart';

enum BreakfastFreq { always, sometimes, never }

enum YesNo { no, yes }

enum SnackFeeling { snack, hungry }

enum RiceAmount { same, less, more }

enum EatingSpeed { fast, moderate, slow }

enum EatFruitDrink { eat, drink }

class NutritionForm extends StatefulWidget {
  const NutritionForm({super.key});

  @override
  State<NutritionForm> createState() => _NutritionFormState();
}

class _NutritionFormState extends State<NutritionForm> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _lastUpdate;

  // Edit mode flag + backup map
  bool _isEditing = false;
  final Map<String, dynamic> _backup = {};

  // Text controllers
  final TextEditingController _favoriteSnackController =
      TextEditingController();
  final TextEditingController _dislikedFoodsController =
      TextEditingController();
  final TextEditingController _cupsPerDayController = TextEditingController();
  BreakfastFreq? _breakfastFreq;

  // Snacking & night eating
  final TextEditingController _toastTypeController = TextEditingController();
  final TextEditingController _sugarTeaspoonsController =
      TextEditingController();
  RiceAmount? _riceAmount;
  YesNo? _eatBeforeSleep;
  YesNo? _isNightEater;
  SnackFeeling? _nightHungerOrSnack;
  String? _whenSnack; // "After breakfast" / "After lunch" / "Between both"

  // Sleep & eating
  final TextEditingController _avgSleepHoursController =
      TextEditingController();
  EatingSpeed? _eatingSpeed;

  // Vegetables & fruits
  final TextEditingController _vegFreqController = TextEditingController();
  final TextEditingController _vegListController = TextEditingController();
  final TextEditingController _fruitFreqController = TextEditingController();
  final TextEditingController _fruitListController = TextEditingController();
  EatFruitDrink? _eatOrDrinkFruit;
  final TextEditingController _candyController = TextEditingController();
  // Cooking fat - booleans
  bool _usesOil = false;
  bool _usesButter = false;
  bool _usesMargarine = false;

  @override
  void initState() {
    super.initState();
    _lastUpdate = DateTime.now();
    // sensible defaults
    _breakfastFreq = BreakfastFreq.always;
    _riceAmount = RiceAmount.same;
    _eatBeforeSleep = YesNo.no;
    _isNightEater = YesNo.no;
    _nightHungerOrSnack = SnackFeeling.snack;
    _eatingSpeed = EatingSpeed.moderate;
    _eatOrDrinkFruit = EatFruitDrink.eat;
    //_whenSnack = 'After breakfast';
    _cupsPerDayController.text = '0';
    _sugarTeaspoonsController.text = '0';
    _avgSleepHoursController.text = '8.0';
  }

  @override
  void dispose() {
    _favoriteSnackController.dispose();
    _dislikedFoodsController.dispose();
    _cupsPerDayController.dispose();
    _toastTypeController.dispose();
    _sugarTeaspoonsController.dispose();
    _avgSleepHoursController.dispose();
    _vegFreqController.dispose();
    _vegListController.dispose();
    _fruitFreqController.dispose();
    _fruitListController.dispose();
    _candyController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.98),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _sectionCard(Widget child) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color start =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final Color end =
        isLight
            ? ColorsManager.primaryGradientEnd
            : ColorsManager.primaryGradientEndDark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          colors: [start.withOpacity(0.08), end.withOpacity(0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: child,
    );
  }

  // ------------------- BACKUP / RESTORE -------------------
  void _backupValues() {
    _backup.clear();
    _backup['lastUpdate'] = _lastUpdate?.toIso8601String();
    _backup['favoriteSnack'] = _favoriteSnackController.text;
    _backup['dislikedFoods'] = _dislikedFoodsController.text;
    _backup['cupsPerDay'] = _cupsPerDayController.text;
    _backup['breakfastFreq'] = _breakfastFreq?.index;
    _backup['toastType'] = _toastTypeController.text;
    _backup['sugarTeaspoons'] = _sugarTeaspoonsController.text;
    _backup['riceAmount'] = _riceAmount?.index;
    _backup['eatBeforeSleep'] = _eatBeforeSleep?.index;
    _backup['isNightEater'] = _isNightEater?.index;
    _backup['nightHungerOrSnack'] = _nightHungerOrSnack?.index;
    _backup['whenSnack'] = _whenSnack;
    _backup['avgSleepHours'] = _avgSleepHoursController.text;
    _backup['eatingSpeed'] = _eatingSpeed?.index;
    _backup['vegFreq'] = _vegFreqController.text;
    _backup['vegList'] = _vegListController.text;
    _backup['fruitFreq'] = _fruitFreqController.text;
    _backup['fruitList'] = _fruitListController.text;
    _backup['eatOrDrinkFruit'] = _eatOrDrinkFruit?.index;
    _backup['candy'] = _candyController.text;
    _backup['usesOil'] = _usesOil;
    _backup['usesButter'] = _usesButter;
    _backup['usesMargarine'] = _usesMargarine;
  }

  void _restoreBackup() {
    setState(() {
      _lastUpdate =
          _backup['lastUpdate'] != null
              ? DateTime.tryParse(_backup['lastUpdate'])
              : _lastUpdate;
      _favoriteSnackController.text = _backup['favoriteSnack'] ?? '';
      _dislikedFoodsController.text = _backup['dislikedFoods'] ?? '';
      _cupsPerDayController.text = _backup['cupsPerDay'] ?? '0';
      _breakfastFreq =
          _backup['breakfastFreq'] != null
              ? BreakfastFreq.values[_backup['breakfastFreq'] as int]
              : _breakfastFreq;
      _toastTypeController.text = _backup['toastType'] ?? '';
      _sugarTeaspoonsController.text = _backup['sugarTeaspoons'] ?? '0';
      _riceAmount =
          _backup['riceAmount'] != null
              ? RiceAmount.values[_backup['riceAmount'] as int]
              : _riceAmount;
      _eatBeforeSleep =
          _backup['eatBeforeSleep'] != null
              ? YesNo.values[_backup['eatBeforeSleep'] as int]
              : _eatBeforeSleep;
      _isNightEater =
          _backup['isNightEater'] != null
              ? YesNo.values[_backup['isNightEater'] as int]
              : _isNightEater;
      _nightHungerOrSnack =
          _backup['nightHungerOrSnack'] != null
              ? SnackFeeling.values[_backup['nightHungerOrSnack'] as int]
              : _nightHungerOrSnack;
      _whenSnack = _backup['whenSnack'] ?? _whenSnack;
      _avgSleepHoursController.text =
          _backup['avgSleepHours'] ?? _avgSleepHoursController.text;
      _eatingSpeed =
          _backup['eatingSpeed'] != null
              ? EatingSpeed.values[_backup['eatingSpeed'] as int]
              : _eatingSpeed;
      _vegFreqController.text = _backup['vegFreq'] ?? '';
      _vegListController.text = _backup['vegList'] ?? '';
      _fruitFreqController.text = _backup['fruitFreq'] ?? '';
      _fruitListController.text = _backup['fruitList'] ?? '';
      _eatOrDrinkFruit =
          _backup['eatOrDrinkFruit'] != null
              ? EatFruitDrink.values[_backup['eatOrDrinkFruit'] as int]
              : _eatOrDrinkFruit;
      _candyController.text = _backup['candy'] ?? '';
      _usesOil = _backup['usesOil'] ?? false;
      _usesButter = _backup['usesButter'] ?? false;
      _usesMargarine = _backup['usesMargarine'] ?? false;
    });
  }

  // Enter/Cancel/Save helpers
  void _enterEditMode() {
    _backupValues();
    setState(() => _isEditing = true);
  }

  void _cancelEditMode() {
    _restoreBackup();
    setState(() => _isEditing = false);
  }

  void _saveAndExit() {
    _saveForm();
    setState(() => _isEditing = false);
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please_fix_errors'.tr()),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final payload = {
      'lastUpdate': DateTime.now().toIso8601String(),
      'favoriteSnack': _favoriteSnackController.text.trim(),
      'dislikedFoods': _dislikedFoodsController.text.trim(),
      'drinksWater':
          (_cupsPerDayController.text.trim().isNotEmpty &&
              int.tryParse(_cupsPerDayController.text.trim()) != null),
      'cupsPerDay': int.tryParse(_cupsPerDayController.text.trim()) ?? 0,
      'breakfastFreq': _breakfastFreq?.name,
      'toastType': _toastTypeController.text.trim(),
      'sugarTeaspoonsPerDay':
          int.tryParse(_sugarTeaspoonsController.text.trim()) ?? 0,
      'riceAmount': _riceAmount?.name,
      'eatBeforeSleep': _eatBeforeSleep?.name,
      'isNightEater': _isNightEater?.name,
      'nightHungerOrSnack': _nightHungerOrSnack?.name,
      'whenSnack': _whenSnack,
      'avgSleepHours':
          double.tryParse(_avgSleepHoursController.text.trim()) ?? 0.0,
      'eatingSpeed': _eatingSpeed?.name,
      'vegFreq': _vegFreqController.text.trim(),
      'vegList': _vegListController.text.trim(),
      'fruitFreq': _fruitFreqController.text.trim(),
      'fruitList': _fruitListController.text.trim(),
      'eatOrDrinkFruit': _eatOrDrinkFruit?.name,
      'candy': _candyController.text.trim(),
      'usesOil': _usesOil,
      'usesButter': _usesButter,
      'usesMargarine': _usesMargarine,
    };

    // for now print and show snackbar. Replace with API or local DB save later.
    // ignore: avoid_print
    print('Nutrition form saved: $payload');

    setState(() {
      _lastUpdate = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('nutrition_form_saved'.tr()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // wrapper to disable interaction when not editing
  Widget _editableWrapper({required Widget child}) {
    return AbsorbPointer(
      absorbing: !_isEditing,
      child: Opacity(opacity: _isEditing ? 1.0 : 0.98, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lastUpdateDisplay =
        _lastUpdate != null
            ? DateFormat.yMd().add_jms().format(_lastUpdate!)
            : '—';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'nutrition_form'.tr(),
          style: const TextStyle(color: Colors.black),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withOpacity(0.85)),
          ),
        ),
        actions: [
          // keep save icon but active only when editing
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black87),
            onPressed: _isEditing ? _saveAndExit : null,
          ),
        ],
      ),
      body: AppBackground(
        useAppBarBlur: false,
        child: SafeArea(
          top: false,
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: Colors.black.withOpacity(0.03)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // header with last update and edit controls
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'last_update'.tr(),
                                    style: TextStyle(fontSize: 11.sp),
                                  ),
                                  Text(
                                    lastUpdateDisplay,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            if (!_isEditing)
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: ColorsManager.accentPurple,
                                ),
                                tooltip: 'edit'.tr(),
                                onPressed: _enterEditMode,
                              )
                            else ...[
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.redAccent,
                                ),
                                tooltip: 'cancel'.tr(),
                                onPressed: _cancelEditMode,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.check,
                                  color: ColorsManager.accentMint,
                                ),
                                tooltip: 'save'.tr(),
                                onPressed: _saveAndExit,
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 12.h),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader('food_preferences'.tr()),
                                _editableWrapper(
                                  child: _sectionCard(
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller: _favoriteSnackController,
                                          decoration: _inputDecoration(
                                            'favorite_snack'.tr(),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        TextFormField(
                                          controller: _dislikedFoodsController,
                                          decoration: _inputDecoration(
                                            'disliked_foods'.tr(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                _sectionHeader('water_breakfast'.tr()),
                                _editableWrapper(
                                  child: _sectionCard(
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: TextFormField(
                                                controller:
                                                    _cupsPerDayController,
                                                decoration: _inputDecoration(
                                                  'cups_per_day'.tr(),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              flex: 5,
                                              child: DropdownButtonFormField<
                                                BreakfastFreq
                                              >(
                                                isExpanded: true,
                                                initialValue: _breakfastFreq,
                                                decoration: _inputDecoration(
                                                  'breakfast_question'.tr(),
                                                ),
                                                items:
                                                    BreakfastFreq.values.map((
                                                      f,
                                                    ) {
                                                      final label =
                                                          {
                                                            BreakfastFreq
                                                                    .always:
                                                                'always'.tr(),
                                                            BreakfastFreq
                                                                    .sometimes:
                                                                'sometimes'.tr(),
                                                            BreakfastFreq.never:
                                                                'never'.tr(),
                                                          }[f]!;
                                                      return DropdownMenuItem(
                                                        value: f,
                                                        child: Text(label),
                                                      );
                                                    }).toList(),
                                                onChanged:
                                                    _isEditing
                                                        ? (
                                                          BreakfastFreq? v,
                                                        ) => setState(
                                                          () =>
                                                              _breakfastFreq =
                                                                  v,
                                                        )
                                                        : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                _sectionHeader('snacking_night_eating'.tr()),
                                _editableWrapper(
                                  child: _sectionCard(
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller: _toastTypeController,
                                          decoration: _inputDecoration(
                                            'toast_type'.tr(),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller:
                                                    _sugarTeaspoonsController,
                                                decoration: _inputDecoration(
                                                  'sugar_teaspoons_per_day'.tr(),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: DropdownButtonFormField<
                                                RiceAmount
                                              >(
                                                isExpanded: true,
                                                initialValue: _riceAmount,
                                                decoration: _inputDecoration(
                                                  'rice_amount'.tr(),
                                                ),
                                                items:
                                                    RiceAmount.values.map((r) {
                                                      final label =
                                                          {
                                                            RiceAmount.same:
                                                                'same'.tr(),
                                                            RiceAmount.less:
                                                                'less'.tr(),
                                                            RiceAmount.more:
                                                                'more'.tr(),
                                                          }[r]!;
                                                      return DropdownMenuItem(
                                                        value: r,
                                                        child: Text(label),
                                                      );
                                                    }).toList(),
                                                onChanged:
                                                    _isEditing
                                                        ? (
                                                          RiceAmount? v,
                                                        ) => setState(
                                                          () => _riceAmount = v,
                                                        )
                                                        : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: DropdownButtonFormField<
                                                YesNo
                                              >(
                                                isExpanded: true,
                                                initialValue: _eatBeforeSleep,
                                                decoration: _inputDecoration(
                                                  'eat_before_sleep'.tr(),
                                                ),
                                                items:
                                                    YesNo.values
                                                        .map(
                                                          (y) =>
                                                              DropdownMenuItem(
                                                                value: y,
                                                                child: Text(
                                                                  y == YesNo.yes
                                                                      ? 'yes'.tr()
                                                                      : 'no'.tr(),
                                                                ),
                                                              ),
                                                        )
                                                        .toList(),
                                                onChanged:
                                                    _isEditing
                                                        ? (
                                                          YesNo? v,
                                                        ) => setState(
                                                          () =>
                                                              _eatBeforeSleep =
                                                                  v,
                                                        )
                                                        : null,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: DropdownButtonFormField<
                                                YesNo
                                              >(
                                                isExpanded: true,
                                                initialValue: _isNightEater,
                                                decoration: _inputDecoration(
                                                  'night_eater'.tr(),
                                                ),
                                                items:
                                                    YesNo.values
                                                        .map(
                                                          (y) =>
                                                              DropdownMenuItem(
                                                                value: y,
                                                                child: Text(
                                                                  y == YesNo.yes
                                                                      ? 'yes'.tr()
                                                                      : 'no'.tr(),
                                                                ),
                                                              ),
                                                        )
                                                        .toList(),
                                                onChanged:
                                                    _isEditing
                                                        ? (
                                                          YesNo? v,
                                                        ) => setState(
                                                          () =>
                                                              _isNightEater = v,
                                                        )
                                                        : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: DropdownButtonFormField<
                                                SnackFeeling
                                              >(
                                                isExpanded: true,
                                                initialValue:
                                                    _nightHungerOrSnack,
                                                decoration: _inputDecoration(
                                                  'night_feeling'.tr(),
                                                ),
                                                items:
                                                    SnackFeeling.values
                                                        .map(
                                                          (
                                                            s,
                                                          ) => DropdownMenuItem(
                                                            value: s,
                                                            child: Text(
                                                              s ==
                                                                      SnackFeeling
                                                                          .snack
                                                                  ? 'snack'.tr()
                                                                  : 'hungry'.tr(),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                onChanged:
                                                    _isEditing
                                                        ? (
                                                          SnackFeeling? v,
                                                        ) => setState(
                                                          () =>
                                                              _nightHungerOrSnack =
                                                                  v,
                                                        )
                                                        : null,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: DropdownButtonFormField<
                                                String
                                              >(
                                                isExpanded: true,
                                                initialValue: _whenSnack,
                                                decoration: _inputDecoration(
                                                  'when_snack'.tr(),
                                                ),
                                                items:
                                                    [
                                                          'after_breakfast'.tr(),
                                                          'after_lunch'.tr(),
                                                          'between_both'.tr(),
                                                        ]
                                                        .map(
                                                          (s) =>
                                                              DropdownMenuItem(
                                                                value: s,
                                                                child: Text(s),
                                                              ),
                                                        )
                                                        .toList(),
                                                onChanged:
                                                    _isEditing
                                                        ? (
                                                          String? v,
                                                        ) => setState(
                                                          () => _whenSnack = v,
                                                        )
                                                        : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                _sectionHeader('sleep_eating'.tr()),
                                _editableWrapper(
                                  child: _sectionCard(
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: TextFormField(
                                                controller:
                                                    _avgSleepHoursController,
                                                decoration: _inputDecoration(
                                                  'average_sleep'.tr(),
                                                ),
                                                keyboardType:
                                                    TextInputType.numberWithOptions(
                                                      decimal: true,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              flex: 4,
                                              child: DropdownButtonFormField<
                                                EatingSpeed
                                              >(
                                                isExpanded: true,
                                                initialValue: _eatingSpeed,
                                                decoration: _inputDecoration(
                                                  'eating_speed'.tr(),
                                                ),
                                                items:
                                                    EatingSpeed.values.map((e) {
                                                      final label =
                                                          {
                                                            EatingSpeed.fast:
                                                                'fast'.tr(),
                                                            EatingSpeed
                                                                    .moderate:
                                                                'moderate'.tr(),
                                                            EatingSpeed.slow:
                                                                'slow'.tr(),
                                                          }[e]!;
                                                      return DropdownMenuItem(
                                                        value: e,
                                                        child: Text(label),
                                                      );
                                                    }).toList(),
                                                onChanged:
                                                    _isEditing
                                                        ? (EatingSpeed? v) =>
                                                            setState(
                                                              () =>
                                                                  _eatingSpeed =
                                                                      v,
                                                            )
                                                        : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                _sectionHeader('vegetables_fruits'.tr()),
                                _editableWrapper(
                                  child: _sectionCard(
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller: _vegFreqController,
                                          decoration: _inputDecoration(
                                            'veg_freq'.tr(),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        TextFormField(
                                          controller: _vegListController,
                                          decoration: _inputDecoration(
                                            'veg_list'.tr(),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        TextFormField(
                                          controller: _fruitFreqController,
                                          decoration: _inputDecoration(
                                            'fruit_freq'.tr(),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        TextFormField(
                                          controller: _fruitListController,
                                          decoration: _inputDecoration(
                                            'fruit_list'.tr(),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        DropdownButtonFormField<EatFruitDrink>(
                                          isExpanded: true,
                                          initialValue: _eatOrDrinkFruit,
                                          decoration: _inputDecoration(
                                            'eat_or_drink_fruit'.tr(),
                                          ),
                                          items:
                                              EatFruitDrink.values.map((v) {
                                                final label =
                                                    v == EatFruitDrink.eat
                                                        ? 'eat'.tr()
                                                        : 'drink'.tr();
                                                return DropdownMenuItem(
                                                  value: v,
                                                  child: Text(label),
                                                );
                                              }).toList(),
                                          onChanged:
                                              _isEditing
                                                  ? (
                                                    EatFruitDrink? v,
                                                  ) => setState(
                                                    () => _eatOrDrinkFruit = v,
                                                  )
                                                  : null,
                                        ),
                                        SizedBox(height: 8.h),
                                        TextFormField(
                                          controller: _candyController,
                                          decoration: _inputDecoration(
                                            'candy'.tr(),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),

                                        // cooking fat checkboxes (respect edit mode)
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 4.h,
                                            ),
                                            child: Wrap(
                                              spacing: 12.w,
                                              runSpacing: 6.h,
                                              children: [
                                                _smallCheckboxLabel(
                                                  label: 'oil'.tr(),
                                                  value: _usesOil,
                                                  onChanged: (v) {
                                                    if (!_isEditing) return;
                                                    setState(
                                                      () => _usesOil = v,
                                                    );
                                                  },
                                                ),
                                                _smallCheckboxLabel(
                                                  label: 'butter'.tr(),
                                                  value: _usesButter,
                                                  onChanged: (v) {
                                                    if (!_isEditing) return;
                                                    setState(
                                                      () => _usesButter = v,
                                                    );
                                                  },
                                                ),
                                                _smallCheckboxLabel(
                                                  label: 'margarine'.tr(),
                                                  value: _usesMargarine,
                                                  onChanged: (v) {
                                                    if (!_isEditing) return;
                                                    setState(
                                                      () => _usesMargarine = v,
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 16.h),
                                // Save / Cancel at bottom — active only while editing
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 14.h,
                                          ),
                                          side: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                          backgroundColor:
                                              Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                        ),
                                        onPressed:
                                            () => Navigator.of(context).pop(),
                                        child: Text(
                                          'cancel'.tr(),
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 14.h,
                                          ),
                                          backgroundColor:
                                              _isEditing
                                                  ? ColorsManager.accentMint
                                                  : Colors.grey.shade400,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                          elevation: 2,
                                        ),
                                        onPressed:
                                            _isEditing ? _saveAndExit : null,
                                        child: Text(
                                          'Save',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 24.h),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // helper small horizontal checkbox + label widget
  Widget _smallCheckboxLabel({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!_isEditing ? value : !value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.w,
            child: Checkbox(
              value: value,
              onChanged: _isEditing ? (v) => onChanged(v ?? false) : null,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          SizedBox(width: 6.w),
          Text(label, style: TextStyle(fontSize: 13.sp)),
        ],
      ),
    );
  }
}
