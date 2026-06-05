import 'package:currency_picker/currency_picker.dart';
import 'package:eventjar/api/split_track_api/split_track_api.dart';
import 'package:eventjar/controller/create_trip/state.dart';
import 'package:eventjar/model/budget_track/split_track_friend_model.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/route_name.dart';

class CreateTripController extends GetxController {
  final state = CreateTripState();

  final formKey = GlobalKey<FormState>();

  var appBarTitle = "create_trip".tr;

  static const _limit = 20;

  @override
  void onInit() {
    super.onInit();
    fetchFriends(initial: true);
  }

  // Form Controllers
  final tripNameController = TextEditingController();
  final destinationController = TextEditingController();
  final budgetController = TextEditingController();
  final descriptionController = TextEditingController();

  // Currency
  void selectCurrency(Currency currency) {
    state.selectedCurrency.value = currency;
  }

  // Fetch Friends
  Future<void> fetchFriends({bool initial = false}) async {
    try {
      if (initial) {
        state.isDropdownLoading.value = true;
        state.page = 1;
        state.friends.clear();
      }

      final queryParams = <String, dynamic>{
        'page': state.page,
        'limit': _limit,
      };

      final search = state.searchQuery.value.trim();
      if (search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await SplitTrackApi.getFriends(queryParams: queryParams);

      if (initial) {
        state.friends.value = response.data;
      } else {
        state.friends.addAll(response.data);
      }

      state.hasMore = response.pagination.hasNext;
      state.page = response.pagination.page + 1;
    } catch (err) {
      LoggerService.loggerInstance.e('Fetch friends error: $err');
      ApiErrorHandler.handle(
        error: err,
        title: "Failed to load Friends",
        onUnauthorized: () {
          UserStore.to.clearStore();
          Get.toNamed(RouteName.signInPage);
        },
      );
    } finally {
      state.isDropdownLoading.value = false;
      state.isDropdownLoadMoreLoading.value = false;
    }
  }

  void onSearchChanged(String value) {
    state.searchQuery.value = value;
    fetchFriends(initial: true);
  }

  void onLoadMoreClicked() {
    if (!state.hasMore || state.isDropdownLoadMoreLoading.value) return;

    state.isDropdownLoadMoreLoading.value = true;
    fetchFriends();
  }

  void onRefreshClicked() {
    fetchFriends(initial: true);
  }

  // Clear Form
  void clearForm() {
    tripNameController.clear();
    destinationController.clear();
    budgetController.clear();
    descriptionController.clear();
    state.selectedFriendsMap.clear();
    state.selectedCurrency.value = CurrencyService().findByCode('INR')!;
  }

  // Submit
  Future<void> submit() async {
    if (state.isLoading.value) return;

    if (state.selectedFriendsMap.isEmpty) {
      AppSnackbar.warning(message: "select_friend_error".tr);
      return;
    }

    state.isLoading.value = true;

    try {
      final budget = double.tryParse(budgetController.text.trim()) ?? 0;

      final body = {
        "name": tripNameController.text.trim(),
        "description": descriptionController.text.trim(),
        "destination": destinationController.text.trim(),
        "totalBudget": budget,
        "currency": state.selectedCurrency.value.symbol,
        "members": state.selectedFriendsMap.values
            .map((f) => _buildMemberEntry(f))
            .toList(),
      };

      await SplitTrackApi.createTrip(body: body);

      state.isLoading.value = false;

      Get.back(result: "created");

      AppSnackbar.success(title: "success".tr, message: "trip_created_success".tr);
    } catch (err) {
      LoggerService.loggerInstance.e('Create trip error: $err');
      ApiErrorHandler.handle(
        error: err,
        title: "Failed to create Trip",
        onUnauthorized: () {
          UserStore.to.clearStore();
          Get.toNamed(RouteName.signInPage);
        },
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  Map<String, String> _buildMemberEntry(SplitTrackFriend f) {
    final loggedUserId = UserStore.to.profile['id'] as String;

    // 1. Not registered — pass as friendId
    if (!f.isRegistered) {
      return {"friendId": f.id};
    }

    // 2. userId matches logged user — pass friendUserId as userId
    if (f.userId == loggedUserId) {
      return {"userId": f.friendUserId!};
    }

    // 3. friendUserId matches logged user — pass userId as userId
    if (f.friendUserId == loggedUserId) {
      return {"userId": f.userId};
    }

    return {"friendId": f.id};
  }

  @override
  void onClose() {
    tripNameController.dispose();
    destinationController.dispose();
    budgetController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
