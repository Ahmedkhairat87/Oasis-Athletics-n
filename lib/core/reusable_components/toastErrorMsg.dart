import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMsg {
  static toastErrorMsg(BuildContext context, String msg) async {
    await Future.delayed(Duration(milliseconds: 200));
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Theme.of(context).colorScheme.error,
      textColor: Theme.of(context).colorScheme.onError,
      fontSize: 16.0,
    );
  }
}
