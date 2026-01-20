// lib/core/reusable_components/student_notifier.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/regStdModels/stdData.dart';
import '../../model/stdLinks/StdFullData.dart';

const String _kStudentPrefsKey = 'oasis_student_profile_v1';

/// Global ValueNotifier used across the app.
final ValueNotifier<stdData> studentNotifier = ValueNotifier<stdData>(
  stdData(
    stdId: 0,
    stdFirstname: "Unknown",
    stdPicture: "",
    currentGrade: 0,
    currentClasse: 0,
  ),
);

/// Load student from local storage
Future<void> loadStudentFromPrefs() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_kStudentPrefsKey);

    if (jsonStr != null && jsonStr.isNotEmpty) {
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      final loaded = stdData.fromJson(map);
      studentNotifier.value = loaded;
    }
  } catch (e) {
    if (kDebugMode) print("loadStudentFromPrefs error: $e");
  }
}

/// Save current student to local storage
Future<void> saveStudentToPrefs() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(studentNotifier.value.toJson());
    await prefs.setString(_kStudentPrefsKey, jsonStr);
  } catch (e) {
    if (kDebugMode) print("saveStudentToPrefs error: $e");
  }
}

/// Update whole student object
Future<void> updateStudent(stdData newStudent, {bool persist = true}) async {
  studentNotifier.value = newStudent;
  if (persist) await saveStudentToPrefs();
}

/// Update only one field — firstname
Future<void> updateStudentName(String newName, {bool persist = true}) async {
  final current = studentNotifier.value;

  studentNotifier.value = stdData(
    stdId: current.stdId,
    stdFirstname: newName,
    stdPicture: current.stdPicture,
    currentGrade: current.currentGrade,
    currentClasse: current.currentClasse,
  );

  if (persist) await saveStudentToPrefs();
}

/// Update profile picture
Future<void> updateStudentPhoto(String newPhoto, {bool persist = true}) async {
  final current = studentNotifier.value;

  studentNotifier.value = stdData(
    stdId: current.stdId,
    stdFirstname: current.stdFirstname,
    stdPicture: newPhoto,
    currentGrade: current.currentGrade,
    currentClasse: current.currentClasse,
  );

  if (persist) await saveStudentToPrefs();
}

/// Update grade
Future<void> updateStudentGrade(num newGrade, {bool persist = true}) async {
  final current = studentNotifier.value;

  studentNotifier.value = stdData(
    stdId: current.stdId,
    stdFirstname: current.stdFirstname,
    stdPicture: current.stdPicture,
    currentGrade: newGrade,
    currentClasse: current.currentClasse,
  );

  if (persist) await saveStudentToPrefs();
}

/// Reset student to placeholder
Future<void> resetStudent({bool persist = true}) async {
  studentNotifier.value = stdData(
    stdId: 0,
    stdFirstname: "Unknown",
    stdPicture: "",
    currentGrade: 0,
    currentClasse: 0,
  );

  if (persist) await saveStudentToPrefs();
}

final ValueNotifier<StdFullData?> studentFullNotifier =
    ValueNotifier<StdFullData?>(null);

void updateFullStudent(StdFullData data) {
  studentFullNotifier.value = data;
}

/// Holds ALL students loaded from regStd API
final ValueNotifier<List<stdData>> studentsNotifier =
    ValueNotifier<List<stdData>>([]);
