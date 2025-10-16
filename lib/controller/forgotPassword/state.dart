import 'package:get/get.dart';

class ForgotPasswordState {
  RxBool isLoading = false.obs;

  RxBool gmail = false.obs;

  RxBool focusEmail = false.obs;

  RxBool isEmailValid = true.obs;
}
