import 'package:flutter/foundation.dart';

import '../../../../core/model/dashboard/notification/Data.dart';
import '../../../../core/services/notificationCenter/notificationService.dart';

class NotificationCenterController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  List<Data> items = [];

  int get unreadCount => items.where((e) => (e.status ?? 0) == 0).length;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final res = await NotificationCenterService.getNotifications();
      items = res?.data ?? [];
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markOneRead(Data n) async {
    final serNo = n.serNo;
    if (serNo == null) return;

    // optimistic update
    final idx = items.indexWhere((x) => x.serNo == serNo);
    if (idx == -1) return;

    final old = items[idx];
    items[idx] = _copyWithStatus(old, 1);
    notifyListeners();

    final ok = await NotificationCenterService.readOne(serNo: serNo);
    if (!ok) {
      // rollback
      items[idx] = old;
      notifyListeners();
      throw Exception("readOne failed");
    }
  }

  Future<void> markAllRead() async {
    final old = List<Data>.from(items);

    // optimistic
    items = items.map((e) => _copyWithStatus(e, 1)).toList();
    notifyListeners();

    final ok = await NotificationCenterService.readAll();
    if (!ok) {
      items = old;
      notifyListeners();
      throw Exception("readAll failed");
    }
  }

  Data _copyWithStatus(Data d, num status) {
    return Data(
      serNo: d.serNo,
      fatherID: d.fatherID,
      nTitle: d.nTitle,
      nSubTitle: d.nSubTitle,
      nBody: d.nBody,
      nCategory: d.nCategory,
      mSGCategory: d.mSGCategory,
      nSerNo: d.nSerNo,
      var1: d.var1,
      var2: d.var2,
      status: status,
      editedDate: d.editedDate,
    );
  }
}