import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusRegisteration extends StatelessWidget {
  static const routeName = '/busRegisteration';
  const BusRegisteration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: HomeDrawer(),
      extendBodyBehindAppBar: true, // ✅ Allows content behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.2), // ✅ Semi-transparent
        elevation: 0,
        title: const Text(
          'Bus Registration',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // ✅ Blur effect
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Stack(
        children: [
          // ✅ Your fancy background: bubbles/gradients
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 150.w,
              height: 150.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blueAccent.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.lightBlue.withOpacity(0.3),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),

          // ✅ Your main page content pushed below the AppBar
          Padding(
            padding: EdgeInsets.only(
              top: kToolbarHeight + MediaQuery.of(context).padding.top + 20.h,
              left: 20.w,
              right: 20.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Fuck Israel 🖕🏼',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Palestine Will be free from the river to the sea"\n"🇵🇸🇵🇸🇵🇸🇵🇸🇵🇸🇵🇸🇵🇸🇵🇸🇵🇸🇵🇸🇵🇸🇵🇸🇵🇸🇵🇸🇵🇸"\n"From the sea to the river Palestine will live forever',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[800]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
