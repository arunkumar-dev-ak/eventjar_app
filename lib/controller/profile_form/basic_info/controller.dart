import 'dart:async';

import 'package:dio/dio.dart';
import 'package:eventjar/api/user_profile_api/user_profile_api.dart';
import 'package:eventjar/api/verify_api/phone.dart';
import 'package:eventjar/controller/profile_form/basic_info/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/model/user_profile/user_profile.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:get/get.dart';

class BasicInfoFormController extends GetxController {
  var appBarTitle = "Update Basic Info";
  final state = BasicInfoFormState();
  final formKey = GlobalKey<FormState>();

  // String? profileId;

  late String? _originalFullName;
  late String? _originalPhone;
  late String? _originalJobTitle;

  final fullNameController = TextEditingController();
  // final usernameController = TextEditingController();
  // final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final professionalTitleController = TextEditingController();

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    final args = Get.arguments;
    UserProfile? profile;

    if (args is UserProfileResponse) {
      profile = args.data;
    } else if (args is UserProfile) {
      profile = args;
    } else if (args is Map && args.containsKey('profile')) {
      profile = args['profile'];
    }

    handleProfile(profile);
    super.onInit();
  }

  void handleProfile(UserProfile? profile) {
    if (profile == null) {
      return;
    }

    _originalFullName =
        profile.extendedProfile?.fullName ?? profile.name ?? profile.username;
    _originalPhone = profile.phoneParsed?.fullNumber;
    _originalJobTitle = profile.extendedProfile?.position ?? profile.jobTitle;

    // Phone verified status
    state.isPhoneVerified.value = profile.phoneVerified;
    state.currentPhone.value =
        profile.phone ?? profile.phoneParsed?.fullNumber ?? '';

    // full name
    fullNameController.text =
        profile.extendedProfile?.fullName ??
        profile.name ??
        profile.username ??
        '';
    // professional title
    professionalTitleController.text =
        profile.extendedProfile?.position ?? profile.jobTitle ?? '';
    //mobile
    handlePhoneNumberArgs(profile);
  }

  void handlePhoneNumberArgs(UserProfile profile) {
    final selectedCountryCode = profile.phoneParsed?.countryCode ?? "+91";
    final String cleanCountryCode = selectedCountryCode.replaceAll('+', '');
    state.selectedCountry.value = countries.firstWhere(
      (country) => country.fullCountryCode == cleanCountryCode,
      orElse: () => countries.first,
    );
    mobileController.text = profile.phoneParsed?.phoneNumber ?? "";
  }

  void clearForm() {
    final args = Get.arguments;
    UserProfile? profile;

    if (args is UserProfileResponse) {
      profile = args.data;
    } else if (args is UserProfile) {
      profile = args;
    } else if (args is Map && args.containsKey('profile')) {
      profile = args['profile'];
    }

    handleProfile(profile);
    // formKey.currentState?.reset();
  }

  bool _hasFieldChanged({required String? original, required String current}) {
    return original?.trim() != current.trim();
  }

  Map<String, dynamic> _gatherFormData() {
    final countryCode = state.selectedCountry.value.fullCountryCode;
    final localPhoneNumber = mobileController.text.trim();
    final fullPhoneNumber = '+$countryCode$localPhoneNumber';
    final data = <String, dynamic>{};

    if (_hasFieldChanged(
      original: _originalFullName,
      current: fullNameController.text,
    )) {
      data['name'] = fullNameController.text.trim();
    }

    if (_hasFieldChanged(original: _originalPhone, current: fullPhoneNumber)) {
      data['phone'] = fullPhoneNumber;
    }

    if (_hasFieldChanged(
      original: _originalJobTitle,
      current: professionalTitleController.text,
    )) {
      data['jobTitle'] = professionalTitleController.text.trim();
    }

    return data;
  }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    try {
      state.isLoading.value = true;
      final data = _gatherFormData();
      if (data.isEmpty) {
        Navigator.pop(context);
        return;
      }

      await UserProfileApi.updateUserProfile(data);

      AppSnackbar.success(
        title: "success".tr,
        message: "basic_info_updated_success".tr,
      );

      Navigator.pop(context, "refresh");
    } catch (err) {
      ApiErrorHandler.handle(
        error: err,
        title: "failed_update_basic_info".tr,
        onUnauthorized: () {
          UserStore.to.clearStore();
          navigateToSignInPage();
        },
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage);
  }

  /*----- Phone OTP Verification -----*/
  Timer? _resendTimer;

  Future<void> sendPhoneOtp() async {
    final phone = state.currentPhone.value;
    if (phone.isEmpty) {
      AppSnackbar.error(title: "error".tr, message: "no_phone_on_profile".tr);
      return;
    }

    state.isSendingOtp.value = true;
    state.otpError.value = '';
    try {
      await VerifyPhoneApi.sendOtp(phone);
      _startResendCooldown();
    } catch (err) {
      if (err is DioException) {
        ApiErrorHandler.handleDioError(err, "Failed to send OTP");
      } else {
        AppSnackbar.error(title: "error".tr, message: err.toString());
      }
    } finally {
      state.isSendingOtp.value = false;
    }
  }

  Future<bool> verifyPhoneOtp(String otp) async {
    final phone = state.currentPhone.value;
    if (phone.isEmpty) return false;

    state.isVerifyingOtp.value = true;
    state.otpError.value = '';
    try {
      await VerifyPhoneApi.verifyOtp(phone, otp);
      state.isPhoneVerified.value = true;
      return true;
    } catch (err) {
      if (err is DioException) {
        final data = err.response?.data;
        if (data is Map && data['message'] is String) {
          state.otpError.value = data['message'];
        } else if (data is String) {
          state.otpError.value = data;
        } else {
          state.otpError.value = 'Verification failed. Please try again.';
        }
      } else {
        state.otpError.value = err.toString();
      }
      return false;
    } finally {
      state.isVerifyingOtp.value = false;
    }
  }

  void _startResendCooldown() {
    state.resendCooldown.value = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCooldown.value <= 1) {
        timer.cancel();
        state.resendCooldown.value = 0;
      } else {
        state.resendCooldown.value--;
      }
    });
  }

  void resetOtpState() {
    state.otpError.value = '';
    state.isSendingOtp.value = false;
    state.isVerifyingOtp.value = false;
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    super.onClose();
  }
}
