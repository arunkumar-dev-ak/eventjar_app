import 'dart:io';

import 'package:eventjar/model/card_info.dart';
import 'package:eventjar/model/contact/qr_contact_model.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:get/get.dart';

class AddContactState {
  final RxBool isLoading = false.obs;
  final RxBool isDropDownLoading = false.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool addWithImage = true.obs;
  RxBool hideToogle = false.obs;
  Rxn<String> existingImageUrl = Rxn();

  Rx<Country> selectedCountry = countries
      .firstWhere((country) => country.code == 'IN')
      .obs;

  Rx<Country> selectedPhone2Country = countries
      .firstWhere((country) => country.code == 'IN')
      .obs;

  // Incremented on every reset to force IntlPhoneField to rebuild
  RxInt phone2FieldKey = 0.obs;

  RxString clearButtonTitle = 'clear'.tr.obs;

  // Visiting card extra info
  Rxn<VisitingCardInfo> visitingCardInfo = Rxn();
  RxBool isFromCardScan = false.obs;
  RxBool isExtractingFromCard = false.obs;

  // Whether the additional info section is expanded
  RxBool isAdditionalInfoExpanded = false.obs;

  // Which additional fields the user wants to include in the API call
  RxMap<String, bool> additionalInfoSelection = <String, bool>{
    'phone2': false,
    'company': false,
    'website': false,
    'address': false,
  }.obs;

  RxList<Map<String, String>> stages = <Map<String, String>>[
    {'key': 'new', 'value': 'new_contact'},
    {'key': 'followup_24h', 'value': 'twenty_four_h_followup'},
    {'key': 'followup_7d', 'value': 'seven_d_followup'},
    {'key': 'followup_30d', 'value': 'thirty_d_followup'},
    {'key': 'qualified', 'value': 'qualified_lead'},
  ].obs;

  RxList<String> availableTags = <String>[].obs;
  Rx<String> query = "".obs;
  RxList<String> filteredTags = <String>[].obs;

  Rx<Map<String, String>> selectedStage = Rx<Map<String, String>>({
    'key': 'new',
    'value': 'New Contact',
  });

  Rxn<QrContactModel> contacts = Rxn();
  RxMap<String, String> selectedTagsMap = <String, String>{}.obs;
}
