import 'package:flutter/material.dart';

class NotificationAppBarButton extends StatelessWidget {
  final int unreadCount;
  final VoidCallback? onPressed;
  final Color color; // same style as your other buttons

  const NotificationAppBarButton({
    super.key,
    required this.unreadCount,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    return Tooltip(
      message: "Notifications",
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isDisabled ? 0.45 : 1,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ✅ same container styling as _appBarAction
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: color.withOpacity(0.20),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.notifications_rounded,
                  size: 20,
                  color: color,
                ),
              ),

              // ✅ badge
              if (unreadCount > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      unreadCount > 99 ? "99+" : unreadCount.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}