import 'package:eventjar/api/expense_detail_api/expense_detail_api.dart';
import 'package:eventjar/controller/expense_detail/state.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/view_trip/trip_expense_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseDetailController extends GetxController {
  final state = ExpenseDetailState();
  final scrollController = ScrollController();

  static const _limit = 10;

  @override
  void onInit() {
    super.onInit();
    UserStore.cancelAllRequests();

    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      final expense = args['expense'] as TripExpenseModel?;
      if (expense != null) {
        state.expense.value = expense;
        state.appBarTitle.value = expense.title;
        _fetchParticipants();
      }
    }

    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        hasMore &&
        !state.isLoadingMore.value) {
      _loadMore();
    }
  }

  bool get hasMore {
    final meta = state.meta.value;
    if (meta == null) return true;
    return meta.paging.pages.next != null;
  }

  Future<void> _fetchParticipants() async {
    state.isLoading.value = true;
    state.hasError.value = false;

    try {
      final response = await ExpenseDetailApi.getParticipants(
        expenseId: state.expense.value!.id,
        limit: _limit,
        offset: 0,
      );
      state.participants.value = response.data;
      state.meta.value = response.meta;
    } catch (e) {
      LoggerService.loggerInstance.e("Expense participants error: $e");
      state.hasError.value = true;
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> _loadMore() async {
    state.isLoadingMore.value = true;

    try {
      final response = await ExpenseDetailApi.getParticipants(
        expenseId: state.expense.value!.id,
        limit: _limit,
        offset: state.participants.length,
      );
      state.participants.addAll(response.data);
      state.meta.value = response.meta;
    } catch (e) {
      LoggerService.loggerInstance.e("Load more participants error: $e");
    } finally {
      state.isLoadingMore.value = false;
    }
  }

  Future<void> onRefresh() async {
    state.hasError.value = false;

    try {
      final response = await ExpenseDetailApi.getParticipants(
        expenseId: state.expense.value!.id,
        limit: _limit,
        offset: 0,
      );
      state.participants.value = response.data;
      state.meta.value = response.meta;
    } catch (e) {
      LoggerService.loggerInstance.e("Refresh participants error: $e");
    }
  }

  Future<void> retry() async {
    await _fetchParticipants();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
