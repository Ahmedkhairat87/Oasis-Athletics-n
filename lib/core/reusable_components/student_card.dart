import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors_Manager.dart';

class StudentCard extends StatelessWidget {
  final String name;
  final String photo;
  final VoidCallback onTap;

  const StudentCard({
    super.key,
    required this.name,
    required this.photo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    // Palette
    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : Theme.of(context).colorScheme.onSurface;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;

    final Color cardBackground =
        isLight ? Colors.white : ColorsManager.darkFields;
    final Color nameColor =
        isLight ? ColorsManager.lightText : ColorsManager.darkText;

    // STUDENT IMAGE
    ImageProvider<Object> imageProvider;
    if (photo.startsWith('http')) {
      imageProvider = NetworkImage(Uri.encodeFull(photo));
    } else {
      imageProvider = const AssetImage('assets/images/logo.png');
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1.0),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 8),
          child: Transform.scale(scale: value, child: child),
        );
      },
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),
          child: Container(
            decoration:
                isLight
                    ? BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryBlue.withOpacity(0.12),
                          accentSky.withOpacity(0.10),
                          accentMint.withOpacity(0.08),
                          accentSun.withOpacity(0.06),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.16),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    )
                    : BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.35),
                      ),
                    ),
            child: Container(
              margin: EdgeInsets.all(1.5.w),
              decoration: BoxDecoration(
                color: cardBackground.withOpacity(0.98),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // IMAGE RING
                    Container(
                      padding: EdgeInsets.all(3.0.w),
                      decoration:
                          isLight
                              ? BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [
                                    primaryBlue,
                                    accentSky,
                                    accentMint,
                                    accentSun,
                                    primaryBlue,
                                  ],
                                ),
                              )
                              : BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withOpacity(0.35),
                              ),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(2.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.r),
                          child: Image(
                            image: imageProvider,
                            width: 80.w,
                            height: 80.w,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Icon(
                                  Icons.person,
                                  size: 50.w,
                                  color: primaryBlue.withOpacity(0.7),
                                ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: nameColor,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 4.h),

                    Container(
                      width: 30.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999.r),
                        gradient: LinearGradient(
                          colors: [accentMint, accentSun],
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
    );
  }
}

