import 'package:eventjar/api/create_expense_api/create_expense_api.dart';
import 'package:eventjar/api/expense_detail_api/expense_detail_api.dart';
import 'package:eventjar/controller/expense_detail/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
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

  Future<void> editExpenseName(BuildContext context) async {
    final expense = state.expense.value;
    if (expense == null) return;

    final nameController = TextEditingController(text: expense.title);

    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('edit_expense_name'.tr),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'expense_name'.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () {
              final text = nameController.text.trim();
              if (text.isNotEmpty) {
                Navigator.pop(ctx, text);
              }
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );

    if (newName == null || newName == expense.title) return;

    try {
      await CreateExpenseApi.updateExpense(
        expenseId: expense.id,
        data: {'title': newName},
      );

      final updatedJson = expense.toJson();
      updatedJson['title'] = newName;
      state.expense.value = TripExpenseModel.fromJson(updatedJson);
      state.appBarTitle.value = newName;
      state.hasEdited = true;

      AppSnackbar.success(
        title: 'success'.tr,
        message: 'expense_updated'.tr,
      );
    } catch (e) {
      LoggerService.loggerInstance.e("Update expense name error: $e");
      AppSnackbar.error(
        title: 'error'.tr,
        message: 'failed_update_expense'.tr,
      );
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
