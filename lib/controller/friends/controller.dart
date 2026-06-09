import 'package:eventjar/api/friends_api/friends_api.dart';
import 'package:eventjar/controller/friends/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/budget_track/split_track_friend_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum FriendAction { accept, reject, remove }

class FriendsController extends GetxController {
  final state = FriendsState();

  final ScrollController friendScrollController = ScrollController();

  final int _limit = 20;

  @override
  void onInit() {
    super.onInit();

    friendScrollController.addListener(_onScroll);

    fetchFriendsFirstLoad();
  }

  bool get hasNextPage => state.pagination.value?.hasNext ?? false;

  void _onScroll() {
    if (!friendScrollController.hasClients) return;

    final maxScroll = friendScrollController.position.maxScrollExtent;
    final currentScroll = friendScrollController.position.pixels;

    if (maxScroll - currentScroll <= 200) {
      if (hasNextPage &&
          !state.isPaginationLoading.value &&
          !state.isLoading.value) {
        fetchFriendsOnScroll();
      }
    }
  }

  Map<String, dynamic> getQueryParams({bool refresh = false}) {
    return {
      "page": refresh ? 1 : ((state.pagination.value?.page ?? 1) + 1),
      "limit": _limit,
    };
  }

  Future<void> fetchFriendsFirstLoad() async {
    try {
      state.isLoading.value = true;

      final response = await FriendsApi.getFriends(
        queryParams: getQueryParams(refresh: true),
      );

      state.friends.assignAll(response.data);
      state.pagination.value = response.pagination;
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "Failed to load friends",
        onUnauthorized: () {
          UserStore.to.clearStore();
        },
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> refreshFriends() async {
    try {
      final response = await FriendsApi.getFriends(
        queryParams: getQueryParams(refresh: true),
      );

      state.friends.assignAll(response.data);
      state.pagination.value = response.pagination;
    } catch (err) {
      ApiErrorHandler.handle(error: err, title: "Failed to refresh friends");
    }
  }

  Future<void> fetchFriendsOnScroll() async {
    try {
      state.isPaginationLoading.value = true;

      final response = await FriendsApi.getFriends(
        queryParams: getQueryParams(),
      );

      state.friends.addAll(response.data);
      state.pagination.value = response.pagination;
    } catch (err) {
      ApiErrorHandler.handle(error: err, title: "Failed to load more friends");
    } finally {
      state.isPaginationLoading.value = false;
    }
  }

  Future<void> acceptFriend(SplitTrackFriend friend) async {
    try {
      state.isLoading.value = true;

      await FriendsApi.acceptFriends(id: friend.id);

      AppSnackbar.success(
        title: "friend_accepted".tr,
        message: "${friend.name} added successfully",
      );

      await fetchFriendsFirstLoad();
    } catch (err) {
      ApiErrorHandler.handle(error: err, title: "failed_accept_friend".tr);
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> rejectFriend(SplitTrackFriend friend) async {
    try {
      state.isLoading.value = true;

      await FriendsApi.rejectFriends(id: friend.id);

      AppSnackbar.success(
        title: "invitation_rejected".tr,
        message: "${friend.name} invitation rejected",
      );

      await fetchFriendsFirstLoad();
    } catch (err) {
      ApiErrorHandler.handle(error: err, title: "failed_reject_friend".tr);
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> deleteFriend(SplitTrackFriend friend) async {
    try {
      state.isLoading.value = true;

      await FriendsApi.deleteFriends(id: friend.id);

      AppSnackbar.success(
        title: "friend_removed".tr,
        message: "${friend.name} removed successfully",
      );

      state.friends.removeWhere((e) => e.id == friend.id);
    } catch (err) {
      ApiErrorHandler.handle(error: err, title: "failed_remove_friend".tr);
    } finally {
      state.isLoading.value = false;
    }
  }

  void navigateToAddFriend() {
    Get.toNamed(RouteName.addFriendPage)?.then((result) async {
      if (result == "refresh") {
        await fetchFriendsFirstLoad();
      }
    });
  }

  @override
  void onClose() {
    friendScrollController.dispose();
    super.onClose();
  }
}
