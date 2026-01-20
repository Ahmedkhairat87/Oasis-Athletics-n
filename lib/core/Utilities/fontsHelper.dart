import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double fsp(BuildContext context, double size, {double? min, double? max}) {
  final shortestSide = MediaQuery.of(context).size.shortestSide;
  final isTablet = shortestSide >= 600;

  final scaled = size.sp;
  if (!isTablet) return scaled;

  // for tablets: clamp to avoid huge scaling
  return scaled.clamp(min ?? size * 0.9, max ?? size * 1.2);
}
