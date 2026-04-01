import 'package:dio/dio.dart';
import 'package:eventjar/api/set_2fa_api/set_2fa_api.dart';
import 'package:eventjar/controller/set_2fa/state.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Set2faController extends GetxController {
  var appBarTitle = "Two-Factor Authentication";
  final state = Set2faState();

  final TextEditingController otpController = TextEditingController();

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    generateSecret();
    super.onInit();
  }

  Future<void> generateSecret() async {
    try {
      state.isLoading.value = true;
      state.error.value = '';

      final data = await Set2faApi.generate2FASecret();

      state.secretData.value = data;
      state.step.value = 'verify';
    } catch (e) {
      state.error.value = e.toString();
    } finally {
      state.isLoading.value = false;
    }
  }

  void updateOtp(int index, String value) {
    if (value.length > 1) return;

    final list = state.otp.toList();
    list[index] = value;
    state.otp.value = list;

    state.error.value = '';
  }

  Future<void> enable2FA() async {
    final code = otpController.text;
    state.error.value = '';

    if (code.length != 6) {
      state.error.value = 'Enter 6 digit code';
      return;
    }

    try {
      state.isLoading.value = true;

      await Set2faApi.enable2FA(code);

      state.error.value = '';
      state.step.value = 'complete';

      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(Get.context!, "success");
    } catch (err) {
      LoggerService.loggerInstance.dynamic_d(err);

      if (err is DioException) {
        final statusCode = err.response?.statusCode;
        final message = err.response?.data?['message']?.toString() ?? '';

        LoggerService.loggerInstance.dynamic_d(statusCode);

        //auth
        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        // UI error
        if (message.contains('2FA already enabled')) {
          state.error.value = '2FA is already enabled';
        } else if (message.contains('2FA secret not generated')) {
          state.error.value = 'Please generate QR code first';
        } else if (message.contains('Invalid 2FA code')) {
          state.error.value = 'Invalid code. Please try again';
        } else {
          state.error.value = message.isNotEmpty
              ? message
              : 'Something went wrong. Please try again';
        }
      } else {
        state.error.value = 'Something went wrong. Please try again';
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  void updateOtpValidity() {
    final otp = otpController.text;
    state.error.value = otp.length == 6 ? "" : "Enter 6 digit code";
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) async {
      if (result == "logged_in") {
        await generateSecret();
      } else {
        Get.back();
      }
    });
  }
}
