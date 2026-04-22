import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 28,
  });

  bool get _hasValidImage {
    return imageUrl != null &&
        imageUrl!.isNotEmpty &&
        imageUrl!.toLowerCase() != 'null' &&
        imageUrl!.startsWith('http');
  }

  /// 🎨 Generate color based on name (stable)
  Color _getColor(String text) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    final index = text.hashCode % colors.length;
    return colors[index.abs()];
  }

  /// 🅰️ Get first letter
  String _getInitial() {
    if (name == null || name!.isEmpty) return "";
    return name!.trim()[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    /// 🎯 CASE 1: Has Image
    if (_hasValidImage) {
      return CircleAvatar(
        radius: radius.r,
        backgroundColor: isLight
            ? Colors.grey.shade200
            : Theme.of(context).colorScheme.surface,

        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: Uri.encodeFull(imageUrl!),
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,

            /// ⚡ Loading
            placeholder: (context, url) => Center(
              child: SizedBox(
                width: 18.w,
                height: 18.w,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),

            /// ❌ Error fallback
            errorWidget: (context, url, error) => _buildFallback(context),
          ),
        ),
      );
    }

    /// 🎯 CASE 2: No Image
    return _buildFallback(context);
  }

  /// 🔥 Fallback UI
  Widget _buildFallback(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    /// 🅰️ لو عندنا اسم → initials
    if (name != null && name!.isNotEmpty) {
      final bgColor = _getColor(name!);

      return CircleAvatar(
        radius: radius.r,
        backgroundColor: bgColor.withOpacity(0.15),
        child: Text(
          _getInitial(),
          style: TextStyle(
            fontSize: radius.sp,
            fontWeight: FontWeight.bold,
            color: bgColor,
          ),
        ),
      );
    }

    /// 👤 fallback النهائي
    return CircleAvatar(
      radius: radius.r,
      backgroundColor: isLight
          ? Colors.grey.shade200
          : Theme.of(context).colorScheme.surface,
      child: Icon(
        Icons.person_outline,
        size: radius.r,
        color: isLight
            ? Colors.grey.shade600
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }
}