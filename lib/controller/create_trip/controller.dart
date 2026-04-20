import 'package:eventjar/controller/create_trip/state.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTripController extends GetxController {
  final state = CreateTripState();

  final formKey = GlobalKey<FormState>();

  final appBarTitle = "Create Trip";

  @override
  void onInit() {
    super.onInit();
    fetchContacts(initial: true);
  }

  // Form Controllers
  final tripNameController = TextEditingController();
  final destinationController = TextEditingController();
  final budgetController = TextEditingController();
  final descriptionController = TextEditingController();

  /// 🔥 FETCH CONTACTS
  Future<void> fetchContacts({bool initial = false}) async {
    // try {
    //   if (initial) {
    //     state.isDropdownLoading.value = true;
    //     state.page = 1;
    //     state.contacts.clear();
    //   }

    //   /// 🔥 Simulate API
    //   await Future.delayed(const Duration(milliseconds: 800));

    //   List<MobileContact> newData = List.generate(
    //     10,
    //     (index) => MobileContact(
    //       id: "${state.page}-$index",
    //       name: "User ${state.page}-$index",
    //       email: "user${index}@mail.com",
    //     ),
    //   );

    //   state.contacts.addAll(newData);
    //   state.page++;
    //   state.hasMore = state.page < 5; // simulate end
    // } finally {
    //   state.isDropdownLoading.value = false;
    //   state.isDropdownLoadMoreLoading.value = false;
    // }
  }

  /// 🔥 SEARCH
  void onSearchChanged(String value) {
    state.searchQuery.value = value;
    fetchContacts(initial: true);
  }

  /// 🔥 LOAD MORE
  void onLoadMoreClicked() {
    if (!state.hasMore || state.isDropdownLoadMoreLoading.value) return;

    state.isDropdownLoadMoreLoading.value = true;
    fetchContacts();
  }

  /// 🔥 REFRESH
  void onRefreshClicked() {
    fetchContacts(initial: true);
  }

  /// 🔥 CLEAR FORM
  void clearForm() {
    tripNameController.clear();
    destinationController.clear();
    budgetController.clear();
    descriptionController.clear();
    state.selectedFriendsMap.clear();
  }

  /// 🔥 SUBMIT
  Future<void> submit() async {
    if (state.isLoading.value) return;

    state.isLoading.value = true;

    try {
      final data = {
        "tripName": tripNameController.text.trim(),
        "destination": destinationController.text.trim(),
        "budget": budgetController.text.trim(),
        "description": descriptionController.text.trim(),
        "friends": state.selectedFriendsMap.values.map((e) => e.id).toList(),
      };

      /// 🔥 Simulate API
      await Future.delayed(const Duration(seconds: 1));

      debugPrint("CREATE TRIP DATA => $data");

      Get.snackbar("Success", "Trip created successfully");

      clearForm();
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      state.isLoading.value = false;
    }
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
