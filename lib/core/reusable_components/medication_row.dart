// lib/ui/home_screen/widgets/student_inside_tabs/medication_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// not required but keep consistent imports if you use it later

class MedicationRow extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController dosageController;
  final TextEditingController freqController;
  final VoidCallback? onDelete;

  const MedicationRow({
    super.key,
    required this.nameController,
    required this.dosageController,
    required this.freqController,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Medication',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: dosageController,
            decoration: InputDecoration(
              labelText: 'Dosage',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: freqController,
            decoration: InputDecoration(
              labelText: 'Frequency',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Column(
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
              tooltip: 'Remove',
            ),
          ],
        ),
      ],
    );
  }
}
