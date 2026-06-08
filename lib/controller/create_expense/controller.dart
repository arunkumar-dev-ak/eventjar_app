import 'dart:async';
import 'package:dio/dio.dart';
import 'package:eventjar/api/create_expense_api/create_expense_api.dart';
import 'package:eventjar/controller/create_expense/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateExpenseController extends GetxController {
  final state = CreateExpenseState();
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  var appBarTitle = "create_expense".tr;

  // Trip ID from arguments
  late final String tripId;
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    tripId = Get.arguments?['tripId'] ?? '';
    fetchMembers();
  }

  String get myUserId => UserStore.to.profile['id'] ?? '';

  // Helper to find the current user in the member list to set as default Payer
  void _setDefaultPayer() {
    if (state.paidBy.value != null || state.members.isEmpty) return;

    try {
      final me = state.members.firstWhere((m) {
        if (m.userId == myUserId) return true;
        if (m.friend != null) {
          return m.friend!['userId'] == myUserId ||
              m.friend!['friendUserId'] == myUserId;
        }
        return false;
      });
      state.paidBy.value = me;
    } catch (e) {
      state.paidBy.value = state.members.first;
    }
  }

  void fetchMembers() {
    state.isMembersLoading.value = true;
    try {
      CreateExpenseApi.getDropdownMembers(
            queryParams: {'tripId': tripId, 'limit': 25, 'offset': 0},
          )
          .then((response) {
            state.members.value = response.data;
            state.meta.value = response.meta;
            _setDefaultPayer();
          })
          .catchError((error) {
            _handleApiError(error, 'Failed to load trip members');
          })
          .whenComplete(() {
            state.isMembersLoading.value = false;
          });
    } catch (e) {
      state.isMembersLoading.value = false;
    }
  }

  void onSearchMembers(String? val) {
    if (state.isMembersLoading.value) return;

    final String query = val?.trim() ?? '';
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    state.isMembersLoading.value = true;

    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      try {
        CreateExpenseApi.getDropdownMembers(
              queryParams: {
                'tripId': tripId,
                'limit': 25,
                'offset': 0,
                if (query.isNotEmpty) 'search': query,
              },
            )
            .then((response) {
              LoggerService.loggerInstance.dynamic_d(response.data);
              state.members.value = response.data;
              state.meta.value = response.meta;
            })
            .catchError((error) {
              _handleApiError(error, 'Search failed');
            })
            .whenComplete(() {
              state.isMembersLoading.value = false;
            });
      } catch (e) {
        state.isMembersLoading.value = false;
      }
    });
  }

  void onLoadMoreMembers() {
    if (state.isMembersLoadMoreLoading.value) return;

    final currentMeta = state.meta.value;
    if (currentMeta == null || currentMeta.paging.links.next == null) return;

    state.isMembersLoadMoreLoading.value = true;

    try {
      final int nextPage = currentMeta.paging.pages.current + 1;

      CreateExpenseApi.getDropdownMembers(
            queryParams: {'tripId': tripId, 'limit': 25, 'offset': nextPage},
          )
          .then((response) {
            state.members.addAll(response.data);
            state.meta.value = response.meta;
          })
          .catchError((error) {
            _handleApiError(error, 'Load more failed');
          })
          .whenComplete(() {
            state.isMembersLoadMoreLoading.value = false;
          });
    } catch (e) {
      state.isMembersLoadMoreLoading.value = false;
    }
  }

  void onRefreshMembers() {
    fetchMembers();
  }

  void _handleApiError(Object? error, String fallbackMsg) {
    LoggerService.loggerInstance.e('Error In Create Expense Page: $error');
    ApiErrorHandler.handle(
      error: error,
      title: "error".tr,
      onUnauthorized: () {
        UserStore.to.clearStore();
        Get.toNamed(RouteName.signInPage);
      },
    );
  }

  void submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final payer = state.paidBy.value;
    if (payer == null) {
      Get.snackbar(
        "error".tr,
        "something_went_wrong".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (state.selectedMembers.isEmpty) {
      Get.snackbar(
        "error".tr,
        "select_friend_error".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Perfectly matches the DTO array layout we created
    List<Map<String, dynamic>> participants = state.selectedMembers.values
        .map((m) => {"memberId": m.id})
        .toList();

    // Map your frontend string to your backend enum format if needed
    // (e.g., "Shopping" -> "shopping")
    String mappedCategory =
        state.selectedCategory.value?.toLowerCase() ?? 'other';

    final data = {
      "title": titleController.text.trim(),
      "amount": double.tryParse(amountController.text.trim()) ?? 0,
      "description": descriptionController.text.trim(),
      "category": mappedCategory,
      "splitType": "equal",
      "tripId": tripId,
      "paidByMemberId": payer.id,
      "participants": participants,
    };

    state.isLoading.value = true;

    try {
      await CreateExpenseApi.createExpense(data: data);
      AppSnackbar.success(title: "expense_created".tr, message: "success".tr);
      Navigator.pop(Get.context!, "refresh");
    } catch (error) {
      _handleApiError(error, 'Failed to create expense');
    } finally {
      state.isLoading.value = false;
    }
  }

  void clearForm() {
    titleController.clear();
    amountController.clear();
    descriptionController.clear();
    state.selectedCategory.value = "Shopping";
    state.selectedMembers.clear();
    _setDefaultPayer();
  }

  void navigateToAddFriend() {
    Get.toNamed(RouteName.addFriendPage)?.then((result) {
      if (result == "logged_in") onRefreshMembers();
    });
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    titleController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
