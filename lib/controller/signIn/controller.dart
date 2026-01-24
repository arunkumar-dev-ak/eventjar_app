import 'package:dio/dio.dart';
import 'package:eventjar/api/signin_api/signin_api.dart';
import 'package:eventjar/controller/signIn/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/page/sign_in/widgets/signin_2fa_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  var appBarTitle = "";
  final state = SignInState();
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController().obs;
  final _passwordController = TextEditingController().obs;
  final isPasswordHidden = true.obs;
  bool get isLoading => state.isLoading.value;

  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  TextEditingController get emailController => _emailController.value;
  TextEditingController get passwordController => _passwordController.value;

  void onInint() {
    super.onInit();
  }

  //validate email
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email is required";
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return "Enter valid email";
    }
    return null;
  }

  //update email state during onChange
  void updateEmailValidity(String? email) {
    state.isEmailValid.value =
        email != null &&
        email.isNotEmpty &&
        RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  //validate password
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Password is required";
    } else if (password.length < 8) {
      return "Password must contain at least 8 characters";
    }
    return null;
  }

  //update password state during onChange
  void updatePasswordValidity(String? password) {
    state.isPasswordValid.value = password != null && password.isNotEmpty;
  }

  void togglePasswordVisibility() {
    state.isPasswordHidden.value = !state.isPasswordHidden.value;
  }

  void handleSubmit(BuildContext context) async {
    state.isLoading.value = true;
    try {
      var response = await SignInApi.signIn(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.requires2FA) {
        state.isLoading.value = false;

        state.tempToken = response.tempToken;
        clear2FaController();
        state.isOtpValid.value = false;

        signInOpen2FAModal(
          Get.context!,
          email: emailController.text,
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
      state.isLoading.value = false;
      navigateToBackPage(context);
    } catch (err) {
      state.isLoading.value = false;
      LoggerService.loggerInstance.dynamic_d(err);
      if (err is DioException) {
        ApiErrorHandler.handleError(err, "Login Error");
      } else {
        AppSnackbar.error(
          title: "Login Error",
          message: "Something went wrong",
        );
      }
    }
  }

  Future<void> handleSubmit2fa(BuildContext context) async {
    Get.focusScope?.unfocus();
    if (state.tempToken == null) {
      AppSnackbar.warning(
        title: "Verification Error",
        message: "Session expired. Please login again.",
      );
      return;
    }

    final otp = otpControllers.map((c) => c.text).join();
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
      Navigator.pop(context);
      navigateToBackPage(context);
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

  void clear2FaController() {
    for (final c in otpControllers) {
      c.clear();
    }
  }

  void updateOtpValidity() {
    final otp = otpControllers.map((c) => c.text).join();
    state.isOtpValid.value = otp.length == 6;
  }

  /*----- navigation ----*/
  void navigateToSignUp() {
    Get.toNamed('/signUpPage');
  }

  void navigateToForgotPassword() {
    Get.toNamed('/forgotPasswordPage');
  }

  void navigateToBackPage(BuildContext context) {
    Navigator.pop(context, "logged_in");
  }

  @override
  void onClose() {
    for (final c in otpControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
