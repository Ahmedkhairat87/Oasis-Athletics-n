import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/colors_Manager.dart';
import '../../../../../core/model/stdLinks/nutrationForm/NutrationDataModel.dart';
import '../../../../../core/model/stdLinks/nutrationForm/NutrationGeneral.dart';
import '../../../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../../../core/reusable_components/app_background.dart';
import '../../../../../core/services/stdProfile/nutrationForm/StdNutrationFormService.dart';
import '../../../../../core/services/stdProfile/nutrationForm/StdNutrationFormUpdateService.dart';
import 'forms/medical_form/medical_form_helpers.dart';

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
  bool _loading = true;
  String? _error;

  num? _recordId;
  num? _studentId;

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

    _loadForm();
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

  InputDecoration _baseInputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.98),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return _baseInputDecoration().copyWith(labelText: label);
  }

  InputDecoration _inputDecorationNoLabel() {
    return _baseInputDecoration().copyWith(
      labelText: null,
      label: null,
      floatingLabelBehavior: FloatingLabelBehavior.never,
    );
  }

  Widget _fieldLabel(String text) {
    return SizedBox(
      height: 28.h,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.sp,
              height: 1.15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _labeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_fieldLabel(label), child],
    );
  }

  String _s(dynamic v) => (v ?? '').toString().trim();

  bool _toBool(dynamic v) {
    if (v is bool) return v;
    final s = _s(v).toLowerCase();
    return s == '1' || s == 'true' || s == 'yes';
  }

  BreakfastFreq? _breakfastFromApi(String? v) {
    final s = _s(v).toLowerCase();
    if (s == 'always') return BreakfastFreq.always;
    if (s == 'sometimes') return BreakfastFreq.sometimes;
    if (s == 'never') return BreakfastFreq.never;
    return null;
  }

  String _breakfastToApi(BreakfastFreq? v) {
    switch (v) {
      case BreakfastFreq.always:
        return 'Always';
      case BreakfastFreq.sometimes:
        return 'Sometimes';
      case BreakfastFreq.never:
        return 'Never';
      default:
        return '';
    }
  }

  RiceAmount? _riceFromApi(String? v) {
    final s = _s(v).toLowerCase();
    if (s == 'same') return RiceAmount.same;
    if (s == 'less') return RiceAmount.less;
    if (s == 'more') return RiceAmount.more;
    return null;
  }

  String _riceToApi(RiceAmount? v) {
    switch (v) {
      case RiceAmount.same:
        return 'Same';
      case RiceAmount.less:
        return 'Less';
      case RiceAmount.more:
        return 'More';
      default:
        return '';
    }
  }

  YesNo? _yesNoFromBool(bool? v) {
    if (v == null) return null;
    return v ? YesNo.yes : YesNo.no;
  }

  bool _yesNoToBool(YesNo? v) => v == YesNo.yes;

  SnackFeeling? _snackFeelingFromApi(String? v) {
    final s = _s(v).toLowerCase();
    if (s == 'hungry') return SnackFeeling.hungry;
    if (s == 'snack') return SnackFeeling.snack;
    return null;
  }

  String _snackFeelingToApi(SnackFeeling? v) {
    switch (v) {
      case SnackFeeling.hungry:
        return 'Hungry';
      case SnackFeeling.snack:
        return 'Snack';
      default:
        return '';
    }
  }

  EatingSpeed? _eatingSpeedFromApi(String? v) {
    final s = _s(v).toLowerCase();
    if (s == 'fast') return EatingSpeed.fast;
    if (s == 'moderate') return EatingSpeed.moderate;
    if (s == 'slow') return EatingSpeed.slow;
    return null;
  }

  String _eatingSpeedToApi(EatingSpeed? v) {
    switch (v) {
      case EatingSpeed.fast:
        return 'Fast';
      case EatingSpeed.moderate:
        return 'Moderate';
      case EatingSpeed.slow:
        return 'Slow';
      default:
        return '';
    }
  }

  EatFruitDrink? _eatFruitDrinkFromApi(String? v) {
    final s = _s(v).toLowerCase();
    if (s == 'eat') return EatFruitDrink.eat;
    if (s == 'drink') return EatFruitDrink.drink;
    return null;
  }

  String _eatFruitDrinkToApi(EatFruitDrink? v) {
    switch (v) {
      case EatFruitDrink.eat:
        return 'Eat';
      case EatFruitDrink.drink:
        return 'Drink';
      default:
        return '';
    }
  }

  String? _snackKeyFromApi(String? v) {
    final s = _s(v).toLowerCase();
    if (s.contains('breakfast')) return 'after_breakfast';
    if (s.contains('lunch')) return 'after_lunch';
    if (s.contains('between')) return 'between_both';
    return null;
  }

  String _snackTimeToApi(String? key) {
    switch (key) {
      case 'after_breakfast':
        return 'After breakfast';
      case 'after_lunch':
        return 'After lunch';
      case 'between_both':
        return 'Between both';
      default:
        return '';
    }
  }

  void _applyCookingWith(String? v) {
    final parts =
        _s(v).split(',').map((e) => e.trim().toLowerCase()).toSet();
    _usesOil = parts.contains('oil');
    _usesButter = parts.contains('butter');
    _usesMargarine = parts.contains('margarine');
  }

  String _buildCookingWith() {
    final values = <String>[];
    if (_usesOil) values.add('Oil');
    if (_usesButter) values.add('Butter');
    if (_usesMargarine) values.add('Margarine');
    return values.join(',');
  }

  Future<void> _loadForm() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final stdId = studentNotifier.value.stdId.toString();
    final data = await StdNutrationFormService.getNutrationForm(stdId: stdId);

    if (!mounted) return;

    if (data == null) {
      setState(() {
        _loading = false;
        _error = 'Failed to load nutrition form.';
      });
      return;
    }

    setState(() {
      _assignApiToUi(data);
      _loading = false;
    });
  }

  void _assignApiToUi(NutrationDataModel data) {
    final list = data.nutrationGeneral ?? [];
    NutrationGeneral? form = list.isNotEmpty ? list.first : null;

    if (form == null) return;

    _recordId = form.recordID;
    _studentId = form.studentID;

    _favoriteSnackController.text = _s(form.favoriteSnack);
    _dislikedFoodsController.text = _s(form.dislikedFood);
    _cupsPerDayController.text = _s(form.waterCups);
    _breakfastFreq = _breakfastFromApi(form.breakfastHabit) ?? _breakfastFreq;

    _toastTypeController.text = _s(form.bread);
    _sugarTeaspoonsController.text = _s(form.sugarTeaspoons);
    _riceAmount = _riceFromApi(form.riceAmount) ?? _riceAmount;
    _eatBeforeSleep =
        _yesNoFromBool(_toBool(form.eatBeforeSleep)) ?? _eatBeforeSleep;
    _isNightEater = _yesNoFromBool(_toBool(form.nightEater)) ?? _isNightEater;
    _nightHungerOrSnack =
        _snackFeelingFromApi(form.hungerOrSnack) ?? _nightHungerOrSnack;
    _whenSnack = _snackKeyFromApi(form.snackTime) ?? _whenSnack;

    _avgSleepHoursController.text = _s(form.sleepHours);
    _eatingSpeed = _eatingSpeedFromApi(form.eatingSpeed) ?? _eatingSpeed;

    _vegFreqController.text = _s(form.vegetablesFreq);
    _vegListController.text = _s(form.vegetablesDetail);
    _fruitFreqController.text = _s(form.fruitsFreq);
    _fruitListController.text = _s(form.fruitsDetail);
    _eatOrDrinkFruit =
        _eatFruitDrinkFromApi(form.fruitForm) ?? _eatOrDrinkFruit;
    _candyController.text = _s(form.candy);
    _applyCookingWith(form.cookingWith);

    _lastUpdate =
        DateTime.tryParse(form.updatedAt ?? '') ??
        DateTime.tryParse(form.createdAt ?? '');
  }

  Widget _sectionHeader(String title) {
    return sectionHeader(title);
  }

  Widget _sectionCard(Widget child) {
    return sectionCard(context, child);
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
    _saveForm().then((ok) {
      if (ok && mounted) {
        setState(() => _isEditing = false);
      }
    });
  }

  Future<bool> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please_fix_errors'.tr()),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    final cups =
        int.tryParse(_cupsPerDayController.text.trim()) ?? 0;
    final sugar =
        int.tryParse(_sugarTeaspoonsController.text.trim()) ?? 0;
    final sleepHours =
        double.tryParse(_avgSleepHoursController.text.trim()) ?? 0.0;

    final payload = <String, dynamic>{
      'FavoriteSnack': _favoriteSnackController.text.trim(),
      'DislikedFood': _dislikedFoodsController.text.trim(),
      'WaterDrink': cups > 0,
      'WaterCups': cups,
      'BreakfastHabit': _breakfastToApi(_breakfastFreq),
      'Bread': _toastTypeController.text.trim(),
      'SugarTeaspoons': sugar,
      'RiceAmount': _riceToApi(_riceAmount),
      'EatBeforeSleep': _yesNoToBool(_eatBeforeSleep),
      'NightEater': _yesNoToBool(_isNightEater),
      'HungerOrSnack': _snackFeelingToApi(_nightHungerOrSnack),
      'SnackTime': _snackTimeToApi(_whenSnack),
      'SleepHours': sleepHours,
      'EatingSpeed': _eatingSpeedToApi(_eatingSpeed),
      'VegetablesFreq': _vegFreqController.text.trim(),
      'VegetablesDetail': _vegListController.text.trim(),
      'FruitsFreq': _fruitFreqController.text.trim(),
      'FruitsDetail': _fruitListController.text.trim(),
      'FruitForm': _eatFruitDrinkToApi(_eatOrDrinkFruit),
      'Candy': _candyController.text.trim(),
      'CookingWith': _buildCookingWith(),
    };

    if (_recordId != null) payload['RecordID'] = _recordId;
    if (_studentId != null) payload['StudentID'] = _studentId;

    setState(() {
      _loading = true;
      _error = null;
    });

    final ok = await StdNutrationFormUpdateService.updateNutrationForm(
      stdId: studentNotifier.value.stdId.toString(),
      payload: payload,
    );

    if (!mounted) return false;

    setState(() {
      _loading = false;
      if (ok) {
        _lastUpdate = DateTime.now();
      } else {
        _error = 'Failed to save nutrition form.';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'nutrition_form_saved'.tr() : 'Failed to save nutrition form.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

    return ok;
  }

  // wrapper to disable interaction when not editing
  Widget _editableWrapper({required Widget child}) {
    return editableWrapper(_isEditing, child);
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
        elevation: 0,
        centerTitle: true,
        title: Text(
          'nutrition_form'.tr(),
          style: const TextStyle(color: Colors.black),
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
        child: Stack(
          children: [
            SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
                                                  child: _labeledField(
                                                    label:
                                                        'cups_per_day'.tr(),
                                                    child: TextFormField(
                                                      controller:
                                                          _cupsPerDayController,
                                                      decoration:
                                                          _inputDecorationNoLabel(),
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                Expanded(
                                                  flex: 5,
                                                  child: _labeledField(
                                                    label:
                                                        'breakfast_question'
                                                            .tr(),
                                                    child:
                                                        DropdownButtonFormField<
                                                          BreakfastFreq
                                                        >(
                                                          isExpanded: true,
                                                          initialValue:
                                                              _breakfastFreq,
                                                          decoration:
                                                              _inputDecorationNoLabel(),
                                                          items:
                                                              BreakfastFreq
                                                                  .values
                                                                  .map((f) {
                                                                    final label =
                                                                        {
                                                                          BreakfastFreq
                                                                              .always:
                                                                              'always'
                                                                                  .tr(),
                                                                          BreakfastFreq
                                                                              .sometimes:
                                                                              'sometimes'
                                                                                  .tr(),
                                                                          BreakfastFreq
                                                                              .never:
                                                                              'never'
                                                                                  .tr(),
                                                                        }[f]!;
                                                                    return DropdownMenuItem(
                                                                      value: f,
                                                                      child: Text(
                                                                        label,
                                                                      ),
                                                                    );
                                                                  })
                                                                  .toList(),
                                                          onChanged:
                                                              _isEditing
                                                                  ? (
                                                                    BreakfastFreq?
                                                                    v,
                                                                  ) =>
                                                                      setState(
                                                                        () =>
                                                                            _breakfastFreq =
                                                                                v,
                                                                      )
                                                                  : null,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    _sectionHeader(
                                      'snacking_night_eating'.tr(),
                                    ),
                                    _editableWrapper(
                                      child: _sectionCard(
                                        Column(
                                          children: [
                                            TextFormField(
                                              controller:
                                                  _toastTypeController,
                                              decoration: _inputDecoration(
                                                'toast_type'.tr(),
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _labeledField(
                                                    label:
                                                        'sugar_teaspoons_per_day'
                                                            .tr(),
                                                    child: TextFormField(
                                                      controller:
                                                          _sugarTeaspoonsController,
                                                      decoration:
                                                          _inputDecorationNoLabel(),
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Expanded(
                                                  child: _labeledField(
                                                    label:
                                                        'rice_amount'.tr(),
                                                    child:
                                                        DropdownButtonFormField<
                                                          RiceAmount
                                                        >(
                                                          isExpanded: true,
                                                          initialValue:
                                                              _riceAmount,
                                                          decoration:
                                                              _inputDecorationNoLabel(),
                                                          items:
                                                              RiceAmount.values
                                                                  .map((r) {
                                                                    final label =
                                                                        {
                                                                          RiceAmount
                                                                              .same:
                                                                              'same'
                                                                                  .tr(),
                                                                          RiceAmount
                                                                              .less:
                                                                              'less'
                                                                                  .tr(),
                                                                          RiceAmount
                                                                              .more:
                                                                              'more'
                                                                                  .tr(),
                                                                        }[r]!;
                                                                    return DropdownMenuItem(
                                                                      value: r,
                                                                      child: Text(
                                                                        label,
                                                                      ),
                                                                    );
                                                                  })
                                                                  .toList(),
                                                          onChanged:
                                                              _isEditing
                                                                  ? (
                                                                    RiceAmount?
                                                                    v,
                                                                  ) =>
                                                                      setState(
                                                                        () =>
                                                                            _riceAmount =
                                                                                v,
                                                                      )
                                                                  : null,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _labeledField(
                                                    label:
                                                        'eat_before_sleep'.tr(),
                                                    child:
                                                        DropdownButtonFormField<
                                                          YesNo
                                                        >(
                                                          isExpanded: true,
                                                          initialValue:
                                                              _eatBeforeSleep,
                                                          decoration:
                                                              _inputDecorationNoLabel(),
                                                          items:
                                                              YesNo.values
                                                                  .map(
                                                                    (y) =>
                                                                        DropdownMenuItem(
                                                                          value:
                                                                              y,
                                                                          child:
                                                                              Text(
                                                                            y ==
                                                                                    YesNo
                                                                                        .yes
                                                                                ? 'yes'
                                                                                    .tr()
                                                                                : 'no'
                                                                                    .tr(),
                                                                          ),
                                                                        ),
                                                                  )
                                                                  .toList(),
                                                          onChanged:
                                                              _isEditing
                                                                  ? (YesNo? v) =>
                                                                      setState(
                                                                        () =>
                                                                            _eatBeforeSleep =
                                                                                v,
                                                                      )
                                                                  : null,
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Expanded(
                                                  child: _labeledField(
                                                    label: 'night_eater'.tr(),
                                                    child:
                                                        DropdownButtonFormField<
                                                          YesNo
                                                        >(
                                                          isExpanded: true,
                                                          initialValue:
                                                              _isNightEater,
                                                          decoration:
                                                              _inputDecorationNoLabel(),
                                                          items:
                                                              YesNo.values
                                                                  .map(
                                                                    (y) =>
                                                                        DropdownMenuItem(
                                                                          value:
                                                                              y,
                                                                          child:
                                                                              Text(
                                                                            y ==
                                                                                    YesNo
                                                                                        .yes
                                                                                ? 'yes'
                                                                                    .tr()
                                                                                : 'no'
                                                                                    .tr(),
                                                                          ),
                                                                        ),
                                                                  )
                                                                  .toList(),
                                                          onChanged:
                                                              _isEditing
                                                                  ? (YesNo? v) =>
                                                                      setState(
                                                                        () =>
                                                                            _isNightEater =
                                                                                v,
                                                                      )
                                                                  : null,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _labeledField(
                                                    label:
                                                        'night_feeling'.tr(),
                                                    child:
                                                        DropdownButtonFormField<
                                                          SnackFeeling
                                                        >(
                                                          isExpanded: true,
                                                          initialValue:
                                                              _nightHungerOrSnack,
                                                          decoration:
                                                              _inputDecorationNoLabel(),
                                                          items:
                                                              SnackFeeling
                                                                  .values
                                                                  .map(
                                                                    (s) =>
                                                                        DropdownMenuItem(
                                                                          value:
                                                                              s,
                                                                          child:
                                                                              Text(
                                                                            s ==
                                                                                    SnackFeeling
                                                                                        .snack
                                                                                ? 'snack'
                                                                                    .tr()
                                                                                : 'hungry'
                                                                                    .tr(),
                                                                          ),
                                                                        ),
                                                                  )
                                                                  .toList(),
                                                          onChanged:
                                                              _isEditing
                                                                  ? (SnackFeeling?
                                                                        v) =>
                                                                      setState(
                                                                        () =>
                                                                            _nightHungerOrSnack =
                                                                                v,
                                                                      )
                                                                  : null,
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Expanded(
                                                  child: _labeledField(
                                                    label: 'when_snack'.tr(),
                                                    child:
                                                        DropdownButtonFormField<
                                                          String
                                                        >(
                                                          isExpanded: true,
                                                          initialValue:
                                                              _whenSnack,
                                                          decoration:
                                                              _inputDecorationNoLabel(),
                                                          items:
                                                              {
                                                                'after_breakfast':
                                                                    'after_breakfast'
                                                                        .tr(),
                                                                'after_lunch':
                                                                    'after_lunch'
                                                                        .tr(),
                                                                'between_both':
                                                                    'between_both'
                                                                        .tr(),
                                                              }.entries
                                                                  .map((e) {
                                                                    return DropdownMenuItem(
                                                                      value:
                                                                          e.key,
                                                                      child: Text(
                                                                        e.value,
                                                                      ),
                                                                    );
                                                                  })
                                                                  .toList(),
                                                          onChanged:
                                                              _isEditing
                                                                  ? (
                                                                    String? v,
                                                                  ) =>
                                                                      setState(
                                                                        () =>
                                                                            _whenSnack =
                                                                                v,
                                                                      )
                                                                  : null,
                                                        ),
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
                                                  child: _labeledField(
                                                    label:
                                                        'average_sleep'.tr(),
                                                    child: TextFormField(
                                                      controller:
                                                          _avgSleepHoursController,
                                                      decoration:
                                                          _inputDecorationNoLabel(),
                                                      keyboardType:
                                                          const TextInputType
                                                              .numberWithOptions(
                                                            decimal: true,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                Expanded(
                                                  flex: 4,
                                                  child: _labeledField(
                                                    label:
                                                        'eating_speed'.tr(),
                                                    child:
                                                        DropdownButtonFormField<
                                                          EatingSpeed
                                                        >(
                                                          isExpanded: true,
                                                          initialValue:
                                                              _eatingSpeed,
                                                          decoration:
                                                              _inputDecorationNoLabel(),
                                                          items:
                                                              EatingSpeed.values
                                                                  .map((e) {
                                                                    final label =
                                                                        {
                                                                          EatingSpeed
                                                                              .fast:
                                                                              'fast'
                                                                                  .tr(),
                                                                          EatingSpeed
                                                                              .moderate:
                                                                              'moderate'
                                                                                  .tr(),
                                                                          EatingSpeed
                                                                              .slow:
                                                                              'slow'
                                                                                  .tr(),
                                                                        }[e]!;
                                                                    return DropdownMenuItem(
                                                                      value: e,
                                                                      child: Text(
                                                                        label,
                                                                      ),
                                                                    );
                                                                  })
                                                                  .toList(),
                                                          onChanged:
                                                              _isEditing
                                                                  ? (EatingSpeed?
                                                                        v) =>
                                                                      setState(
                                                                        () =>
                                                                            _eatingSpeed =
                                                                                v,
                                                                      )
                                                                  : null,
                                                        ),
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
                                            DropdownButtonFormField<
                                              EatFruitDrink
                                            >(
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
                                                        () =>
                                                            _eatOrDrinkFruit =
                                                                v,
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
                                                          () =>
                                                              _usesButter = v,
                                                        );
                                                      },
                                                    ),
                                                    _smallCheckboxLabel(
                                                      label: 'margarine'.tr(),
                                                      value: _usesMargarine,
                                                      onChanged: (v) {
                                                        if (!_isEditing) return;
                                                        setState(
                                                          () =>
                                                              _usesMargarine =
                                                                  v,
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10.r,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                            ),
                                            onPressed:
                                                () => Navigator.of(context)
                                                    .pop(),
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
                                              backgroundColor: _isEditing
                                                  ? ColorsManager.accentMint
                                                  : Colors.grey.shade400,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
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
            if (_loading)
              const Positioned.fill(
                child: Center(child: CircularProgressIndicator()),
              ),
            if (_error != null)
              Positioned.fill(
                child: Center(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
          ],
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
