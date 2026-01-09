import 'package:dio/dio.dart';
import 'package:eventjar/api/signin_api/signin_api.dart';
import 'package:eventjar/controller/signIn/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
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
}
