import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/forms/medical_form/medical_form_section_allergies.dart';
import 'package:provider/provider.dart';



import '../../../../../../core/reusable_components/app_background.dart';
import 'medical_form_sections.dart';
import 'medical_form_state.dart';
import 'medical_form_body2-5.dart';
import 'medical_form_body_6-9.dart';
import 'medical_form_body_10-12.dart';
import 'medical_form_footer.dart';

class MedicalForm extends StatelessWidget {
  const MedicalForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MedicalFormState(),
      child: Consumer<MedicalFormState>(
        builder: (context, state, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white.withOpacity(0.9),
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Child Medical History',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                // ✅ SAVE (top)
                IconButton(
                  tooltip: 'Save',
                  onPressed: state.isEditing
                      ? () async {
                    final ok = await state.saveMedicalForm();
                    if (ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saved successfully')),
                      );
                    }
                  }
                      : null,
                  icon: const Icon(Icons.save),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: state.isEditing ? null : state.enterEditMode,
                ),
              ],
            ),
            body: AppBackground(
              child: Stack(
                children: [
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    child: Form(
                      key: state.formKey,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MedicalFormSections(state: state),
                                  MedicalFormAllergiesSection(state: state),
                                  MedicalFormBodyPart1(state: state),
                                  MedicalFormBodyPart2(state: state),
                                  MedicalFormBodyPart3(state: state),
                                  MedicalFormFooter(state: state),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (state.loading)
                    const Positioned.fill(
                      child: Center(child: CircularProgressIndicator()),
                    ),

                  if (state.error != null)
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          state.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}