import 'package:dio/dio.dart';
import 'package:eventjar/api/add_contact_api/add_contact_api.dart';
import 'package:eventjar/controller/qr_add_contact/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/model/contact/qr_contact_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

enum AddContactContactStage {
  newContact,
  followup24h,
  followup7d,
  followup30d,
  qualified,
}

class QrAddContactController extends GetxController {
  var appBarTitle = "Add Contact";
  final state = QrContactState();

  final formKey = GlobalKey<FormState>();

  String? contactId;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final notesController = TextEditingController();
  final tagController = TextEditingController();

  final selectedStage = AddContactContactStage.newContact.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void handleArgs(QrContactModel contact) {
    state.contacts.value = contact;
    nameController.text = contact.name;
    emailController.text = contact.email;
    final localNumber = getLocalNumberSimple(contact.number);
    phoneController.text = localNumber;
  }

  String getLocalNumberSimple(String? phone) {
    if (phone == null || phone.isEmpty) return '';

    if (phone.startsWith('+') && phone.length > 3) {
      return phone.substring(3);
    }

    return phone;
  }

  void clearForm() {
    QrContactModel? contact = state.contacts.value;

    if (contact != null) {
      nameController.text = contact.name;
      emailController.text = contact.email;
      final localNumber = getLocalNumberSimple(contact.number);
      phoneController.text = localNumber;
      notesController.clear();
      state.selectedStage.value = {
        'key': AddContactContactStage.newContact.toString(),
        'value': 'New Contact', // set to proper display string
      };
      state.selectedTags.clear();
    } else {
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      notesController.clear();
      state.selectedCountryCode.value = '+91';
      state.selectedStage.value = {
        'key': AddContactContactStage.newContact.toString(),
        'value': 'New Contact', // set to proper display string
      };
      state.selectedTags.clear();
    }

    formKey.currentState?.reset();
  }

  Map<String, dynamic> _gatherFormData() {
    final phoneWithCode =
        '${state.selectedCountryCode.value}${phoneController.text.trim()}';

    return {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneWithCode,
      'stage': state.selectedStage.value['key'],
      'tags': state.selectedTags.toList(),
      'notes': notesController.text.trim(),
    };
  }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    try {
      state.isLoading.value = true;
      final data = _gatherFormData();

      await AddContactApi.registerTicket(data: data);

      clearForm();

      Navigator.pop(context);
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }
        ApiErrorHandler.handleError(err, "Failed to add contact");
      } else {
        AppSnackbar.error(
          title: "Failed",
          message: "Something went wrong. Please try again.",
        );
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  void selectStage(Map<String, String> stage) {
    state.selectedStage.value = stage;
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage);
  }

  void addTag(String tag) {
    final lowerTag = tag.trim().toLowerCase();
    if (lowerTag.isEmpty) return;

    final exists = state.selectedTags.any((t) => t.toLowerCase() == lowerTag);

    if (!exists) {
      state.selectedTags.add(tag.trim());
    }
  }

  void toggleTagSelection(String tag) {
    if (state.selectedTags.contains(tag)) {
      state.selectedTags.remove(tag);
    } else {
      state.selectedTags.add(tag);
    }
  }

  String contactStageToKey(ContactStage stage) {
    switch (stage) {
      case ContactStage.newContact:
        return 'new';
      case ContactStage.followup24h:
        return 'followup_24h';
      case ContactStage.followup7d:
        return 'followup_7d';
      case ContactStage.followup30d:
        return 'followup_30d';
      case ContactStage.qualified:
        return 'qualified';
    }
  }
}
