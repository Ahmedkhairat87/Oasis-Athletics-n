import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/reusable_components/app_background.dart';
import '../../../home_screen/sideMenu/Gallery/widget/provider/cart_provider.dart';

class PhotoPreview extends StatelessWidget {
  final String photoId;
  final String album;

  const PhotoPreview({super.key, required this.photoId, required this.album});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey.shade300,
                child: const Center(child: Icon(Icons.image, size: 120)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: /*ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Request this photo'),
                onPressed: () {
                  context.read<CartProvider>().addToCart(
                    PhotoItem(
                      id: photoId,
                      album: album,
                      price: 40,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),*/ ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 6,
                  shadowColor: Colors.blueAccent.withOpacity(0.4),
                  backgroundColor:
                      Colors
                          .transparent, // 🔑 use transparent to allow gradient
                ).copyWith(
                  // 🔑 Add gradient background via MaterialStateProperty
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.blue.shade700;
                    } else if (states.contains(MaterialState.hovered)) {
                      return Colors.blue.shade500;
                    }
                    return Colors.blue; // default
                  }),
                ),
                onPressed: () {
                  context.read<CartProvider>().addToCart(
                    PhotoItem(id: photoId, album: album, price: 40),
                  );
                  Navigator.pop(context);
                },
                child: Ink(
                  /*decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent.shade400, Colors.blueAccent.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),*/
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Request this photo',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.1,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
