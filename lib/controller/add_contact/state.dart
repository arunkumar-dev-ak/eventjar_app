import 'package:eventjar/model/contact/qr_contact_model.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:get/get.dart';

class AddContactState {
  final RxBool isLoading = false.obs;
  final RxBool isDropDownLoading = false.obs;

  Rx<Country> selectedCountry = countries
      .firstWhere((country) => country.code == 'IN')
      .obs;
  RxString clearButtonTitle = 'Clear'.obs;

  RxList<Map<String, String>> stages = <Map<String, String>>[
    {'key': 'new', 'value': 'New Contact'},
    {'key': 'followup_24h', 'value': '24H Followup'},
    {'key': 'followup_7d', 'value': '7D Followup'},
    {'key': 'followup_30d', 'value': '30D Followup'},
    {'key': 'qualified', 'value': 'Qualified Lead'},
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
