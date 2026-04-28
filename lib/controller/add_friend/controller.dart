import 'package:eventjar/controller/add_friend/state.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFriendController extends GetxController {
  final state = AddFriendState();

  final formKey = GlobalKey<FormState>();

  final String appBarTitle = "Add Friend";

  /// 🔹 Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void onInit() {
    /// Default type
    state.selectedType.value = AddFriendType.contact;

    /// Dummy contacts (for now)
    _loadDummyContacts();

    super.onInit();
  }

  /// ================= CHANGE TYPE =================
  void changeType(AddFriendType type) {
    state.selectedType.value = type;

    /// Reset form
    clearForm();
  }

  /// ================= SELECT CONTACT =================
  void onContactSelected(MobileContact contact) {
    state.selectedContact.value = contact;

    /// 🔥 Auto-fill fields
    nameController.text = contact.name ?? '';
    emailController.text = contact.email ?? '';
    phoneController.text = contact.phone ?? '';
  }

  /// ================= CLEAR =================
  void clearForm() {
    state.selectedContact.value = null;

    nameController.clear();
    emailController.clear();
    phoneController.clear();

    state.sendViaEmail.value = false;
    state.sendViaPhone.value = false;
  }

  /// ================= SUBMIT =================
  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    state.isLoading.value = true;

    final data = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "sendEmail": state.sendViaEmail.value,
      "sendPhone": state.sendViaPhone.value,
      "type": state.selectedType.value?.name,
      "contact": state.selectedContact.value,
    };

    /// 🔥 Debug output
    debugPrint("Add Friend Data: $data");

    Future.delayed(const Duration(seconds: 1), () {
      state.isLoading.value = false;

      Get.snackbar(
        "Success",
        "Friend added successfully",
        snackPosition: SnackPosition.BOTTOM,
      );

      clearForm();
    });
  }

  /// ================= DUMMY DATA =================
  void _loadDummyContacts() {
    // state.contacts.assignAll([
    //   MobileContact(
    //     id: "1",
    //     name: "Rahul Kumar",
    //     email: "rahul@gmail.com",
    //     phone: "9876543210",
    //     stage: ContactStage.followup24h,
    //     status: "Active",
    //     nextFollowUpDate: DateTime.now(),
    //     createdAt: DateTime.now(),
    //     updatedAt: DateTime.now(),
    //     meetingScheduled: true,
    //     isOverdue: true,
    //     meetingConfirmed: true,
    //     meetingCompleted: true,
    //     isEventJarUser: true,
    //     tags: [],
    //   ),
    //   MobileContact(
    //     id: "2",
    //     name: "Arun",
    //     email: "arun@gmail.com",
    //     phone: "9123456780",
    //     stage: ContactStage.followup24h,
    //     status: "Active",
    //     nextFollowUpDate: DateTime.now(),
    //     createdAt: DateTime.now(),
    //     updatedAt: DateTime.now(),
    //     meetingScheduled: true,
    //     isOverdue: true,
    //     meetingConfirmed: true,
    //     meetingCompleted: true,
    //     isEventJarUser: true,
    //     tags: [],
    //   ),
    //   MobileContact(
    //     id: "3",
    //     name: "Vignesh",
    //     email: "vignesh@gmail.com",
    //     phone: "9000000001",
    //     stage: ContactStage.followup24h,
    //     status: "Active",
    //     nextFollowUpDate: DateTime.now(),
    //     createdAt: DateTime.now(),
    //     updatedAt: DateTime.now(),
    //     meetingScheduled: true,
    //     isOverdue: true,
    //     meetingConfirmed: true,
    //     meetingCompleted: true,
    //     isEventJarUser: true,
    //     tags: [],
    //   ),
    // ]);
  }

  /// ================= DROPDOWN EVENTS =================
  void onSearchChanged(String? val) {
    /// hook API later
  }

  void onLoadMoreClicked() {
    /// pagination later
  }

  void onRefreshClicked() {
    /// refresh later
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
