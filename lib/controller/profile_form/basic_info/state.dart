import 'package:flutter_intl_phone_field/countries.dart';
import 'package:get/get.dart';

class BasicInfoFormState {
  final RxBool isLoading = false.obs;

  Rx<Country> selectedCountry = countries
      .firstWhere((country) => country.code == 'IN')
      .obs;

  // Phone verification
  RxBool isPhoneVerified = false.obs;
  RxString currentPhone = ''.obs; // full phone from profile
  RxBool isSendingOtp = false.obs;
  RxBool isVerifyingOtp = false.obs;
  RxString otpError = ''.obs;
  RxInt resendCooldown = 0.obs;
}
