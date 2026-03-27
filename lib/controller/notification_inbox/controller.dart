import 'package:eventjar/api/notification_api/notification_api.dart';
import 'package:eventjar/controller/home/controller.dart';
import 'package:eventjar/controller/notification_inbox/state.dart';
import 'package:eventjar/model/notification_inbox/notification_inbox_model.dart';
import 'package:eventjar/notification/utils/notification_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NotificationInboxController extends GetxController {
  final state = NotificationInboxState();
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !state.isLoadingMore.value &&
        state.hasMore.value) {
      loadMore();
    }
  }

  static const int _limit = 10;

  Future<void> fetchNotifications() async {
    state.isLoading.value = true;
    state.currentOffset.value = 0;
    state.hasMore.value = true;
    try {
      final result = await NotificationApi.getNotificationInbox(
        offset: 0,
        limit: _limit,
      );
      final data = result.data ?? [];
      state.notifications.value = data;
      state.hasMore.value = data.length >= _limit;
    } catch (_) {
      state.notifications.value = [];
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore.value || !state.hasMore.value) return;
    state.isLoadingMore.value = true;
    try {
      final nextOffset = state.currentOffset.value + _limit;
      final result = await NotificationApi.getNotificationInbox(
        offset: nextOffset,
        limit: _limit,
      );
      final data = result.data ?? [];
      state.notifications.addAll(data);
      state.currentOffset.value = nextOffset;
      state.hasMore.value = data.length >= _limit;
    } catch (_) {
      // keep existing list on error
    } finally {
      state.isLoadingMore.value = false;
    }
  }


  int get unreadCount =>
      state.notifications.where((n) => n.isRead != true).length;

  Future<void> handleTap(Datum item) async {
    if (state.navigatingId.value.isNotEmpty) return;
    HapticFeedback.lightImpact();
    state.navigatingId.value = item.id ?? '';
    await Future.wait([
      markAsRead(item.id),
      Future.delayed(const Duration(milliseconds: 400)),
    ]);
    state.navigatingId.value = '';
    if (item.triggerKey != null) {
      navigateBasedOnNotificationType(item.triggerKey!);
    }
  }

  Future<void> markAsRead(String? id) async {
    if (id == null) return;
    final index = state.notifications.indexWhere((n) => n.id == id);
    if (index != -1 && state.notifications[index].isRead != true) {
      final updated = Datum.fromJson({
        ...state.notifications[index].toJson(),
        'isRead': true,
      });
      state.notifications[index] = updated;
      state.notifications.refresh();
      await NotificationApi.markNotificationAsRead(id);
    }
  }

  void markAllAsRead() {
    state.notifications.value = state.notifications
        .map((n) => Datum.fromJson({...n.toJson(), 'isRead': true}))
        .toList();
    NotificationApi.markAllNotificationsAsRead();
  }

  @override
  void onClose() {
    scrollController.dispose();
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().fetchUserProfile();
    }
    super.onClose();
  }
}
