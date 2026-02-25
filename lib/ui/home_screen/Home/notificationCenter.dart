import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/reusable_components/app_background.dart';
import '../../../core/model/dashboard/notification/Data.dart';
import '../Home/widget/notificationCenterController.dart';

// import your target screens routes:
import '../../home_screen/MSGScreens/messages.dart';
import '../../home_screen/Home/student_inside_tabs/student_inside.dart';
import '../../home_screen/sideMenu/newsLetter/NewsLetterScreen.dart';
import '../../home_screen/sideMenu/Gallery/galleryAlbums.dart';
import '../../drawer/canteen_charge.dart';

class NotificationCenterScreen extends StatefulWidget {
  static const routeName = "/notification-center";
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  bool _loadedOnce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadedOnce) {
      _loadedOnce = true;
      Future.microtask(() => context.read<NotificationCenterController>().load());
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<NotificationCenterController>();
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,

      appBar: _buildStyledAppBar(context, c),

      body: AppBackground(
        useAppBarBlur: false,
        useSafeArea: true,
        safeAreaTop: false,
        safeAreaBottom: true,
        child: Padding(
          padding: EdgeInsets.only(top: topPad + kToolbarHeight),
          child: Builder(
            builder: (_) {
              if (c.isLoading) {
                return const Center(child: CupertinoActivityIndicator());
              }

              if (c.error != null) {
                return _ErrorState(
                  message: c.error!,
                  onRetry: () => context.read<NotificationCenterController>().load(),
                );
              }

              if (c.items.isEmpty) {
                return _EmptyState(
                  onRefresh: () => context.read<NotificationCenterController>().load(),
                );
              }

              return RefreshIndicator(
                onRefresh: () => context.read<NotificationCenterController>().load(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: c.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final item = c.items[i];
                    return _NotificationTile(
                      item: item,
                      onTap: () async {
                        // 1) mark read (optimistic already inside controller)
                        try {
                          await context.read<NotificationCenterController>().markOneRead(item);
                        } catch (_) {}

                        // 2) navigate using Var2
                        _navigateFromVar2(context, item);
                      },
                      onMarkRead: () async {
                        try {
                          await context.read<NotificationCenterController>().markOneRead(item);
                        } catch (_) {
                          _toast(context, "Failed to mark as read");
                        }
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildStyledAppBar(BuildContext context, NotificationCenterController c) {
    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Notifications${c.unreadCount > 0 ? " (${c.unreadCount})" : ""}',
        style: TextStyle(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        if (c.unreadCount > 0)
          TextButton(
            onPressed: () async {
              try {
                await context.read<NotificationCenterController>().markAllRead();
              } catch (_) {
                _toast(context, "Failed to mark all as read");
              }
            },
            child: Text(
              "Mark all",
              style: TextStyle(
                color: scheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  // =========================
  // Var2 routing
  // Var2 example: "1,goToMsg,0"
  // action = second part => goToMsg
  // =========================
  void _navigateFromVar2(BuildContext context, Data item) {
    final raw = (item.var2 ?? "").trim();
    if (raw.isEmpty) return;

    final parts = raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.length < 2) return;

    final action = parts[1];
    final route = _actionToRoute[action];
    if (route == null) return;

    final args = _buildArgs(action: action, raw: raw, parts: parts);

    Navigator.of(context).pushNamed(route, arguments: args);
  }

  // same mapping you shared
  static const Map<String, String> _actionToRoute = {
    'goToMsg': Messages.routeName,
    //'goToStdBook': StudentInside.routeName,
    'goToNews': NewsLetterScreen.routeName,
    'goToGallery': GalleryAlbums.routeName,
    'goToCanteenPayment': CanteenCharge.routeName,
  };

  // same args logic you had in PushRouter
  Map<String, dynamic> _buildArgs({
    required String action,
    required String raw,
    required List<String> parts,
  }) {
    final base = {'rawArgs': raw, 'parts': parts, 'action': action};

    switch (action) {
      case 'goToStdBook':
        return {
          ...base,
          'studentId': parts.length > 2 ? parts[2] : null,
          'name': parts.length > 3 ? parts[3] : null,
          'photoUrl': parts.length > 4 ? parts[4] : null,
          'email': parts.length > 5 ? parts[5] : null,
          'password': parts.length > 6 ? parts[6] : null,
          'gradeOrLevel': parts.length > 7 ? parts[7] : null,
        };

      case 'goToMsg':
      default:
        return {...base, 'value': parts.length > 2 ? parts[2] : null};
    }
  }

  static void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// ======================
// Tile + Empty + Error
// ======================

class _NotificationTile extends StatelessWidget {
  final Data item;
  final VoidCallback onTap;
  final VoidCallback onMarkRead;

  const _NotificationTile({
    required this.item,
    required this.onTap,
    required this.onMarkRead,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = (item.status ?? 0) == 0;

    return Dismissible(
      key: ValueKey(item.serNo ?? "${item.nTitle}-${item.editedDate}"),
      direction: isUnread ? DismissDirection.endToStart : DismissDirection.none,
      confirmDismiss: (_) async {
        onMarkRead();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBlue.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(CupertinoIcons.check_mark, color: Colors.white),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: CupertinoColors.separator.resolveFrom(context).withOpacity(0.35),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isUnread)
                Container(
                  margin: const EdgeInsets.only(top: 6, right: 10),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: CupertinoColors.activeBlue,
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nTitle ?? "Notification",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                        color: CupertinoColors.label.resolveFrom(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    if ((item.nSubTitle ?? "").trim().isNotEmpty)
                      Text(
                        item.nSubTitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                      ),
                    if ((item.nBody ?? "").trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.nBody!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      item.editedDate ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                      ),
                    ),
                  ],
                ),
              ),

              if (isUnread)
                IconButton(
                  onPressed: onMarkRead,
                  icon: const Icon(CupertinoIcons.check_mark_circled),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.bell, size: 44),
            const SizedBox(height: 10),
            const Text("No notifications"),
            const SizedBox(height: 12),
            CupertinoButton.filled(
              onPressed: onRefresh,
              child: const Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.exclamationmark_triangle, size: 44),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: CupertinoColors.systemRed.resolveFrom(context)),
            ),
            const SizedBox(height: 12),
            CupertinoButton.filled(
              onPressed: onRetry,
              child: const Text("Try again"),
            ),
          ],
        ),
      ),
    );
  }
}