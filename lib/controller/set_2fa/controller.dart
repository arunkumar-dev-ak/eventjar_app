import 'package:eventjar/api/set_2fa_api/set_2fa_api.dart';
import 'package:eventjar/controller/set_2fa/state.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

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

      LoggerService.loggerInstance.dynamic_d(data.toJson());

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
    final code = state.otp.join();

    if (code.length != 6) {
      state.error.value = 'Enter 6 digit code';
      return;
    }

    try {
      state.isLoading.value = true;
      state.error.value = '';

      // await Set2faApi.enable2FA(code: code);

      state.step.value = 'complete';
    } catch (e) {
      state.error.value = 'Invalid code. Try again';
      state.otp.value = List.generate(6, (_) => '');
    } finally {
      state.isLoading.value = false;
    }
  }

  void updateOtpValidity() {
    final otp = otpController.text;
    state.isOtpValid.value = otp.length == 6;
  }
}
