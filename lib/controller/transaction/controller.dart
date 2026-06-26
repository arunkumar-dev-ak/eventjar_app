import 'package:eventjar/api/transaction_api/transaction_api.dart';
import 'package:eventjar/controller/transaction/state.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  final state = TransactionState();
  final scrollController = ScrollController();

  late Worker _dateWorker;

  @override
  void onInit() {
    super.onInit();

    _dateWorker = ever(state.selectedDate, (_) => fetchTransactions());

    scrollController.addListener(_onScroll);

    fetchTransactions();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (state.hasNextPage.value && !state.isLoadingMore.value) {
        fetchMoreTransactions();
      }
    }
  }

  Map<String, dynamic> _buildQueryParams({String? cursor}) {
    final date = state.selectedDate.value;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final queryParams = <String, dynamic>{
      'startDate': startOfDay.toUtc().toIso8601String(),
      'limit': 10,
    };
    if (cursor != null) {
      queryParams['cursor'] = cursor;
    }
    return queryParams;
  }

  Future<void> fetchTransactions() async {
    state.isLoading.value = true;
    try {
      final response = await TransactionApi.getTransactions(
        queryParams: _buildQueryParams(),
      );

      state.transactions.value = response.data.transactions;
      state.dailyTotal.value = response.data.dailyTotal;
      state.nextCursor.value = response.meta.paging.cursors.next;
      state.hasNextPage.value = response.meta.paging.hasNextPage;
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_load_transactions".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          Get.offAllNamed(RouteName.signInPage);
        },
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> fetchMoreTransactions() async {
    if (state.isLoadingMore.value) return;

    state.isLoadingMore.value = true;
    try {
      final response = await TransactionApi.getTransactions(
        queryParams: _buildQueryParams(cursor: state.nextCursor.value),
      );

      state.transactions.addAll(response.data.transactions);
      state.nextCursor.value = response.meta.paging.cursors.next;
      state.hasNextPage.value = response.meta.paging.hasNextPage;
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_load_transactions".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          Get.offAllNamed(RouteName.signInPage);
        },
      );
    } finally {
      state.isLoadingMore.value = false;
    }
  }

  void previousMonth() {
    if (state.displayedYear.value == 2025 && state.displayedMonth.value == 1) {
      return;
    }
    if (state.displayedMonth.value == 1) {
      state.displayedMonth.value = 12;
      state.displayedYear.value--;
    } else {
      state.displayedMonth.value--;
    }
  }

  void nextMonth() {
    if (state.displayedMonth.value == 12) {
      state.displayedMonth.value = 1;
      state.displayedYear.value++;
    } else {
      state.displayedMonth.value++;
    }
  }

  void setMonthYear(int month, int year) {
    state.displayedMonth.value = month;
    state.displayedYear.value = year;
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    _dateWorker.dispose();
    super.onClose();
  }
}
