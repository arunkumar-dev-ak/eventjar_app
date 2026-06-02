import 'package:dio/dio.dart';
import 'package:eventjar/api/budget_track_api/budget_track_api.dart';
import 'package:eventjar/controller/budget_track/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/budget_track/trip_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BudgetTrackController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final state = BudgetTrackState();

  static const int _limit = 10;
  final ScrollController tripScrollController = ScrollController();
  late AnimationController animation;

  @override
  void onInit() {
    super.onInit();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    tripScrollController.addListener(_onScroll);

    fetchTrips();
  }

  void _onScroll() {
    if (!tripScrollController.hasClients) return;

    final maxScroll = tripScrollController.position.maxScrollExtent;
    final currentScroll = tripScrollController.position.pixels;

    const double prefetchThreshold = 200.0;

    if (maxScroll - currentScroll <= prefetchThreshold) {
      if (hasMore && !state.isPaginationLoading.value) {
        fetchTripsOnScroll();
      }
    }
  }

  void toggleNotes(int index) {
    state.expandedNotes[index] = !(state.expandedNotes[index] ?? false);
  }

  bool isExpanded(int index) {
    return state.expandedNotes[index] ?? false;
  }

  //fetching trips
  int _getLimit() {
    return _limit;
  }

  int _getNextOffset() {
    return state.trips.length;
  }

  bool get hasMore {
    final meta = state.meta.value;

    if (meta == null) {
      return true;
    }

    return meta.paging.pages.next != null;
  }

  Map<String, dynamic> getQueryParams({bool onRefresh = false}) {
    return {'offset': onRefresh ? 0 : _getNextOffset(), 'limit': _getLimit()};
  }

  Future<void> fetchTrips() async {
    try {
      state.isLoading.value = true;

      final response = await BudgetTrackApi.getTrips(
        queryParams: {'offset': 0, 'limit': _limit},
      );

      state.trips.value = response.data;
      state.meta.value = response.meta;
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "Failed to load trips",
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> refreshTrips() async {
    if (state.isPaginationLoading.value) {
      return;
    }
    try {
      final response = await BudgetTrackApi.getTrips(
        queryParams: getQueryParams(onRefresh: true),
      );

      state.trips.value = response.data;
      state.meta.value = response.meta;
    } catch (err) {
      LoggerService.loggerInstance.e('Trip refresh error: $err');
      ApiErrorHandler.handle(
        error: err,
        title: "Failed to load trips",
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    }
  }

  Future<void> fetchTripsOnScroll() async {
    try {
      state.isPaginationLoading.value = true;

      final response = await BudgetTrackApi.getTrips(
        queryParams: getQueryParams(),
      );

      state.trips.addAll(response.data);
      state.meta.value = response.meta;
    } catch (err) {
      LoggerService.loggerInstance.e('Trip Loads onScroll error: $err');
      ApiErrorHandler.handle(
        error: err,
        title: "Failed to load Trips",
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isPaginationLoading.value = false;
    }
  }

  //navigation
  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage);
  }

  void navigateToFriendList() {
    Get.toNamed(RouteName.friendListPage)?.then((result) async {
      // if (result == "logged_in") {
      //   await fetchContactsOnFirstLoad();
      // } else {
      //   Get.back();
      // }
    });
  }

  void navigateToTransaction() {
    Get.toNamed(RouteName.transactionPage)?.then((result) async {
      // if (result == "logged_in") {
      //   await fetchContactsOnFirstLoad();
      // } else {
      //   Get.back();
      // }
    });
  }

  void navigateToAddFriend() {
    Get.toNamed(RouteName.addFriendPage)?.then((result) async {
      // if (result == "logged_in") {
      //   await fetchContactsOnFirstLoad();
      // } else {
      //   Get.back();
      // }
    });
  }

  void navigateToCreateTrip() {
    Get.toNamed(RouteName.createTripPage)?.then((result) async {
      // if (result == "logged_in") {
      //   await fetchContactsOnFirstLoad();
      // } else {
      //   Get.back();
      // }
    });
  }

  void navigateToCreateExpense() {
    Get.toNamed(RouteName.createExpensePage)?.then((result) async {
      // if (result == "logged_in") {
      //   await fetchContactsOnFirstLoad();
      // } else {
      //   Get.back();
      // }
    });
  }

  void navigateToViewTrip(TripModel trip) {
    Get.toNamed(
      RouteName.viewTripPage,
      arguments: trip,
    )?.then((result) async {});
  }

  @override
  void onClose() {
    animation.dispose();
    tripScrollController.dispose();
    super.onClose();
  }
}
