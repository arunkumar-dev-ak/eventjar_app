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
import 'package:eventjar/model/auth/login_model.dart';
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
  String _provider = "";
  String _authSessionId = "";

  @override
  void onInit() {
    super.onInit();

    _startTextAnimation();

    _handleArgs();

    // 2. Start the API call if we have a valid token
    if (_idToken.isNotEmpty || _authSessionId.isNotEmpty) {
      _processAuth();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppSnackbar.error(title: "error".tr, message: "invalid_auth_token".tr);

        Navigator.pop(Get.context!);
      });
    }
  }

  void _handleArgs() {
    if (Get.arguments != null) {
      if (Get.arguments is Map) {
        final args = Get.arguments;

        // Google
        if (args.containsKey('idToken')) {
          _provider = "google";
          _idToken = args['idToken'];
        }

        // LinkedIn
        if (args.containsKey('authSessionId')) {
          _provider = "linkedin";
          _authSessionId = args['authSessionId'];
        }
      } else if (Get.arguments is String) {
        _provider = "google";
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

  Future<void> _processAuth() async {
    try {
      LoginResponse response;

      if (_provider == "google") {
        response = await AuthProcessignApi.googleSignIn(idToken: _idToken);
      } else if (_provider == "linkedin") {
        response = await AuthProcessignApi.linkedInSignIn(
          authSessionId: _authSessionId,
        );
      } else {
        throw Exception("Unsupported provider");
      }

      _textTimer.cancel();

      // (LinkedIn)
      if (response is MobileRequiredResponse) {
        state.cacheKey.value = response.cacheKey;

        state.isMobileNumberRequired.value = true;

        Future.delayed(Duration.zero, () {
          phoneFocusNode.requestFocus();
        });

        return;
      }

      // 2FA
      if (response.requires2FA) {
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

      // SUCCESS
      await UserStore.to.handleSetLocalData(response);

      AppSnackbar.success(
        title: "login_successful".tr,
        message: "User Logged in successfully",
      );

      navigateToBackPage();
    } on DioException catch (e) {
      _textTimer.cancel();

      state.isLoading.value = false;

      final errorData = e.response?.data?.toString().toLowerCase() ?? "";
      if (errorData.contains('mobile number is required')) {
        await Future.delayed(const Duration(seconds: 2));
        state.isMobileNumberRequired.value = true;
        Future.delayed(Duration.zero, () {
          phoneFocusNode.requestFocus();
        });
      } else {
        ApiErrorHandler.handleDioError(
          e,
          "${_provider == "google" ? "Google" : "Linkedin"} Authentication Failed",
        );
        Navigator.pop(Get.context!);
      }
    } catch (e) {
      _textTimer.cancel();
      AppSnackbar.error(title: "error".tr, message: "unexpected_error".tr);
      Navigator.pop(Get.context!);
    }
  }

  /*----- 2Fa verification -----*/
  Future<void> handleSubmit2fa(BuildContext context) async {
    Get.focusScope?.unfocus();
    if (state.tempToken == null) {
      AppSnackbar.warning(
        title: "verification_error".tr,
        message: "Session expired. Please login again.",
      );
      return;
    }

    final otp = otpController.text;

    if (otp.length != 6) {
      AppSnackbar.warning(
        title: "invalid_code".tr,
        message: "enter_six_digit_code_error".tr,
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
        title: "login_successful".tr,
        message: "two_fa_verified_success".tr,
      );

      state.is2FaLoading.value = false;
      Navigator.pop(Get.context!);
      navigateToBackPage();
    } catch (err) {
      state.is2FaLoading.value = false;
      LoggerService.loggerInstance.e(err);
      if (err is DioException) {
        ApiErrorHandler.handleDioError(err, "two_fa_error".tr);
      } else {
        AppSnackbar.error(
          title: "two_fa_error".tr,
          message: "generic_try_again_error".tr,
        );
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

        LoginResponse response;

        if (_provider == "google") {
          response = await AuthProcessignApi.googleSignIn(
            idToken: _idToken,
            phone: phoneNumber,
          );
        } else {
          response = await AuthProcessignApi.linkedInSignIn(
            cacheKey: state.cacheKey.value,
            phone: phoneNumber,
          );
        }

        // 1. Check for 2FA
        if (response.requires2FA) {
          state.isSubmitLoading.value = false;

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
          title: "login_successful".tr,
          message: "User Logged in successfully",
        );

        navigateToBackPage();
      } catch (err) {
        // --- Error Handling ---
        if (err is DioException) {
          ApiErrorHandler.handleDioError(err, "sign_up_error".tr);
        } else {
          AppSnackbar.error(
            title: "sign_up_error".tr,
            message: "generic_try_again_error".tr,
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
