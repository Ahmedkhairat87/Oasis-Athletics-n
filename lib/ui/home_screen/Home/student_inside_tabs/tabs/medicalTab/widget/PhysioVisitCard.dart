import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/model/stdLinks/medicalTab/StdDoctorPhysiotherapist.dart';

class PhysioVisitCard extends StatefulWidget {
  final StdDoctorPhysiotherapist visit;
  final bool isRead;
  final Color accentMint;
  final Color accentSun;
  final Color accentSky;
  final Color titleColor;
  final VoidCallback? onView;

  /// only for exercise link / video if found
  final VoidCallback? onOpenLink;

  const PhysioVisitCard({
    super.key,
    required this.visit,
    required this.isRead,
    required this.accentMint,
    required this.accentSun,
    required this.accentSky,
    required this.titleColor,
    this.onOpenLink,
    this.onView,
  });

  @override
  State<PhysioVisitCard> createState() => _PhysioVisitCardState();
}

class _PhysioVisitCardState extends State<PhysioVisitCard> {
  bool _expanded = false;

  String _safeText(dynamic value, {String fallback = '—'}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return fallback;
    return text;
  }

  bool _hasValue(dynamic value) {
    if (value == null) return false;
    final text = value.toString().trim();
    return text.isNotEmpty && text.toLowerCase() != 'null';
  }

  String _formatDate(dynamic date) {
    if (date == null) return '—';
    final raw = date.toString().trim();
    if (raw.isEmpty || raw.toLowerCase() == 'null') return '—';

    try {
      final d = DateTime.parse(raw);
      return '${d.day.toString().padLeft(2, '0')}/'
          '${d.month.toString().padLeft(2, '0')}/'
          '${d.year}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = widget.isRead ? widget.accentMint : widget.accentSun;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.98),
        border: Border.all(
          color: statusColor.withOpacity(0.65),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// top row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _miniInfoChip(
                      label: 'id'.tr(),
                      value: '${widget.visit.recordID ?? '—'}',
                      color: widget.accentSky,
                    ),
                    _miniInfoChip(
                      label: 'visit_date'.tr(),
                      value: _formatDate(widget.visit.dateOfVisit),
                      color: widget.accentSky,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              _statusChip(context),
            ],
          ),

          SizedBox(height: 12.h),

          /// always visible summary
          _detailBlock(
            label: 'complaint'.tr(),
            value: _safeText(widget.visit.presentingComplaint),
          ),

          SizedBox(height: 12.h),

          /// buttons row
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accentMint,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () {
                    widget.onView?.call();
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  icon: Icon(
                    _expanded ? Icons.expand_less : Icons.remove_red_eye,
                    size: 18.sp,
                  ),
                  label: Text(
                    _expanded ? 'hide_details'.tr() : 'view'.tr(),
                  ),
                ),
              ),
            ],
          ),
          /// expanded details
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Column(
                children: [
                  _detailBlock(
                    label: 'diagnosis'.tr(),
                    value: _safeText(widget.visit.initialDiagnosis),
                  ),
                  SizedBox(height: 8.h),

                  _detailBlock(
                    label: 'needed_scans'.tr(),
                    value: _safeText(widget.visit.scansNeeded),
                  ),
                  SizedBox(height: 8.h),

                  _detailBlock(
                    label: 'treatment'.tr(),
                    value: _safeText(widget.visit.treatmentOnSpot),
                  ),
                  SizedBox(height: 8.h),

                  _detailBlock(
                    label: 'rehab_plan'.tr(),
                    value: _safeText(widget.visit.physioRehabPlan),
                  ),
                  SizedBox(height: 8.h),

                  _detailBlock(
                    label: 'home_exercise_program'.tr(),
                    value: _safeText(widget.visit.homeExerciseProgram),
                  ),
                  SizedBox(height: 8.h),

                  if (_hasValue(widget.visit.exerciseLinks) ||
                      _hasValue(widget.visit.exerciseVideoPath)) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.45),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'exercise_links'.tr(),
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: widget.titleColor.withOpacity(0.9),
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 10.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            onPressed: widget.onOpenLink,
                            icon: Icon(Icons.link, size: 18.sp),
                            label: Text('open_link'.tr()),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],

                  Row(
                    children: [
                      Expanded(
                        child: _detailBlock(
                          label: 'home_care_option'.tr(),
                          value: _safeText(widget.visit.homeCareOption),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _detailBlock(
                          label: 'other_care'.tr(),
                          value: _safeText(widget.visit.homeCareOtherText),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  Row(
                    children: [
                      Expanded(
                        child: _detailBlock(
                          label: 'return_to_play'.tr(),
                          value: _safeText(widget.visit.returnToPlay),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _detailBlock(
                          label: 'follow_up'.tr(),
                          value: _formatDate(widget.visit.followUpDate),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            crossFadeState:
            _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  Widget _detailBlock({
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.45),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: widget.titleColor.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniInfoChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999.r),
        color: color.withOpacity(0.10),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _statusChip(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999.r),
        color: widget.isRead
            ? widget.accentMint.withOpacity(0.12)
            : Colors.red.withOpacity(0.10),
        border: Border.all(
          color: widget.isRead ? widget.accentMint : Colors.redAccent,
          width: 1,
        ),
      ),
      child: Text(
        widget.isRead ? 'read'.tr() : 'unread'.tr(),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: widget.isRead ? widget.accentMint : Colors.redAccent,
        ),
      ),
    );
  }
}