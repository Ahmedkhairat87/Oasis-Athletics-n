import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/model/sideMenu/gallary/cartPhotos/PhotoPreviewModel.dart';
import '../../../../../core/services/sideMenu/galleryServices/galleryServices.dart';
import 'provider/cart_provider.dart';

Future<bool?> showPhotoPreview(
  BuildContext context,
  PhotoPreviewVM photo, {
  required bool fromCart,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PhotoPreviewPopup(photo: photo, fromCart: fromCart),
  );
}

class _PhotoPreviewPopup extends StatefulWidget {
  final PhotoPreviewVM photo;
  final bool fromCart;

  const _PhotoPreviewPopup({required this.photo, required this.fromCart});

  @override
  State<_PhotoPreviewPopup> createState() => _PhotoPreviewPopupState();
}

class _PhotoPreviewPopupState extends State<_PhotoPreviewPopup> {
  bool loading = false;

  bool get isRequested =>
      widget.photo.btnTxt.toLowerCase().contains('cancel') ||
      widget.photo.btnTxt.toLowerCase().contains('requested');

  bool get isDisabled => loading || (isRequested && !widget.fromCart);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),

          /// IMAGE
          Expanded(
            child: InteractiveViewer(
              child: Image.network(
                widget.photo.imageUrl,
                fit: BoxFit.contain,
                errorBuilder:
                    (_, __, ___) => const Icon(Icons.broken_image, size: 80),
              ),
            ),
          ),

          /// ACTION BUTTON
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient:
                      !isRequested
                          ? const LinearGradient(
                            colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                          : null,
                  color: isRequested ? Colors.red : null,
                ),
                child: ElevatedButton(
                  onPressed: isDisabled ? null : _handleAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    disabledBackgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            widget.photo.btnTxt,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAction() async {
    setState(() => loading = true);

    try {
      if (!isRequested) {
        /// ===== REQUEST =====
        final res = await GalleryService.requestPhoto(
          photoSerNo: widget.photo.serNo,
        );

        if (res != null && mounted) {
          context.read<CartProvider>().setRequestedCount(
            int.tryParse(res.requestedCount ?? '0') ?? 0,
          );
          Navigator.pop(context, true); // 🔑 updated
        }
      } else if (widget.fromCart) {
        /// ===== CANCEL (CART ONLY) =====
        final res = await GalleryService.cancelPhoto(
          serNo: widget.photo.photoSerNo ?? widget.photo.serNo,
        );

        if (res != null && mounted) {
          context.read<CartProvider>().setRequestedCount(
            int.tryParse(res.requestedCount ?? '0') ?? 0,
          );
          Navigator.pop(context, true); // 🔑 updated
        }
      }
    } catch (e) {
      debugPrint('❌ Photo preview action error: $e');
    }

    if (mounted) setState(() => loading = false);
  }
}
