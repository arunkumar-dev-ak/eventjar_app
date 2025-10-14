import 'package:eventjar_app/controller/signIn/state.dart';
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

  void navigateToSignUp() {
    Get.toNamed('/signUpPage');
  }
}
