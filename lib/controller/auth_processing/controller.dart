import 'dart:async';
import 'package:dio/dio.dart';
import 'package:eventjar/api/auth_processing_api/auth_processing_api.dart';
import 'package:eventjar/api/signin_api/signin_api.dart';
// import 'package:eventjar/api/auth_processing_api.dart'; // Make sure to import your API class here
import 'package:eventjar/controller/auth_processing/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/page/auth_processing/widget/auth_processing_2fa_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthProcessingController extends GetxController {
  final state = AuthProcessingState();
  final phoneFocusNode = FocusNode();

  late Timer _textTimer;
  int _textIndex = 0;
  final List<String> _loadingMessages = [
    "Connecting your account...",
    "Setting things up...",
    "Securing your data...",
    "Almost there...",
  ];
  final TextEditingController otpController = TextEditingController();
  String _idToken = "";

  @override
  void onInit() {
    super.onInit();

    _handleArgs();

    _startTextAnimation();

    // 2. Start the API call if we have a valid token
    if (_idToken.isNotEmpty) {
      _verifyIdTokenWithBackend();
    } else {
      _textTimer.cancel();
      Get.back();
      AppSnackbar.error(
        title: "Error",
        message: "Invalid Google authentication token.",
      );
    }
  }

  void _handleArgs() {
    if (Get.arguments != null) {
      if (Get.arguments is Map && Get.arguments.containsKey('idToken')) {
        _idToken = Get.arguments['idToken'];
      } else if (Get.arguments is String) {
        _idToken = Get.arguments;
      }
    }
  }

  void _startTextAnimation() {
    _textTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      _textIndex = (_textIndex + 1) % _loadingMessages.length;
      state.loadingText.value = _loadingMessages[_textIndex];
    });
  }

  void clear2FaController() {
    otpController.clear();
  }

  void updateOtpValidity() {
    final otp = otpController.text;
    state.isOtpValid.value = otp.length == 6;
  }

  Future<void> _verifyIdTokenWithBackend() async {
    try {
      final response = await AuthProcessignApi.googleSignIn(idToken: _idToken);

      _textTimer.cancel();
      // --- Success Handling ---

      // 1. Check for 2FA
      if (response.requires2FA) {
        state.isSubmitLoading.value = false;

        // Note: Make sure tempToken and isOtpValid exist in your AuthProcessingState
        state.tempToken = response.tempToken;
        clear2FaController();
        state.isOtpValid.value = false;

        authProcessingOpen2FAModal(
          Get.context!,
          tempToken: state.tempToken!,
          controller: this,
        );

        return;
      }

      await UserStore.to.handleSetLocalData(response);

      AppSnackbar.success(
        title: "Login Successful",
        message: "User Logged in successfully",
      );

      navigateToBackPage();
    } on DioException catch (e) {
      _textTimer.cancel();

      state.isLoading.value = false;

      final errorData = e.response?.data?.toString().toLowerCase() ?? "";
      if (errorData.contains('mobile number is required')) {
        state.isMobileNumberRequired.value = true;
        Future.delayed(Duration.zero, () {
          phoneFocusNode.requestFocus();
        });
      } else {
        ApiErrorHandler.handleError(e, "Google Authentication Failed");
        Navigator.pop(Get.context!);
      }
    } catch (e) {
      _textTimer.cancel();
      AppSnackbar.error(
        title: "Error",
        message: "An unexpected error occurred.",
      );
      Navigator.pop(Get.context!);
    }
  }

  /*----- 2Fa verification -----*/
  Future<void> handleSubmit2fa(BuildContext context) async {
    Get.focusScope?.unfocus();
    if (state.tempToken == null) {
      AppSnackbar.warning(
        title: "Verification Error",
        message: "Session expired. Please login again.",
      );
      return;
    }

    final otp = otpController.text;

    if (otp.length != 6) {
      AppSnackbar.warning(
        title: "Invalid Code",
        message: "Please enter the 6-digit verification code.",
      );
      return;
    }

    state.is2FaLoading.value = true;

    try {
      final normalResponse = await SignInApi.verify2FA(
        tempToken: state.tempToken!,
        otp: otp,
      );

      // Save user + tokens
      await UserStore.to.handleSetLocalData(normalResponse);

      AppSnackbar.success(
        title: "Login Successful",
        message: "2FA verified successfully",
      );

      state.is2FaLoading.value = false;
      Navigator.pop(Get.context!);
      navigateToBackPage();
    } catch (err) {
      state.is2FaLoading.value = false;
      LoggerService.loggerInstance.dynamic_d(err);
      if (err is DioException) {
        ApiErrorHandler.handleError(err, "2FA Error");
      } else {
        AppSnackbar.error(title: "2FA Error", message: "Something went wrong");
      }
    }
  }

  /*---- Mobile Number Submit -----*/
  Future<void> submitMobileNumber() async {
    if (state.formKey.currentState!.validate()) {
      state.isSubmitLoading.value = true;

      try {
        final countryCode = state.selectedCountry.value.fullCountryCode;
        final phoneNumber = "+$countryCode${state.mobileController.text}";

        LoggerService.loggerInstance.dynamic_d(phoneNumber);

        final response = await AuthProcessignApi.googleSignIn(
          idToken: _idToken,
          phone: phoneNumber,
        );

        // 1. Check for 2FA
        if (response.requires2FA) {
          state.isSubmitLoading.value = false;

          // Note: Make sure tempToken and isOtpValid exist in your AuthProcessingState
          state.tempToken = response.tempToken;
          clear2FaController();
          state.isOtpValid.value = false;

          authProcessingOpen2FAModal(
            Get.context!,
            tempToken: state.tempToken!,
            controller: this,
          );

          return;
        }

        await UserStore.to.handleSetLocalData(response);

        AppSnackbar.success(
          title: "Login Successful",
          message: "User Logged in successfully",
        );

        navigateToBackPage();
      } catch (err) {
        // --- Error Handling ---
        if (err is DioException) {
          ApiErrorHandler.handleError(err, "Sign Up Error");
        } else {
          AppSnackbar.error(
            title: "Sign Up Error",
            message: "Something went wrong",
          );
        }
      } finally {
        state.isSubmitLoading.value = false;
      }
    }
  }

  void navigateToBackPage() {
    Navigator.pop(Get.context!, "logged_in");
  }

  @override
  void onClose() {
    if (_textTimer.isActive) _textTimer.cancel();
    state.mobileController.dispose();
    super.onClose();
  }
}
