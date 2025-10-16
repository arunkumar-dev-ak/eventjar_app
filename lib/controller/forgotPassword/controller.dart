import 'package:eventjar_app/controller/forgotPassword/state.dart';
import 'package:eventjar_app/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPasswordController extends GetxController {
  var appBarTitle = "";
  final state = ForgotPasswordState();
  final emailFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController().obs;

  bool get isLoading => state.isLoading.value;

  TextEditingController get emailController => _emailController.value;

  @override
  void onInit() {
    Future.delayed(Duration.zero, () {
      emailFocusNode.requestFocus();
    });
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

  void openEmailApp() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '', // leave empty to open email app
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        // Use default launch mode for mailto
        await launchUrl(emailLaunchUri);
      } else {
        Get.snackbar('Error', 'No email app found.');
      }
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      Get.snackbar('Error', 'Could not open email app.');
    }
  }
}