// class StudentCard extends StatelessWidget {
//   final String name;
//   final String photo;
//   final VoidCallback onTap;
//
//   class StudentCard extends StatelessWidget {
//   final String name;
//   final String photo;
//   final VoidCallback onTap;
//
//   const StudentCard({
//   super.key,
//   required this.name,
//   required this.photo,
//   required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//   final isLight = Theme.of(context).brightness == Brightness.light;
//
//   // Palette
//   final Color primaryBlue = isLight
//   ? ColorsManager.primaryGradientStart
//       : ColorsManager.primaryGradientStartDark;
//   final Color accentMint = ColorsManager.accentMint;
//   final Color accentSun = ColorsManager.accentSun;
//   final Color accentSky = ColorsManager.accentSky;
//
//   final Color cardBackground =
//   isLight ? Colors.white : ColorsManager.darkFields;
//   final Color nameColor =
//   isLight ? ColorsManager.lightText : ColorsManager.darkText;
//
//   // STUDENT IMAGE
//   ImageProvider<Object> imageProvider;
//   if (photo.startsWith('http')) {
//   imageProvider = NetworkImage(Uri.encodeFull(photo));
//   } else {
//   imageProvider = const AssetImage('assets/images/logo.png');
//   }
//
//   return TweenAnimationBuilder<double>(
//   tween: Tween(begin: 0.92, end: 1.0),
//   duration: const Duration(milliseconds: 280),
//   curve: Curves.easeOutBack,
//   builder: (context, value, child) {
//   return Transform.translate(
//   offset: Offset(0, (1 - value) * 8),
//   child: Transform.scale(
//   scale: value,
//   child: child,
//   ),
//   );
//   },
//   child: Material(
//   color: Colors.transparent,
//   borderRadius: BorderRadius.circular(18.r),
//   child: InkWell(
//   onTap: onTap,
//   borderRadius: BorderRadius.circular(18.r),
//   child: Container(
//   decoration: BoxDecoration(
//   borderRadius: BorderRadius.circular(18.r),
//   // joyful multicolor wash around the card
//   gradient: LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [
//   primaryBlue.withOpacity(0.12),
//   accentSky.withOpacity(0.10),
//   accentMint.withOpacity(0.08),
//   accentSun.withOpacity(0.06),
//   ],
//   ),
//   boxShadow: [
//   BoxShadow(
//   color: primaryBlue.withOpacity(0.16),
//   blurRadius: 12,
//   offset: const Offset(0, 4),
//   ),
//   ],
//   ),
//   child: Container(
//   margin: EdgeInsets.all(1.5.w),
//   decoration: BoxDecoration(
//   color: cardBackground.withOpacity(0.98),
//   borderRadius: BorderRadius.circular(16.r),
//   ),
//
//   // CARD CONTENT
//   child: Padding(
//   padding:
//   EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
//   child: Column(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//   // STUDENT IMAGE WITH MULTICOLOR RING
//   Container(
//   padding: EdgeInsets.all(3.0.w),
//   decoration: BoxDecoration(
//   shape: BoxShape.circle,
//   gradient: SweepGradient(
//   colors: [
//   primaryBlue,
//   accentSky,
//   accentMint,
//   accentSun,
//   primaryBlue,
//   ],
//   ),
//   ),
//   child: Container(
//   decoration: BoxDecoration(
//   shape: BoxShape.circle,
//   color: Colors.white,
//   ),
//   padding: EdgeInsets.all(2.w),
//   child: ClipRRect(
//   borderRadius: BorderRadius.circular(50.r),
//   child: Image(
//   image: imageProvider,
//   width: 80.w,
//   height: 80.w,
//   fit: BoxFit.cover,
//   errorBuilder: (context, error, stackTrace) =>
//   Icon(
//   Icons.person,
//   size: 50.w,
//   color: primaryBlue.withOpacity(0.7),
//   ),
//   ),
//   ),
//   ),
//   ),
//
//   SizedBox(height: 10.h),
//
//   // STUDENT NAME
//   Text(
//   name,
//   textAlign: TextAlign.center,
//   style: TextStyle(
//   fontSize: 15.sp,
//   fontWeight: FontWeight.w700,
//   color: nameColor,
//   height: 1.2,
//   ),
//   maxLines: 2,
//   overflow: TextOverflow.ellipsis,
//   ),
//
//   SizedBox(height: 4.h),
//
//   // tiny playful underline
//   Container(
//   width: 30.w,
//   height: 3.h,
//   decoration: BoxDecoration(
//   borderRadius: BorderRadius.circular(999.r),
//   gradient: LinearGradient(
//   colors: [
//   accentMint,
//   accentSun,
//   ],
//   ),
//   ),
//   ),
//   ],
//   ),
//   ),
//   ),
//   ),
//   ),
//   ),
//   );
//   }
//
//   const StudentCard({
//     super.key,
//     required this.name,
//     required this.photo,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isLight = Theme.of(context).brightness == Brightness.light;
//
//     // Palette
//     final Color primaryBlue = isLight
//         ? ColorsManager.primaryGradientStart
//         : ColorsManager.primaryGradientStartDark;
//     final Color accentMint = ColorsManager.accentMint;
//     final Color accentSun = ColorsManager.accentSun;
//     final Color accentSky = ColorsManager.accentSky;
//
//     final Color cardBackground =
//     isLight ? Colors.white : ColorsManager.darkFields;
//     final Color nameColor =
//     isLight ? ColorsManager.lightText : ColorsManager.darkText;
//
//     // STUDENT IMAGE
//     ImageProvider<Object> imageProvider;
//     if (photo.startsWith('http')) {
//       imageProvider = NetworkImage(Uri.encodeFull(photo));
//     } else {
//       imageProvider = const AssetImage('assets/images/logo.png');
//     }
//
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.92, end: 1.0),
//       duration: const Duration(milliseconds: 280),
//       curve: Curves.easeOutBack,
//       builder: (context, value, child) {
//         return Transform.translate(
//           offset: Offset(0, (1 - value) * 8),
//           child: Transform.scale(
//             scale: value,
//             child: child,
//           ),
//         );
//       },
//       child: Material(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(18.r),
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(18.r),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(18.r),
//               // joyful multicolor wash around the card
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   primaryBlue.withOpacity(0.12),
//                   accentSky.withOpacity(0.10),
//                   accentMint.withOpacity(0.08),
//                   accentSun.withOpacity(0.06),
//                 ],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: primaryBlue.withOpacity(0.16),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Container(
//               margin: EdgeInsets.all(1.5.w),
//               decoration: BoxDecoration(
//                 color: cardBackground.withOpacity(0.98),
//                 borderRadius: BorderRadius.circular(16.r),
//               ),
//
//               // CARD CONTENT
//               child: Padding(
//                 padding:
//                 EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // STUDENT IMAGE WITH MULTICOLOR RING
//                     Container(
//                       padding: EdgeInsets.all(3.0.w),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: SweepGradient(
//                           colors: [
//                             primaryBlue,
//                             accentSky,
//                             accentMint,
//                             accentSun,
//                             primaryBlue,
//                           ],
//                         ),
//                       ),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white,
//                         ),
//                         padding: EdgeInsets.all(2.w),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(50.r),
//                           child: Image(
//                             image: imageProvider,
//                             width: 80.w,
//                             height: 80.w,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 Icon(
//                                   Icons.person,
//                                   size: 50.w,
//                                   color: primaryBlue.withOpacity(0.7),
//                                 ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(height: 10.h),
//
//                     // STUDENT NAME
//                     Text(
//                       name,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.w700,
//                         color: nameColor,
//                         height: 1.2,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//
//                     SizedBox(height: 4.h),
//
//                     // tiny playful underline
//                     Container(
//                       width: 30.w,
//                       height: 3.h,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(999.r),
//                         gradient: LinearGradient(
//                           colors: [
//                             accentMint,
//                             accentSun,
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
