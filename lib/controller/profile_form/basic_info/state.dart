import 'package:flutter_intl_phone_field/countries.dart';
import 'package:get/get.dart';

class BasicInfoFormState {
  final RxBool isLoading = false.obs;

  // RxString selectedCountryCode = '+91'.obs;
  Rx<Country> selectedCountry = countries
      .firstWhere((country) => country.code == 'IN')
      .obs;
}
