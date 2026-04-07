import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:eventjar/global/utils/visiting_card_parser.dart';
import 'package:eventjar/logger_service.dart';
import 'package:get/get.dart';
import 'package:eventjar/api/add_contact_api/add_contact_api.dart';
import 'package:eventjar/controller/add_contact/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

import 'package:eventjar/model/contact/contact_model.dart';
import 'package:eventjar/model/contact/contact_tag_model.dart';
import 'package:eventjar/model/contact/mobile_contact_model.dart';
import 'package:eventjar/model/contact/nfc_contact_model.dart';
import 'package:eventjar/model/contact/qr_contact_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
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

  // Additional info from visiting card
  final phone2Controller = TextEditingController();
  final companyController = TextEditingController();
  final websiteController = TextEditingController();
  final addressController = TextEditingController();

  final selectedStage = AddContactContactStage.newContact.obs;

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    final args = Get.arguments;
    // Handle NfcContactModel from NFC read
    if (args is Map) {
      final VisitingCardInfo? cardInfo = args["cardInfo"];
      final File? imageFile = args["imageFile"];

      if (cardInfo != null) {
        appBarTitle = "Add Card Contact";
        handleVisitingCardContact(cardInfo);
      }

      if (imageFile != null) {
        state.selectedImage.value = imageFile;
        setSelectedImage(imageFile);
      }
    } else if (args is NfcContactModel) {
      appBarTitle = "Add NFC Contact";
      handleNfcContact(args);
    } else if (args is VisitingCardInfo) {
      appBarTitle = "Add Card Contact";
      handleVisitingCardContact(args);
    } else if (args is MobileContact) {
      appBarTitle = "Update Contact";
      handleUpdate(args);
    } else if (args is QrContactModel) {
      appBarTitle = "Add QR Scanned Contact";
      handleQrScanContact(args);
    }

    fetchTags();
    super.onInit();
  }

  void setSelectedImage(File file) {
    final fileSize = file.lengthSync();

    const maxSize = 5 * 1024 * 1024;

    LoggerService.loggerInstance.dynamic_d('$fileSize, $maxSize');

    if (fileSize > maxSize) {
      state.addWithImage.value = false;
      state.hideToogle.value = true;
    }
  }

  void handleVisitingCardContact(VisitingCardInfo cardInfo) {
    contactId = null; // Always new contact from card scan
    state.clearButtonTitle.value = "Reset";

    nameController.text = cardInfo.name ?? "";
    phoneController.text =
        cardInfo.phoneParsed?.phoneNumber ?? cardInfo.phone ?? "";
    emailController.text = cardInfo.email ?? "";

    // Set country code from parsed phone (same as NFC/QR flow)
    final selectedCountryCode = cardInfo.phoneParsed?.countryCode ?? "+91";
    final String cleanCountryCode = selectedCountryCode.replaceAll('+', '');
    state.selectedCountry.value = countries.firstWhere(
      (country) => country.fullCountryCode == cleanCountryCode,
      orElse: () => countries.first,
    );

    // Set default stage for scanned card contacts
    state.selectedStage.value = {'key': 'new', 'value': 'New Contact'};

    state.selectedTagsMap.clear();
    formKey.currentState?.reset();

    // Store card info and pre-fill additional info controllers
    state.visitingCardInfo.value = cardInfo;
    state.isFromCardScan.value = true;

    // Phone 2 — set country from parsed info, local number in controller
    if (cardInfo.phone2Parsed != null) {
      final cc = cardInfo.phone2Parsed!.countryCode.replaceAll('+', '');
      state.selectedPhone2Country.value = countries.firstWhere(
        (c) => c.fullCountryCode == cc,
        orElse: () => countries.firstWhere((c) => c.code == 'IN'),
      );
      phone2Controller.text = cardInfo.phone2Parsed!.phoneNumber;
    } else {
      state.selectedPhone2Country.value = countries.firstWhere(
        (c) => c.code == 'IN',
      );
      phone2Controller.text = cardInfo.phone2 ?? '';
    }
    // Force IntlPhoneField to fully rebuild so it reflects the restored value
    state.phone2FieldKey.value++;

    companyController.text = cardInfo.company ?? '';
    websiteController.text = cardInfo.website ?? '';
    addressController.text = cardInfo.address ?? '';

    // All unchecked by default — user selects manually
    state.additionalInfoSelection.value = {
      'phone2': false,
      'company': false,
      'website': false,
      'address': false,
    };
  }

  void toggleAdditionalField(String field) {
    state.additionalInfoSelection[field] =
        !(state.additionalInfoSelection[field] ?? false);
  }

  void toggleAllAdditionalFields() {
    // If all checked → uncheck all; otherwise check all
    final allChecked = state.additionalInfoSelection.values.every((v) => v);
    final newValue = !allChecked;
    state.additionalInfoSelection.value = {
      for (final key in state.additionalInfoSelection.keys) key: newValue,
    };
  }

  void handleQrScanContact(QrContactModel qrInfo) {
    contactId = null;
    state.clearButtonTitle.value = "Reset";

    nameController.text = qrInfo.name;

    phoneController.text = qrInfo.phoneParsed?.phoneNumber ?? "";
    final selectedCountryCode = qrInfo.phoneParsed?.countryCode ?? "+91";
    final String cleanCountryCode = selectedCountryCode.replaceAll('+', '');
    state.selectedCountry.value = countries.firstWhere(
      (country) => country.fullCountryCode == cleanCountryCode,
      orElse: () => countries.first,
    );

    emailController.text = qrInfo.email;

    state.selectedStage.value = {'key': 'new', 'value': 'New Contact'};

    state.selectedTagsMap.clear();
    formKey.currentState?.reset();

    state.isFromCardScan.value = false;
    phone2Controller.clear();
    companyController.clear();
    websiteController.clear();
    addressController.clear();
    state.additionalInfoSelection.value = {
      'phone2': false,
      'company': false,
      'website': false,
      'address': false,
    };
  }

  void handleNfcContact(NfcContactModel nfcContact) {
    contactId = null;
    state.clearButtonTitle.value = "Reset";
    nameController.text = nfcContact.name;
    phoneController.text = nfcContact.phoneParsed?.phoneNumber ?? "";
    final selectedCountryCode = nfcContact.phoneParsed?.countryCode ?? "+91";
    final String cleanCountryCode = selectedCountryCode.replaceAll('+', '');
    state.selectedCountry.value = countries.firstWhere(
      (country) => country.fullCountryCode == cleanCountryCode,
      orElse: () => countries.first,
    );
    emailController.text = nfcContact.email;
    notesController.text = nfcContact.note;

    state.selectedStage.value = {'key': 'new', 'value': 'New Contact'};

    state.selectedTagsMap.clear();
    formKey.currentState?.reset();

    state.isFromCardScan.value = false;
    phone2Controller.clear();
    companyController.clear();
    websiteController.clear();
    addressController.clear();
    state.additionalInfoSelection.value = {
      'phone2': false,
      'company': false,
      'website': false,
      'address': false,
    };
  }

  void handleUpdate(MobileContact contact) {
    contactId = contact.id;
    state.clearButtonTitle.value = "Reset";

    if (contact.visitingCardUrl != null) {
      state.existingImageUrl.value = contact.visitingCardUrl;
    }

    nameController.text = contact.name;
    emailController.text = contact.email;
    phoneController.text = contact.phoneParsed?.phoneNumber ?? "";
    notesController.text = contact.notes ?? '';

    final selectedCountryCode = contact.phoneParsed?.countryCode ?? "+91";
    final String cleanCountryCode = selectedCountryCode.replaceAll('+', '');
    state.selectedCountry.value = countries.firstWhere(
      (country) => country.fullCountryCode == cleanCountryCode,
      orElse: () => countries.first,
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

    // Show additional info section only for visiting card contacts
    state.isFromCardScan.value = contact.visitingCardUrl != null;

    // Pre-fill additional info from existing contact data
    companyController.text = contact.company ?? '';
    websiteController.text = contact.website ?? '';
    addressController.text = contact.address ?? '';

    // Phone 2 — restore country code and local number
    if (contact.phone2Parsed != null) {
      final cc = contact.phone2Parsed!.countryCode.replaceAll('+', '');
      state.selectedPhone2Country.value = countries.firstWhere(
        (c) => c.fullCountryCode == cc,
        orElse: () => countries.firstWhere((c) => c.code == 'IN'),
      );
      phone2Controller.text = contact.phone2Parsed!.phoneNumber;
    } else if (contact.phone2 != null && contact.phone2!.isNotEmpty) {
      phone2Controller.text = contact.phone2!;
    } else {
      state.selectedPhone2Country.value = countries.firstWhere(
        (c) => c.code == 'IN',
      );
      phone2Controller.clear();
    }
    // Force IntlPhoneField to fully rebuild so it reflects the restored value
    state.phone2FieldKey.value++;

    // Auto-check fields that already have data
    state.additionalInfoSelection.value = {
      'phone2': (contact.phone2 ?? '').isNotEmpty,
      'company': (contact.company ?? '').isNotEmpty,
      'website': (contact.website ?? '').isNotEmpty,
      'address': (contact.address ?? '').isNotEmpty,
    };
  }

  Future<void> fetchTags() async {
    try {
      state.isDropDownLoading.value = true;

      final List<TagModel> result = await AddContactApi.getTagList();
      LoggerService.loggerInstance.dynamic_d(result);
      state.availableTags.value = result.map((tag) => tag.name).toList();
      state.filteredTags.value = state.availableTags;
    } catch (err) {
      if (err is dio.DioException) {
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

    if (args is Map) {
      final VisitingCardInfo? cardInfo = args["cardInfo"];
      if (cardInfo != null) {
        handleVisitingCardContact(cardInfo);
        final File? imageFile = args["imageFile"];
        if (imageFile != null) state.selectedImage.value = imageFile;
      } else {
        _clearAllFields();
      }
    } else if (args is NfcContactModel) {
      handleNfcContact(args);
    } else if (args is VisitingCardInfo) {
      handleVisitingCardContact(args);
    } else if (args is MobileContact) {
      handleUpdate(args);
    } else if (args is QrContactModel) {
      handleQrScanContact(args);
    } else {
      _clearAllFields();
    }

    formKey.currentState?.reset();
  }

  void _clearAllFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    notesController.clear();
    phone2Controller.clear();
    companyController.clear();
    websiteController.clear();
    addressController.clear();
    state.isFromCardScan.value = false;
    state.isAdditionalInfoExpanded.value = false;
    state.selectedStage.value = {'key': 'new', 'value': 'New Contact'};
    state.additionalInfoSelection.value = {
      'phone2': false,
      'company': false,
      'website': false,
      'address': false,
    };
  }

  Map<String, dynamic> _gatherFormData() {
    final countryCode = state.selectedCountry.value.fullCountryCode;
    final localPhoneNumber = phoneController.text.trim();
    final fullPhoneNumber = '+$countryCode$localPhoneNumber';

    final data = <String, dynamic>{
      'name': capitalize(nameController.text.trim()),
      'email': emailController.text.trim(),
      'phone': fullPhoneNumber,
      'stage': state.selectedStage.value['key'],
      'tags': state.selectedTagsMap.values.toList(),
      'notes': notesController.text.trim(),
    };

    // Include additional info fields:
    // - For visiting card contacts: only if user checked the checkbox
    // - For other contacts (manual/QR/NFC): include if non-empty
    final isCard = state.isFromCardScan.value;
    final sel = state.additionalInfoSelection;

    final phone2Text = phone2Controller.text.trim();
    if (phone2Text.isNotEmpty && (!isCard || sel['phone2'] == true)) {
      final phone2CC = state.selectedPhone2Country.value.fullCountryCode;
      data['phone2'] = '+$phone2CC$phone2Text';
    }
    final companyText = companyController.text.trim();
    if (companyText.isNotEmpty && (!isCard || sel['company'] == true)) {
      data['company'] = companyText;
    }
    final websiteText = websiteController.text.trim();
    if (websiteText.isNotEmpty && (!isCard || sel['website'] == true)) {
      data['website'] = websiteText;
    }
    final addressText = addressController.text.trim();
    if (addressText.isNotEmpty && (!isCard || sel['address'] == true)) {
      data['address'] = addressText;
    }

    return data;
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

  // Future<void> submitForm(BuildContext context) async {
  //   if (!formKey.currentState!.validate()) return;
  //   try {
  //     state.isLoading.value = true;
  //     final data = _gatherFormData();

  //     if (checkIsForUpdate()) {
  //       if (contactId == null) {
  //         throw Exception("Contact ID is required for update");
  //       }
  //       await AddContactApi.updateContact(data: data, id: contactId!);
  //     } else {
  //       await AddContactApi.registerTicket(data: data);
  //     }

  //     clearForm();
  //     contactId = null;
  //     Navigator.pop(context, "refresh");
  //   } catch (err) {
  //     if (err is DioException) {
  //       final statusCode = err.response?.statusCode;
  //       if (statusCode == 401) {
  //         UserStore.to.clearStore();
  //         navigateToSignInPage();
  //         return;
  //       }
  //       ApiErrorHandler.handleError(err, "Failed to add/update contact");
  //     } else {
  //       AppSnackbar.error(
  //         title: "Failed",
  //         message: "Something went wrong. Please try again.",
  //       );
  //     }
  //   } finally {
  //     state.isLoading.value = false;
  //   }
  // }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    try {
      state.isLoading.value = true;

      final data = _gatherFormData();
      final imageFile = state.selectedImage.value;

      if (checkIsForUpdate()) {
        await AddContactApi.updateContact(data: data, id: contactId!);
      } else {
        // 🔥 If toggle ON + image exists → multipart
        if (state.addWithImage.value && imageFile != null) {
          await AddContactApi.createContactWithCard(
            data: data,
            imageFile: imageFile,
          );
        } else {
          // 🔥 Normal x-www-form-urlencoded
          await AddContactApi.addContact(data: data);
        }
      }

      clearForm();
      contactId = null;
      Navigator.pop(context, "refresh");
    } catch (err) {
      if (err is dio.DioException) {
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

  void navigateToImageViewer() {
    Get.toNamed(
      RouteName.imageViewerPage,
      arguments: {
        "file": state.selectedImage.value,
        "header": nameController.text.trim(),
        "fileUrl": state.existingImageUrl.value,
      },
    );
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

  Future<void> extractAdditionalInfoFromCard() async {
    final imageUrl = state.existingImageUrl.value;
    if (imageUrl == null || imageUrl.isEmpty) return;

    try {
      state.isExtractingFromCard.value = true;

      // Download the card image to a temp file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/card_extract_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final response = await dio.Dio().get<List<int>>(
        imageUrl,
        options: dio.Options(responseType: dio.ResponseType.bytes),
      );
      await tempFile.writeAsBytes(response.data!);

      // Run on-device OCR
      final inputImage = InputImage.fromFilePath(tempFile.path);
      final recognizer = TextRecognizer();
      final recognizedText = await recognizer.processImage(inputImage);
      await recognizer.close();
      await tempFile.delete();

      final text = recognizedText.text.trim();
      if (text.isEmpty) {
        AppSnackbar.error(
          title: 'No text found',
          message: 'Could not read text from the card image.',
        );
        return;
      }

      // Parse with shared utility
      final info = await VisitingCardParser.extractCardInfo(text);

      // Build list of extracted fields to show to user
      final foundItems = <_ExtractedItem>[];
      if ((info.company ?? '').isNotEmpty) {
        foundItems.add(
          _ExtractedItem(
            'company',
            'Company',
            info.company!,
            Icons.business_outlined,
          ),
        );
      }
      if ((info.website ?? '').isNotEmpty) {
        foundItems.add(
          _ExtractedItem(
            'website',
            'Website',
            info.website!,
            Icons.language_outlined,
          ),
        );
      }
      if ((info.address ?? '').isNotEmpty) {
        foundItems.add(
          _ExtractedItem(
            'address',
            'Address',
            info.address!,
            Icons.location_on_outlined,
          ),
        );
      }
      if (info.phone2Parsed != null) {
        foundItems.add(
          _ExtractedItem(
            'phone2',
            'Phone 2',
            info.phone2Parsed!.fullNumber,
            Icons.phone_outlined,
          ),
        );
      } else if ((info.phone2 ?? '').isNotEmpty) {
        foundItems.add(
          _ExtractedItem(
            'phone2',
            'Phone 2',
            info.phone2!,
            Icons.phone_outlined,
          ),
        );
      }

      if (foundItems.isEmpty) {
        AppSnackbar.error(
          title: 'Nothing found',
          message: 'No additional info could be extracted from the card image.',
        );
        return;
      }

      // Show review dialog — user confirms before any fields are filled
      state.isExtractingFromCard.value = false;
      final confirmed = await Get.dialog<bool>(
        _buildExtractReviewDialog(foundItems),
        barrierDismissible: true,
      );

      if (confirmed != true) return;

      // Apply all extracted fields (overwrite existing values)
      for (final item in foundItems) {
        switch (item.key) {
          case 'company':
            companyController.text = item.value;
            state.additionalInfoSelection['company'] = true;
            break;
          case 'website':
            websiteController.text = item.value;
            state.additionalInfoSelection['website'] = true;
            break;
          case 'address':
            addressController.text = item.value;
            state.additionalInfoSelection['address'] = true;
            break;
          case 'phone2':
            if (info.phone2Parsed != null) {
              final cc = info.phone2Parsed!.countryCode.replaceAll('+', '');
              state.selectedPhone2Country.value = countries.firstWhere(
                (c) => c.fullCountryCode == cc,
                orElse: () => countries.firstWhere((c) => c.code == 'IN'),
              );
              phone2Controller.text = info.phone2Parsed!.phoneNumber;
            } else {
              phone2Controller.text = info.phone2 ?? '';
            }
            state.additionalInfoSelection['phone2'] = true;
            break;
        }
      }

      // Auto-expand the additional info section so user sees the filled fields
      state.isAdditionalInfoExpanded.value = true;

      AppSnackbar.success(
        title: 'Applied',
        message: 'Additional info from card has been filled.',
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Card extract error: $e');
      AppSnackbar.error(
        title: 'Failed',
        message: 'Could not extract info from card image.',
      );
    } finally {
      state.isExtractingFromCard.value = false;
    }
  }

  Widget _buildExtractReviewDialog(List<_ExtractedItem> items) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            Icons.document_scanner_outlined,
            color: Colors.blue.shade700,
            size: 22,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Extracted from Card',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Found the following info on the card:',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.icon, size: 16, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF757575),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(item.value, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap Apply to fill these into the form.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Get.back(result: true),
          child: const Text('Apply'),
        ),
      ],
    );
  }

  @override
  void onClose() {
    searchTagsController.dispose();
    phone2Controller.dispose();
    companyController.dispose();
    websiteController.dispose();
    addressController.dispose();
    super.onClose();
  }
}

class _ExtractedItem {
  final String key;
  final String label;
  final String value;
  final IconData icon;

  const _ExtractedItem(this.key, this.label, this.value, this.icon);
}
