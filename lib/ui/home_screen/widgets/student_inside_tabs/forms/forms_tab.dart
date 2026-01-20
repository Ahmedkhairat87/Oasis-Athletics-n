import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../medical_form.dart';
import '../nutrition_form.dart';

/// Forms tab content used inside the StudentInside page's PageView.
/// NOTE: This widget intentionally does NOT use a Scaffold (it is
/// rendered inside the parent screen's scaffold). The destination
/// pages (MedicalForm / NutritionForm) are full-screen Scaffolds.
class FormsTab extends StatelessWidget {
  const FormsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Use SingleChildScrollView to avoid overflow on small devices.
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Forms',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 12.h),

          // Medical Form Card
          _formCard(
            context,
            color: Colors.blueAccent,
            icon: Icons.medical_services,
            title: 'Medical Form',
            subtitle: 'Open medical form to view / fill details',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MedicalForm()),
              );
            },
          ),

          SizedBox(height: 14.h),

          // Nutrition Form Card
          _formCard(
            context,
            color: Colors.green,
            icon: Icons.fastfood,
            title: 'Nutrition Form',
            subtitle: 'Open nutrition form to view / fill details',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NutritionForm()),
              );
            },
          ),

          SizedBox(height: 18.h),

          // optional help text
          Text(
            'Tap a card to open the corresponding form. The form opens as a full screen page.',
            style: TextStyle(
              fontSize: 13.sp,
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formCard(
    BuildContext context, {
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.95), color.withOpacity(0.8)],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.18),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
                child: Icon(icon, color: Colors.white, size: 30.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.9)),
            ],
          ),
        ),
      ),
    );
  }
}
