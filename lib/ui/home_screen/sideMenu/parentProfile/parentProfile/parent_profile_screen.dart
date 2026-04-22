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

class ParentProfileScreen extends StatelessWidget {
  static const routeName = '/parentprofile';
  const ParentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParentProfileState(),
      child: Consumer<ParentProfileState>(
        builder: (context, state, _) {
          final scheme = Theme.of(context).colorScheme;

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: Text(
                'Parents Profile',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                if (!state.editMode) ...[
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: IconButton(
                      icon: const Icon(Icons.edit_rounded),
                      onPressed: state.loading ? null : state.toggleEdit,
                    ),
                  ),
                ] else ...[
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: "Cancel",
                    onPressed: state.loading
                        ? null
                        : () {
                      state.cancelEdit();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: IconButton(
                      icon: const Icon(Icons.check_rounded),
                      tooltip: "Save",
                      onPressed: state.loading
                          ? null
                          : () async {
                        FocusScope.of(context).unfocus();
                        final ok = await state.save();
                        if (ok) {
                          state.toggleEdit();
                        }
                      },
                    ),
                  ),
                ]
              ],
            ),
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
                        subtitle: state.editMode
                            ? 'edit_mode_enabled'.tr()
                            : 'view_mode_enabled'.tr(),
                        child: _buildSection(state),
                      ),

                    if (state.error != null)
                      Positioned(
                        top: 12.h,
                        left: 20.w,
                        right: 20.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: Colors.redAccent,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  state.error!,
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    CircularMenu(
                      alignment: Alignment.bottomRight,
                      radius: 92.w,
                      startingAngleInRadian: 3.1,
                      endingAngleInRadian: 4.75,
                      toggleButtonColor: scheme.primary,
                      toggleButtonIconColor: Colors.white,
                      items: ProfileSection.values.map((section) {
                        final isActive = section == state.currentSection;
                        return CircularMenuItem(
                          icon: _iconForSection(section),
                          iconSize: 16.sp,
                          padding: 10.w,
                          iconColor: isActive ? Colors.white : scheme.primary,
                          color: isActive ? scheme.primary : Colors.white,
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
        required String subtitle,
        required Widget child,
      }) {
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 120.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: scheme.surface.withOpacity(0.95),
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: scheme.outline.withOpacity(0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: scheme.onSurface.withOpacity(0.62),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
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
        return Icons.person_rounded;
      case ProfileSection.contact:
        return Icons.phone_rounded;
      case ProfileSection.work:
        return Icons.work_rounded;
      case ProfileSection.education:
        return Icons.school_rounded;
      case ProfileSection.emergency:
        return Icons.warning_amber_rounded;
    }
  }
}