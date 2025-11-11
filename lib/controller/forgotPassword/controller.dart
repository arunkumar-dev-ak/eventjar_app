import 'package:dio/dio.dart';
import 'package:eventjar/api/forgot_password_api/forgot_password_api.dart';
import 'package:eventjar/controller/forgotPassword/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
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

  Map<String, dynamic> getForgotPasswordData() {
    return {"email": emailController.text.trim()};
  }

  Future<bool> handleForgotPasswordSubmit(BuildContext context) async {
    try {
      state.isLoading.value = true;
      final message = await ForgotPasswordApi.forgotPassword(
        getForgotPasswordData(),
      );

      AppSnackbar.success(title: "Email Sent", message: message);

      return true;
    } catch (err) {
      state.isLoading.value = false;
      if (err is DioException) {
        ApiErrorHandler.handleError(err, "Email Send Failed");
      } else {
        AppSnackbar.error(
          title: "Email Send Failed",
          message: "Something went wrong. Please try again.",
        );
      }
      return false;
    } finally {
      state.isLoading.value = false;
    }
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
