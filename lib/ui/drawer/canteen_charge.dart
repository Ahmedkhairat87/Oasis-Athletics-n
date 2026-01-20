import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/model/regStdModels/stdData.dart';
import '../../core/model/sideMenu/canteenCharge/ChargsAmounts.dart';
import '../../core/model/sideMenu/canteenCharge/StdChargs.dart';
import '../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../core/reusable_components/app_background.dart';
import '../../core/services/sideMenu/sideMenuServices/Canteen/CanteenServices.dart';
import '../webView-attachmentopener/openAttachment.dart';

class CanteenCharge extends StatefulWidget {
  static const routeName = '/canteenCharge';
  const CanteenCharge({super.key});

  @override
  State<CanteenCharge> createState() => _CanteenChargeState();
}

class _CanteenChargeState extends State<CanteenCharge> {
  bool isHistoryTab = false;
  stdData? selectedStudent;
  List<ChargsAmounts> chargeAmounts = [];
  List<StdChargs> history = [];
  bool loading = false;

  void _selectStudent(stdData student) {
    if (loading) return;
    if (student.stdId == selectedStudent?.stdId) return;

    setState(() => selectedStudent = student);
    _loadCanteenData(student);
  }

  Future<void> _loadCanteenData(stdData student) async {
    setState(() => loading = true);

    final amounts = await CanteenService.getChargeAmounts();
    final hist = await CanteenService.getHistory(student.stdId!.toInt());

    if (!mounted) return;

    setState(() {
      chargeAmounts = amounts;
      history = hist;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Canteen Charge'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),

                /// Students avatars (dynamic selection)
                ValueListenableBuilder<List<stdData>>(
                  valueListenable: studentsNotifier,
                  builder: (context, students, _) {
                    if (students.isEmpty) {
                      return const Center(child: Text('No students available'));
                    }

                    // 🔥 AUTO-SELECT FIRST STUDENT (runs once)
                    if (selectedStudent == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        final first = students.first;
                        setState(() => selectedStudent = first);
                        _loadCanteenData(first);
                      });
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          students.map((student) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: _StudentAvatar(
                                //name: student.stdFirstname ?? '',
                                imageUrl: student.stdPicture,
                                isSelected:
                                    selectedStudent?.stdId == student.stdId,
                                onTap: () => _selectStudent(student),
                              ),
                            );
                          }).toList(),
                    );
                  },
                ),
                SizedBox(height: 5.h),

                /// Selected student name
                Text(
                  selectedStudent?.stdFirstname ?? '',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),

                SizedBox(height: 10.h),

                /// Current balance (placeholder, could be dynamic)
                Text(
                  '${selectedStudent?.balance ?? '0.00'}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade700,
                  ),
                ),

                SizedBox(height: 10.h),

                /// Note
                Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Please note: The payment will be processed and the amount '
                    'will appear on the student’s card within 4 working days.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),

                SizedBox(height: 15.h),

                /// Tabs (Charge / Charging history)
                Container(
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Row(
                    children: [
                      _TabButton(
                        title: 'Charge',
                        isActive: !isHistoryTab,
                        onTap: () => setState(() => isHistoryTab = false),
                      ),
                      _TabButton(
                        title: 'Charging history',
                        isActive: isHistoryTab,
                        onTap: () => setState(() => isHistoryTab = true),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25.h),

                /// Tab content
                Expanded(
                  child:
                      loading
                          ? const Center(child: CircularProgressIndicator())
                          : selectedStudent == null
                          ? const SizedBox()
                          : isHistoryTab
                          ? _ChargingHistory(history: history)
                          : _ChargeOptions(
                            amounts: chargeAmounts,
                            student: selectedStudent!,
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ======================
/// Charge tab content
/// ======================
class _ChargeOptions extends StatelessWidget {
  final List<ChargsAmounts> amounts;
  final stdData student;

  const _ChargeOptions({required this.amounts, required this.student});

  @override
  Widget build(BuildContext context) {
    if (amounts.isEmpty) {
      return const Center(child: Text('No charge options'));
    }

    return ListView.separated(
      itemCount: amounts.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        final item = amounts[index];
        return _ChargeRow(
          amount: item.amount!,
          accNo: item.accNo!,
          student: student,
        );
      },
    );
  }
}

/// ======================
/// Charging history tab content
/// ======================
class _ChargingHistory extends StatelessWidget {
  final List<StdChargs> history;

  const _ChargingHistory({required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(child: Text('No charging history'));
    }

    return ListView.separated(
      itemCount: history.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        final item = history[index];
        return _HistoryRow(
          date: item.chargeDate ?? '',
          amount: '${item.amount} L.E',
        );
      },
    );
  }
}

/// ======================
/// Widgets
/// ======================

class _TabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(25.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25.r),
            boxShadow:
                isActive
                    ? [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentAvatar extends StatelessWidget {
  //final String name;
  final String? imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const _StudentAvatar({
    //required this.name,
    required this.isSelected,
    required this.onTap,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.green : Colors.blue,
                width: 2.w,
              ),
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ]
                      : [],
            ),
            child: CircleAvatar(
              radius: 28.r,
              backgroundColor: Colors.grey.shade200,
              backgroundImage:
                  imageUrl != null && imageUrl!.isNotEmpty
                      ? NetworkImage(imageUrl!)
                      : null,
              child:
                  imageUrl == null || imageUrl!.isEmpty
                      ? Icon(
                        Icons.person,
                        size: 30.sp,
                        color: isSelected ? Colors.green : Colors.blue,
                      )
                      : null,
            ),
          ),
          SizedBox(height: 6.h),
          // Text(
          //   name,
          //   style: TextStyle(
          //     fontSize: 13.sp,
          //     fontWeight: FontWeight.w500,
          //     color: isSelected ? Colors.green : Colors.black,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _ChargeRow extends StatelessWidget {
  final num amount;
  final num accNo;
  final stdData student;

  const _ChargeRow({
    required this.amount,
    required this.accNo,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          const Text('Amount'),
          const Spacer(),
          Text(amount.toString()),
          SizedBox(width: 20.w),
          ElevatedButton(
            onPressed: () async {
              final url = await CanteenService.createPaymentLink(
                stdId: student.stdId!.toInt(),
                accNo: accNo,
                amount: amount,
              );

              if (url != null && context.mounted) {
                openAttachment(context, url);
              }
            },
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final String date;
  final String amount;

  const _HistoryRow({required this.date, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          Text(date, style: TextStyle(fontSize: 14.sp)),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
