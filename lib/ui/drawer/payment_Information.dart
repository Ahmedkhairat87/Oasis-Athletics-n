import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/reusable_components/app_colors_extension.dart';

class PaymentInformation extends StatelessWidget {
  static const routeName = '/paymentInformation';
  const PaymentInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: HomeDrawer(),
      extendBodyBehindAppBar: true, // ✅ Allows content behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.2), // ✅ Semi-transparent
        elevation: 0,
        title: const Text(
          'Payment Information',
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

          //Main Page Starts HEre
          Padding(
            padding: EdgeInsets.only(
              top: kToolbarHeight + MediaQuery.of(context).padding.top + 20.h,
              left: 20.w,
              right: 20.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "welcoming".tr(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.textMainBlack,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.person, size: 100.sp, color: Colors.blue),
                        Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.elements,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.w),
                    Column(
                      children: [
                        Icon(Icons.person, size: 100.sp, color: Colors.blue),
                        Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.elements,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "q_links".tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.textMainBlack,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Divider(),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20.w,
                      runSpacing: 20.h,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 65.w,
                              height: 75.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/logoOAD.png",
                                  ),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 75.w,
                              child: Text(
                                "athletics".tr(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 65.w,
                              height: 65.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage("assets/images/ExtAct.jpg"),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 65.w,
                              child: Text(
                                "extras".tr(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 65.w,
                              height: 65.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/Canteen.png",
                                  ),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 65.w,
                              child: Text(
                                "canteen".tr(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 65.w,
                              height: 65.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/be7cd3d8.jpg",
                                  ),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 65.w,
                              child: Text(
                                "class_photo".tr(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          //Main Page Ends Here
        ],
      ),
    );
  }
}
