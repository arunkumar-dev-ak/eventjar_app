import 'package:dio/dio.dart';
import 'package:eventjar/api/sign_up_api/sign_up_api.dart';
import 'package:eventjar/controller/signUp/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  var appBarTitle = "";
  final state = SignUpState();
  final formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController().obs;
  final _passwordController = TextEditingController().obs;
  final _fullNameController = TextEditingController().obs;
  final _mobileNumberController = TextEditingController().obs;

  final isPasswordHidden = true.obs;
  bool get isLoading => state.isLoading.value;

  TextEditingController get emailController => _emailController.value;
  TextEditingController get passwordController => _passwordController.value;
  TextEditingController get fullNameController => _fullNameController.value;
  TextEditingController get mobileNumberController =>
      _mobileNumberController.value;

  @override
  void onInit() {
    super.onInit();
  }

  void navigateToLogin() {
    Get.until((route) => route.settings.name == '/signInPage');
  }

  Map<String, dynamic> getSignUpData() {
    return {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "name": fullNameController.text.trim(),
      "phone": mobileNumberController.text.trim(),
      "countryCode": state.selectedCountryCode.value,
    };
  }

  void handleSignUpSubmit(BuildContext context) async {
    state.isLoading.value = true;
    try {
      final signUpData = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "name": fullNameController.text.trim(),
        "phone": mobileNumberController.text.trim(),
        "countryCode": state.selectedCountryCode.value,
        "mobile": mobileNumberController.text.trim(),
      };

      final message = await SignUpApi.signUp(signUpData);

      AppSnackbar.success(title: "Sign Up Successful", message: message);

      // Auto-login after signup
      // var response = await SignInApi.signIn(
      //   email: emailController.text.trim(),
      //   password: passwordController.text.trim(),
      // );

      // await UserStor.to.handleSetLocalData(response);

      // AppSnackbar.success(
      //   title: "Login Successful",
      //   message: "User Logged in successfully",
      // );

      navigateToBackPage(context);
    } catch (err) {
      state.isLoading.value = false;
      if (err is DioException) {
        ApiErrorHandler.handleError(err, "Sign Up Error");
      } else {
        AppSnackbar.error(
          title: "Sign Up Error",
          message: "Something went wrong",
        );
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  void navigateToBackPage(BuildContext context) {
    Navigator.pop(context);
  }
}
