import 'package:dio/dio.dart';
import 'package:eventjar/api/add_contact_api/add_contact_api.dart';
import 'package:eventjar/controller/add_contact/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/contact_model.dart';
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

class AddContactController extends GetxController {
  var appBarTitle = "Add Contact";
  final state = AddContactState();

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
    final args = Get.arguments;
    Contact? contact;

    // Adjust based on how you pass the argument
    if (args is Set<Contact> && args.isNotEmpty) {
      appBarTitle = "Update Contact";
      contact = args.first;
    } else if (args is Map && args.containsKey('contact')) {
      contact = args['contact'];
    }

    handleArgs(contact);

    super.onInit();
  }

  void handleArgs(Contact? contact) {
    if (contact == null) {
      contactId = null;
      return;
    }

    contactId = contact.id;

    nameController.text = contact.name;
    emailController.text = contact.email;
    //phoneController
    final localNumber = getLocalNumberSimple(contact.phone);
    phoneController.text = localNumber;
    notesController.text = contact.notes ?? '';

    // state.selectedCountryCode.value = contact.phoneCountryCode ?? '+91';

    final contactStageKey = contactStageToKey(contact.stage);
    final matchedStage = state.stages.firstWhere(
      (stage) => stage['key'] == contactStageKey,
      orElse: () => {'key': 'new', 'value': 'New Contact'},
    );
    state.selectedStage.value = matchedStage;

    // Set tags or clear if none
    if (contact.tags.isNotEmpty) {
      state.selectedTags.value = List<String>.from(contact.tags);
    } else {
      state.selectedTags.clear();
    }
  }

  String getLocalNumberSimple(String? phone) {
    if (phone == null || phone.isEmpty) return '';

    if (phone.startsWith('+') && phone.length > 3) {
      return phone.substring(3);
    }

    return phone;
  }

  void clearForm() {
    final args = Get.arguments;
    Contact? contact;

    if (args is Set<Contact> && args.isNotEmpty) {
      handleArgs(contact);
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

      if (checkIsForUpdate()) {
        if (contactId == null) {
          throw Exception("Contact ID is required for update");
        }
        await AddContactApi.updateContact(data: data, id: contactId!);
      } else {
        await AddContactApi.registerTicket(data: data);
      }

      clearForm();
      contactId = null;
      Navigator.pop(context, "refresh");
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }
        ApiErrorHandler.handleError(err, "Failed to add/update contact");
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

  bool checkIsForUpdate() {
    return contactId != null && contactId!.isNotEmpty;
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
