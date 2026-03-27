import 'package:eventjar/controller/notification_inbox/state.dart';
import 'package:eventjar/model/notification_inbox/notification_inbox_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationInboxController extends GetxController {
  final state = NotificationInboxState();
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _loadStaticNotifications();
  }

  void _loadStaticNotifications() {
    final now = DateTime.now();
    state.notifications.value = [
      NotificationInboxItem(
        id: '1',
        title: 'New Event Added',
        body: 'TechConnect 2025 is now live. Register before slots fill up!',
        createdAt: now.subtract(const Duration(minutes: 10)),
        isRead: false,
        type: NotificationInboxType.event,
      ),
      NotificationInboxItem(
        id: '2',
        title: 'Meeting Request',
        body: 'Arun Kumar sent you a meeting request for tomorrow at 3:00 PM.',
        createdAt: now.subtract(const Duration(hours: 2)),
        isRead: false,
        type: NotificationInboxType.meeting,
      ),
      NotificationInboxItem(
        id: '3',
        title: 'New Contact',
        body: 'Priya Sharma connected with you after the Startup Summit.',
        createdAt: now.subtract(const Duration(hours: 5)),
        isRead: true,
        type: NotificationInboxType.contact,
      ),
      NotificationInboxItem(
        id: '4',
        title: 'Event Reminder',
        body: 'Design Minds Meetup starts in 1 hour. Don\'t miss it!',
        createdAt: now.subtract(const Duration(days: 1, hours: 1)),
        isRead: true,
        type: NotificationInboxType.reminder,
      ),
      NotificationInboxItem(
        id: '5',
        title: 'Contact Request',
        body: 'Rahul Mehta wants to add you as a contact.',
        createdAt: now.subtract(const Duration(days: 1, hours: 4)),
        isRead: false,
        type: NotificationInboxType.contact,
      ),
      NotificationInboxItem(
        id: '6',
        title: 'Meeting Confirmed',
        body:
            'Your meeting with Neha Joshi has been confirmed for Friday 11 AM.',
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: true,
        type: NotificationInboxType.meeting,
      ),
      NotificationInboxItem(
        id: '7',
        title: 'Event Update',
        body: 'Venue for Flutter India Summit has been changed. Check details.',
        createdAt: now.subtract(const Duration(days: 2, hours: 3)),
        isRead: true,
        type: NotificationInboxType.event,
      ),
      NotificationInboxItem(
        id: '8',
        title: 'Profile Viewed',
        body: '5 people viewed your profile this week.',
        createdAt: now.subtract(const Duration(days: 5)),
        isRead: true,
        type: NotificationInboxType.system,
      ),
      NotificationInboxItem(
        id: '9',
        title: 'New Event Near You',
        body: 'AI & ML Conference 2025 is happening near you next week.',
        createdAt: now.subtract(const Duration(days: 6)),
        isRead: true,
        type: NotificationInboxType.event,
      ),
    ];
  }

  void markAsRead(String id) {
    final index = state.notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !state.notifications[index].isRead) {
      state.notifications[index] = state.notifications[index].copyWith(
        isRead: true,
      );
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void markAllAsRead() {
    state.notifications.value = state.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
  }

  int get unreadCount => state.notifications.where((n) => !n.isRead).length;
}
