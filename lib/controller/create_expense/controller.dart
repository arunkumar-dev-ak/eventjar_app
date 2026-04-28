import 'package:eventjar/controller/create_expense/state.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateExpenseController extends GetxController {
  final state = CreateExpenseState();

  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  final appBarTitle = "Create Expense";

  @override
  void onInit() {
    super.onInit();
  }

  // SUBMIT
  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final data = {
      "title": titleController.text.trim(),
      "amount": amountController.text.trim(),
      "description": descriptionController.text.trim(),
      "category": state.selectedCategory.value,
      "members": state.selectedMembers.values.toList(),
    };

    debugPrint("Expense Data: $data");

    state.isLoading.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      state.isLoading.value = false;

      Get.snackbar(
        "Success",
        "Expense created",
        snackPosition: SnackPosition.BOTTOM,
      );

      clearForm();
    });
  }

  // CLEAR
  void clearForm() {
    titleController.clear();
    amountController.clear();
    descriptionController.clear();

    state.selectedCategory.value = "Shopping";
    state.selectedMembers.clear();
  }

  // DROPDOWN EVENTS
  void onSearchMembers(String val) {}

  void onLoadMoreMembers() {}

  void onRefreshMembers() {}

  //navigation
  void navigateToAddFriend() {
    Get.toNamed(RouteName.addFriendPage)?.then((result) async {
      // if (result == "logged_in") {
      //   await fetchContactsOnFirstLoad();
      // } else {
      //   Get.back();
      // }
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
