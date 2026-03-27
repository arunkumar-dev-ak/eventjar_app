import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:get/get.dart';

class AuthProcessingState {
  // UI State toggles
  final RxBool isLoading = true.obs;
  final RxBool isSubmitLoading = false.obs;
  final RxBool isMobileNumberRequired = false.obs;
  Rx<Country> selectedCountry = countries
      .firstWhere((country) => country.code == 'IN')
      .obs;

  // Animation text
  final RxString loadingText = "Connecting your account...".obs;

  // Form fields
  final mobileController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxBool is2FaLoading = false.obs;
  RxBool isOtpValid = false.obs;
  String? tempToken;
}
