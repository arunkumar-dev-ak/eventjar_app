import 'package:eventjar/api/create_expense_api/create_expense_api.dart';
import 'package:eventjar/api/expense_detail_api/expense_detail_api.dart';
import 'package:eventjar/controller/expense_detail/state.dart';
import 'package:eventjar/controller/view_trip/controller.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/view_trip/trip_expense_model.dart';
import 'package:eventjar/page/expense_detail/widget/expense_detail_edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseDetailController extends GetxController {
  final state = ExpenseDetailState();
  final scrollController = ScrollController();
  final nameController = TextEditingController();

  static const _limit = 10;
  int? itemIndex;

  @override
  void onInit() {
    super.onInit();
    UserStore.cancelAllRequests();

    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      final expense = args['expense'] as TripExpenseModel?;
      itemIndex = args['index'] as int?;
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

  Future<void> editExpenseName() async {
    final expense = state.expense.value;
    if (expense == null) return;

    nameController.text = expense.title;
    final currentText = expense.title.obs;

    await Get.dialog(
      barrierDismissible: !state.isEditLoading.value,
      PopScope(
        canPop: !state.isEditLoading.value,
        child: EditExpenseNameDialog(
          nameController: nameController,
          currentText: currentText,
          onSave: (newName) async {
            if (newName == expense.title) return true;

            try {
              await CreateExpenseApi.updateExpense(
                expenseId: expense.id,
                data: {'title': newName},
              );

              final updatedJson = expense.toJson();
              updatedJson['title'] = newName;

              final updatedExpenseModel = TripExpenseModel.fromJson(
                updatedJson,
              );
              state.expense.value = updatedExpenseModel;
              state.appBarTitle.value = newName;

              if (Get.isRegistered<ViewTripController>() && itemIndex != null) {
                Get.find<ViewTripController>().updateExpenseSafely(
                  updatedExpenseModel,
                  itemIndex!,
                );
              }

              AppSnackbar.success(
                title: 'success'.tr,
                message: 'expense_updated'.tr,
              );

              return true; // Tells the dialog to close
            } catch (err) {
              LoggerService.loggerInstance.e(err);
              ApiErrorHandler.handle(
                error: err,
                title: "Update expense name error",
                onUnauthorized: () {
                  UserStore.to.clearStore();
                },
              );

              return false;
            }
          },
        ),
      ),
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
