import 'package:eventjar_app/controller/signUp/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  var appBarTitle = "";
  final state = SignUpState();
  final formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController().obs;
  final _passwordController = TextEditingController().obs;
  final _fullNameController = TextEditingController().obs;
  final _confirmPasswordController = TextEditingController().obs;
  final _mobileNumberController = TextEditingController().obs;

  final isPasswordHidden = true.obs;
  bool get isLoading => state.isLoading.value;

  TextEditingController get emailController => _emailController.value;
  TextEditingController get passwordController => _passwordController.value;
  TextEditingController get fullNameController => _fullNameController.value;
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController.value;
  TextEditingController get mobileNumberController =>
      _mobileNumberController.value;

  void onUpint() {
    super.onInit();
  }

  void navigateToLogin() {
    Get.toNamed('/signInPage');
  }
}
