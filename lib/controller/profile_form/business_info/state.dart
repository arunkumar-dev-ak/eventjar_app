import 'package:flutter_intl_phone_field/countries.dart';
import 'package:get/get.dart';

class BusinessInfoFormState {
  final RxBool isLoading = false.obs;

  Rx<Country> selectedCountry = countries
      .firstWhere((country) => country.code == 'IN')
      .obs;
  RxString selectedBusinessCategory = ''.obs;
  RxList<String> selectedOperatingRegions = <String>[].obs;
}
