import 'package:dio/dio.dart';
import 'package:eventjar/api/signin_api/signin_api.dart';
import 'package:eventjar/controller/change_password/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final state = ChangePasswordState();

  final formKey = GlobalKey<FormState>();

  final currentPwdController = TextEditingController();
  final newPwdController = TextEditingController();
  final confirmPwdController = TextEditingController();

  // VALIDATIONS
  String? validateCurrentPwd(String? val) {
    if (val == null || val.isEmpty) return "Current password required";
    return null;
  }

  String? validateNewPwd(String? val) {
    if (val == null || val.isEmpty) return "New password required";
    if (val.length < 6) return "Minimum 6 characters";
    return null;
  }

  String? validateConfirmPwd(String? val) {
    if (val == null || val.isEmpty) return "Confirm your password";
    if (val != newPwdController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  // API CALL
  Future<void> handleChangePassword() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    try {
      state.isLoading.value = true;

      final success = await SignInApi.changePassword({
        "currentPassword": currentPwdController.text.trim(),
        "newPassword": newPwdController.text.trim(),
      });

      if (success) {
        Navigator.pop(Get.context!);

        AppSnackbar.success(
          title: "Success",
          message: "Password changed successfully",
        );
      }
    } catch (err) {
      if (err is DioException) {
        ApiErrorHandler.handleError(err, "Change Password Failed");
      } else {
        AppSnackbar.error(title: "Error", message: "Something went wrong");
      }
    } finally {
      state.isLoading.value = false;
    }
  }
}
