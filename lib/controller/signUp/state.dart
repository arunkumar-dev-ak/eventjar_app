import 'package:flutter_intl_phone_field/countries.dart';
import 'package:get/get.dart';

class SignUpState {
  RxBool isLoading = false.obs;

  RxBool fullName = false.obs;
  RxBool gmail = false.obs;
  RxBool mobileNumber = false.obs;
  RxBool password = false.obs;

  RxBool isPasswordHidden = true.obs;
  RxBool isConfirmPasswordHidden = true.obs;

  RxBool focusEmail = false.obs;
  RxBool focusFullName = false.obs;
  RxBool focusMobileNumber = false.obs;
  RxBool focusPassword = false.obs;

  RxBool isEmailValid = true.obs;
  RxBool isPasswordValid = true.obs;
  RxBool isFullNamelValid = true.obs;
  RxBool isMobileNumberValid = true.obs;
  RxBool isConfirmPasswordValid = true.obs;

  Rx<Country> selectedCountry = countries
      .firstWhere((country) => country.code == 'IN')
      .obs;
}
