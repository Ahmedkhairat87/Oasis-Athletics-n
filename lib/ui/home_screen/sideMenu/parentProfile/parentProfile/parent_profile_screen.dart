import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/reusable_components/app_background.dart';
import '../sections/parent_profile_contact.dart';
import '../sections/parent_profile_education.dart';
import '../sections/parent_profile_emergency.dart';
import '../sections/parent_profile_general.dart';
import '../sections/parent_profile_work.dart';
import 'parent_profile_state.dart';
// TODO import other sections when you create them

class ParentProfileScreen extends StatelessWidget {
  static const routeName = '/parentprofile';
  const ParentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParentProfileState(),
      child: Consumer<ParentProfileState>(
        builder: (context, state, _) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: const Text('Parents Profile'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                if (!state.editMode) ...[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: state.loading ? null : state.toggleEdit,
                  ),
                ] else ...[
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: "Cancel",
                    onPressed: state.loading
                        ? null
                        : () {
                      state.cancelEdit(); // we'll add it in state
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    tooltip: "Save",
                    onPressed: state.loading
                        ? null
                        : () async {
                      FocusScope.of(context).unfocus();
                      final ok = await state.save(); // save only here
                      if (ok) {
                        state.toggleEdit(); // close edit mode ONLY after success
                      }
                    },
                  ),
                ]
              ],            ),
            body: AppBackground(
              child: SafeArea(
                child: Stack(
                  children: [
                    if (state.loading)
                      const Center(child: CircularProgressIndicator())
                    else
                      _sectionWrapper(
                        context,
                        title: _titleForSection(state.currentSection).tr(),
                        child: _buildSection(state),

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

                    CircularMenu(
                      alignment: Alignment.bottomRight,
                      radius: 90.w,
                      startingAngleInRadian: 3.0,
                      endingAngleInRadian: 4.7,
                      toggleButtonColor: Colors.blue,
                      toggleButtonIconColor: Colors.white,
                      items: ProfileSection.values.map((section) {
                        final isActive = section == state.currentSection;
                        return CircularMenuItem(
                          icon: _iconForSection(section),
                          iconSize: 16.sp,
                          padding: 10.w,
                          iconColor: isActive ? Colors.white : Colors.blue,
                          color: isActive ? Colors.blue : Colors.white,
                          onTap: () {
                            if (state.loading) return;
                            state.selectSection(section);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _buildSection(ParentProfileState state) {
    switch (state.currentSection) {
      case ProfileSection.general:
        return ParentProfileSectionGeneral(state: state);
      case ProfileSection.contact:
        return ParentProfileSectionContact(state: state);
      case ProfileSection.work:
        return ParentProfileSectionWork(state: state);
      case ProfileSection.education:
        return ParentProfileSectionEducation(state: state);
      case ProfileSection.emergency:
        return ParentProfileSectionEmergency(state: state);
    }
  }

  static Widget _sectionWrapper(
      BuildContext context, {
        required String title,
        required Widget child,
      }) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 20.h),
          child,
          SizedBox(height: 40.h),

        ],
      ),
    );
  }

  static String _titleForSection(ProfileSection s) {
    switch (s) {
      case ProfileSection.general:
        return "general";
      case ProfileSection.contact:
        return "contact";
      case ProfileSection.work:
        return "work";
      case ProfileSection.education:
        return "education";
      case ProfileSection.emergency:
        return "emergency";
    }
  }

  static IconData _iconForSection(ProfileSection s) {
    switch (s) {
      case ProfileSection.general:
        return Icons.person;
      case ProfileSection.contact:
        return Icons.phone;
      case ProfileSection.work:
        return Icons.work;
      case ProfileSection.education:
        return Icons.school;
      case ProfileSection.emergency:
        return Icons.warning;
    }
  }
}