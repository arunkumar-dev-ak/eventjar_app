import 'package:eventjar/model/contact/contact_model.dart';
import 'package:get/get.dart';

class AddContactState {
  final RxBool isLoading = false.obs;

  RxString selectedCountryCode = '+91'.obs;

  RxList<Map<String, String>> stages = <Map<String, String>>[
    {'key': 'new', 'value': 'New Contact'},
    {'key': 'followup_24h', 'value': '24H Followup'},
    {'key': 'followup_7d', 'value': '7D Followup'},
    {'key': 'followup_30d', 'value': '30D Followup'},
    {'key': 'qualified', 'value': 'Qualified Lead'},
  ].obs;

  Rx<Map<String, String>> selectedStage = Rx<Map<String, String>>({
    'key': 'new',
    'value': 'New Contact',
  });

  Rxn<Contact> contacts = Rxn();
  RxList<String> selectedTags = <String>[].obs;
}
