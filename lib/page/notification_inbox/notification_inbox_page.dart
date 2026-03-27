import 'package:eventjar/controller/notification_inbox/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/notification_inbox/notification_inbox_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationInboxPage extends GetView<NotificationInboxController> {
  const NotificationInboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2EF),
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
          decoration: const BoxDecoration(gradient: AppColors.appBarGradient),
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
        final notifications = controller.state.notifications;
        if (notifications.isEmpty) {
          return _buildEmpty();
        }
        return ListView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: notifications.length,
          itemBuilder: (_, i) {
            final item = notifications[i];
            final isLast = i == notifications.length - 1;
            return _NotificationTile(
              item: item,
              showDivider: !isLast,
              onTap: () => controller.markAsRead(item.id),
            );
          },
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
            decoration: const BoxDecoration(
              color: AppColors.liteBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 48,
              color: AppColors.gradientDarkStart,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'You\'re all caught up!',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationInboxItem item;
  final bool showDivider;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.item,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            color: item.isRead ? Colors.white : const Color(0xFFEEF3FB),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(),
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
                              item.title,
                              style: TextStyle(
                                fontWeight: item.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                fontSize: 13,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(item.createdAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: item.isRead
                                  ? Colors.grey.shade500
                                  : AppColors.gradientDarkStart,
                              fontWeight: item.isRead
                                  ? FontWeight.w400
                                  : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.body,
                        style: TextStyle(
                          fontSize: 12,
                          color: item.isRead
                              ? Colors.grey.shade600
                              : const Color(0xFF333333),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!item.isRead) ...[
                  const SizedBox(width: 10),
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: AppColors.gradientDarkStart,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showDivider)
            const Divider(height: 1, indent: 68, endIndent: 0, thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    IconData icon;
    List<Color> colors;

    switch (item.type) {
      case NotificationInboxType.event:
        icon = Icons.event_rounded;
        colors = [const Color(0xFF667EEA), const Color(0xFF764BA2)];
        break;
      case NotificationInboxType.contact:
        icon = Icons.person_add_rounded;
        colors = [const Color(0xFF11998E), const Color(0xFF38EF7D)];
        break;
      case NotificationInboxType.meeting:
        icon = Icons.handshake_rounded;
        colors = [const Color(0xFFFC4A1A), const Color(0xFFF7B733)];
        break;
      case NotificationInboxType.reminder:
        icon = Icons.alarm_rounded;
        colors = [const Color(0xFF4E54C8), const Color(0xFF8F94FB)];
        break;
      case NotificationInboxType.system:
        icon = Icons.info_rounded;
        colors = [const Color(0xFF2193B0), const Color(0xFF6DD5ED)];
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
