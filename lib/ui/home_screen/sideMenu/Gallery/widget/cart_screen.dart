import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/core/model/sideMenu/gallary/extensions/photo_preview_extensions.dart';
import 'package:oasisathletic/core/services/sideMenu/galleryServices/galleryServices.dart';
import 'package:oasisathletic/ui/webView-attachmentopener/WebViewScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/model/sideMenu/gallary/cartPhotos/CartPhotoData.dart';
import '../../../../../core/model/sideMenu/gallary/cartPhotos/CartPhotosResponse.dart';
import '../../../../../core/model/sideMenu/gallary/cartPhotos/DeliveredPhotosDt.dart';
import '../../../../../core/reusable_components/app_background.dart';

import '../../../../../core/services/sideMenu/galleryServices/galleryPaymentService.dart';
import '../../../Home/students_screen.dart';
import '../widget/provider/cart_provider.dart';
import '../widget/photo_preview.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool loading = true;
  bool historyTab = false;

  CartPhotosResponse? response;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => loading = true);
    response = await GalleryService.getCartPhotos();

    if (!mounted) return;

    // 🔑 update badge count globally
    final count = response?.data?.length ?? 0;
    context.read<CartProvider>().setRequestedCount(count);

    setState(() => loading = false);
  }

  Future<String?> _getGalleryCartStdId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("galleryCartStdID"); // نفس key بتاع iOS
  }

  @override
  Widget build(BuildContext context) {
    final cartPhotos = response?.data ?? [];
    final historyPhotos = response?.deliveredPhotosDT ?? [];

    final totalAmount =
        cartPhotos.isNotEmpty ? (cartPhotos.first.totalPrice ?? 0) : 0;

    final canPay = response?.btn1Status == true && totalAmount > 0;

    // final totalAmount =
    // (response?.data != null && response!.data!.isNotEmpty)
    //     ? response!.data!.first.totalPrice ?? 0
    //     : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Photos'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child:
            loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    /// TABS
                    Row(
                      children: [
                        _TabBtn(
                          title: 'Cart',
                          active: !historyTab,
                          onTap: () => setState(() => historyTab = false),
                        ),
                        _TabBtn(
                          title: 'History',
                          active: historyTab,
                          onTap: () => setState(() => historyTab = true),
                        ),
                      ],
                    ),

                    /// LIST
                    Expanded(
                      child:
                          historyTab
                              ? _HistoryList(historyPhotos)
                              : _CartList(
                                cartPhotos,
                                onCancel: (serNo) async {
                                  await GalleryService.cancelPhoto(
                                    serNo: serNo.toInt(),
                                  );
                                  _loadCart();
                                },
                                onUpdated: _loadCart, // ✅ PASS CALLBACK
                              ),
                    ),

                    /// PAY SECTION
                    if (!historyTab)
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          children: [
                            /// TOTAL
                            Text(
                              'Total Amount: $totalAmount L.E',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 14.h),

                            /// PAY BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 52.h,
                              child: ElevatedButton(
                                onPressed:
                                    canPay
                                        ? () async {
                                          final stdId =
                                              await GalleryStdIdStorage.get();
                                          if (stdId == null || stdId.isEmpty) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Student ID missing",
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          final accNo =
                                              response?.accData?.isNotEmpty ==
                                                      true
                                                  ? (response!
                                                          .accData!
                                                          .first
                                                          .accSer ??
                                                      0)
                                                  : 0;

                                          if (accNo == 0) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Account category missing",
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          final url =
                                              await GalleryPaymentService.createPaymentLink(
                                                stdId: stdId,
                                                accNo: accNo,
                                                amount: totalAmount,
                                              );

                                          if (url == null || url.isEmpty) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Payment link generation failed",
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          if (!mounted) return;

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => WebViewScreen(
                                                    url: url,
                                                    title: 'Gallery Payments',
                                                  ),
                                            ),
                                          );
                                        }
                                        : null,

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  disabledBackgroundColor: Colors.grey.shade400,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                ),
                                child: Text(
                                  'Pay',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            /// 🔹 HELPER TEXT (ONLY WHEN DISABLED)
                            if (totalAmount == 0)
                              Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Text(
                                  'Add photos to enable payment',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  final List<CartPhotoData> photos;
  final Function(num serNo) onCancel;
  final VoidCallback onUpdated;

  const _CartList(
    this.photos, {
    required this.onCancel,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return const Center(child: Text('No requested photos'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: photos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        final photo = photos[i];

        return GestureDetector(
          onTap: () async {
            final updated = await showPhotoPreview(
              context,
              photo.previewVM,
              fromCart: true,
            );

            if (updated == true) {
              onUpdated(); // ✅ cart must reload
            }
          },
          child: Stack(
            children: [
              Image.network(photo.sphoto ?? ''),
              Positioned(
                right: 6,
                top: 6,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => onCancel(photo.serNo!),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryList extends StatelessWidget {
  final List<DeliveredPhotosDt> history;

  const _HistoryList(this.history);

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(child: Text('No delivered photos'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        final photo = history[i];
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            photo.sphoto ?? photo.sphoto ?? '',
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap;

  const _TabBtn({
    required this.title,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? Colors.blue : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: active ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
