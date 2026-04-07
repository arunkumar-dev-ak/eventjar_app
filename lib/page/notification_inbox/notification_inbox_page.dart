import 'package:eventjar/controller/notification_inbox/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/notification_inbox/notification_inbox_model.dart';
import 'package:eventjar/notification/utils/notification_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationInboxPage extends GetView<NotificationInboxController> {
  const NotificationInboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
        elevation: 0,
        actions: [
          Obx(() {
            if (controller.unreadCount == 0) return const SizedBox.shrink();
            return TextButton(
              onPressed: controller.markAllAsRead,
              child: Text(
                'Mark all read',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.state.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final notifications = controller.state.notifications;
        if (notifications.isEmpty) {
          return _buildEmpty();
        }
        return RefreshIndicator(
          onRefresh: controller.fetchNotifications,
          child: ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount:
                notifications.length + (controller.state.hasMore.value ? 1 : 0),
            itemBuilder: (_, i) {
              if (i == notifications.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final item = notifications[i];
              final isLast =
                  i == notifications.length - 1 &&
                  !controller.state.hasMore.value;
              return Obx(
                () => _NotificationTile(
                  item: item,
                  showDivider: !isLast,
                  isNavigating: controller.state.navigatingId.value == item.id,
                  onTap: () => controller.handleTap(item),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.lightBlueBgStatic,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 48,
              color: AppColors.gradientDarkStart,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryStatic,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'You\'re all caught up!',
            style: TextStyle(fontSize: 13, color: AppColors.textHintStatic),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final Datum item;
  final bool showDivider;
  final bool isNavigating;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.item,
    required this.showDivider,
    required this.isNavigating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = item.subject ?? '';
    final body = item.metadata?.body ?? '';
    final timestamp = item.createdAt ?? item.sentAt ?? DateTime.now();
    final navigable = isNotificationNavigable(item.triggerKey);
    final isRead = item.isRead ?? true;

    return InkWell(
      onTap: navigable ? onTap : null,
      child: Column(
        children: [
          Container(
            color: !isRead
                ? AppColors.lightBlueBg(context)
                : navigable
                ? AppColors.cardBg(context)
                : AppColors.scaffoldBg(context),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(item.notificationType),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textHint(context),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      if (body.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          body,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary(context),
                            height: 1.4,
                          ),
                        ),
                      ],
                      if (!navigable) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.chipBg(context),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Info only',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textHint(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: const BoxDecoration(
                          color: AppColors.gradientDarkStart,
                          shape: BoxShape.circle,
                        ),
                      ),
                    if (isNavigating)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else if (navigable)
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.textSecondary(context),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              height: 1,
              indent: 68,
              endIndent: 0,
              thickness: 0.5,
              color: AppColors.divider(context),
            ),
        ],
      ),
    );
  }

  Widget _buildIcon(NotificationInboxType type) {
    IconData icon;
    List<Color> colors;

    switch (type) {
      case NotificationInboxType.meeting:
        icon = Icons.handshake_rounded;
        colors = [const Color(0xFFFC4A1A), const Color(0xFFF7B733)];
        break;
      case NotificationInboxType.connection:
        icon = Icons.people_rounded;
        colors = [const Color(0xFF11998E), const Color(0xFF38EF7D)];
        break;
      case NotificationInboxType.contact:
        icon = Icons.contacts_rounded;
        colors = [const Color(0xFF667EEA), const Color(0xFF764BA2)];
        break;
      case NotificationInboxType.ticket:
        icon = Icons.confirmation_number_rounded;
        colors = [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)];
        break;
      case NotificationInboxType.security:
        icon = Icons.shield_rounded;
        colors = [const Color(0xFFCB2D3E), const Color(0xFFEF473A)];
        break;
      case NotificationInboxType.event:
        icon = Icons.event_rounded;
        colors = [const Color(0xFF4E54C8), const Color(0xFF8F94FB)];
        break;
      case NotificationInboxType.reminder:
        icon = Icons.alarm_rounded;
        colors = [const Color(0xFF2193B0), const Color(0xFF6DD5ED)];
        break;
      case NotificationInboxType.system:
        icon = Icons.notifications_rounded;
        colors = [const Color(0xFF757F9A), const Color(0xFFD7DDE8)];
        break;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);
    if (date == today) {
      return DateFormat('h:mm a').format(dt);
    }
    return DateFormat('MMM d').format(dt);
  }
}
