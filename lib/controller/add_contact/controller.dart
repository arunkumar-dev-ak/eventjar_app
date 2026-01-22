import 'package:dio/dio.dart';
import 'package:eventjar/api/add_contact_api/add_contact_api.dart';
import 'package:eventjar/controller/add_contact/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/model/contact/contact_tag_model.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/model/contact/nfc_contact_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import '../../model/card_info.dart';

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
  final searchTagsController = TextEditingController();

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
    // Handle NfcContactModel from NFC read
    if (args is NfcContactModel) {
      appBarTitle = "Add NFC Contact";
      handleNfcContact(args);
    } else if (args is VisitingCardInfo) {
      appBarTitle = "Add Card Contact";
      handleVisitingCardContact(args);
    } else if (args is MobileContact) {
      appBarTitle = "Update Contact";
      handleUpdate(args);
    }

    fetchTags();
    super.onInit();
  }

  void handleVisitingCardContact(VisitingCardInfo cardInfo) {
    contactId = null; // Always new contact from NFC
    state.clearButtonTitle.value = "Reset";

    nameController.text = cardInfo.name!;
    phoneController.text = cardInfo.phone!;
    emailController.text = cardInfo.email!;

    // Set default stage for NFC contacts
    state.selectedStage.value = {
      'key': AddContactContactStage.newContact.toString(),
      'value': 'New Contact',
    };

    state.selectedTagsMap.clear();
    formKey.currentState?.reset();
  }

  void handleNfcContact(NfcContactModel nfcContact) {
    contactId = null; // Always new contact from NFC
    state.clearButtonTitle.value = "Reset";
    nameController.text = nfcContact.name;
    phoneController.text = nfcContact.phone;
    emailController.text = nfcContact.email;
    notesController.text = nfcContact.note;

    // Set default stage for NFC contacts
    state.selectedStage.value = {
      'key': AddContactContactStage.newContact.toString(),
      'value': 'New Contact',
    };

    state.selectedTagsMap.clear();
    formKey.currentState?.reset();
  }

  void handleUpdate(MobileContact contact) {
    contactId = contact.id;
    state.clearButtonTitle.value = "Reset";

    nameController.text = contact.name;
    emailController.text = contact.email;
    //phoneController
    phoneController.text = contact.phoneParsed?.phoneNumber ?? "";
    notesController.text = contact.notes ?? '';

    final selectedCountryCode = contact.phoneParsed?.countryCode ?? "+91";
    final String cleanCountryCode = selectedCountryCode.replaceAll('+', '');
    state.selectedCountry.value = countries.firstWhere(
      (country) => country.fullCountryCode == cleanCountryCode,
    );

    final contactStageKey = contactStageToKey(contact.stage);
    final matchedStage = state.stages.firstWhere(
      (stage) => stage['key'] == contactStageKey,
      orElse: () => {'key': 'new', 'value': 'New Contact'},
    );
    if (state.selectedStage.value != matchedStage) {
      state.selectedStage.value = matchedStage;
    }

    if (contact.tags.isNotEmpty) {
      state.selectedTagsMap.clear();
      for (String tag in contact.tags) {
        final lowerKey = tag.toLowerCase().trim();
        state.selectedTagsMap[lowerKey] = tag;
      }
    } else {
      state.selectedTagsMap.clear();
    }
  }

  Future<void> fetchTags() async {
    try {
      state.isDropDownLoading.value = true;

      final List<TagModel> result = await AddContactApi.getTagList();
      state.availableTags.value = result.map((tag) => tag.name).toList();
      state.filteredTags.value = state.availableTags;
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to fetch analytics");
      } else {
        AppSnackbar.error(
          title: "Failed",
          message: "Something went wrong. Please try again.",
        );
      }
    } finally {
      state.isDropDownLoading.value = false;
    }
  }

  void clearForm() {
    final args = Get.arguments;

    // If NFC contact, reset to NFC data
    if (args is NfcContactModel) {
      appBarTitle = "Add NFC Contact";
      handleNfcContact(args);
    } else if (args is VisitingCardInfo) {
      appBarTitle = "Add Card Contact";
      handleVisitingCardContact(args);
    }
    // Adjust based on how you pass the argument
    else if (args is MobileContact) {
      appBarTitle = "Update Contact";
      handleUpdate(args);
    } else {
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      notesController.clear();
      state.selectedStage.value = {
        'key': AddContactContactStage.newContact.toString(),
        'value': 'New Contact',
      };
    }

    // Existing update logic
    // else if (args is Set<Contact> && args.isNotEmpty) {
    //   final argContact = args.first;
    //   handleArgs(argContact);
    // } else {
    //   nameController.clear();
    //   emailController.clear();
    //   phoneController.clear();
    //   notesController.clear();
    //   state.selectedCountryCode.value = '+91';
    //   state.selectedStage.value = {
    //     'key': AddContactContactStage.newContact.toString(),
    //     'value': 'New Contact', // set to proper display string
    //   };
    //   state.selectedTags.clear();
    // }

    formKey.currentState?.reset();
  }

  Map<String, dynamic> _gatherFormData() {
    final countryCode = state.selectedCountry.value.fullCountryCode;
    final localPhoneNumber = phoneController.text.trim();
    final fullPhoneNumber = '+$countryCode$localPhoneNumber';

    return {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': fullPhoneNumber,
      'stage': state.selectedStage.value['key'],
      'tags': state.selectedTagsMap.values.toList(),
      'notes': notesController.text.trim(),
    };
  }

  void selectTag(String tagName) {
    state.selectedTagsMap[tagName.toLowerCase()] = tagName;
  }

  void unSelectTag(String tagName) {
    state.selectedTagsMap.remove(tagName.toLowerCase());
  }

  void filterTags(String query) {
    if (query.isEmpty) {
      state.filteredTags.value = state.availableTags;
    } else {
      state.filteredTags.value = state.availableTags
          .where((tag) => tag.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update();
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

  void createNewTag(String tagName) {
    state.selectedTagsMap[tagName.toLowerCase()] = tagName;
  }

  void selectStage(Map<String, String> stage) {
    state.selectedStage.value = stage;
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage);
  }

  // void addTag(String tag) {
  //   final lowerTag = tag.trim().toLowerCase();
  //   if (lowerTag.isEmpty) return;

  //   final exists = state.selectedTags.any((t) => t.toLowerCase() == lowerTag);

  //   if (!exists) {
  //     state.selectedTags.add(tag.trim());
  //   }
  // }

  // void toggleTagSelection(String tag) {
  //   if (state.selectedTags.contains(tag)) {
  //     state.selectedTags.remove(tag);
  //   } else {
  //     state.selectedTags.add(tag);
  //   }
  // }

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

  String? validateName(String? val) {
    if (val == null || val.trim().isEmpty) return 'Name is required';
    if (val.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  // ✅ Email validator
  String? validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(val.trim())) return 'Enter valid email';
    return null;
  }

  @override
  void onClose() {
    searchTagsController.dispose();
    super.onClose();
  }
}
