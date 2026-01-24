import 'package:get/get.dart';

class SignInState {
  RxBool isLoading = false.obs;
  RxBool is2FaLoading = false.obs;
  RxBool isOtpValid = false.obs;

  RxBool userName = false.obs;
  RxBool password = false.obs;
  RxBool isForget = false.obs;
  RxBool isPasswordHidden = true.obs;
  RxBool focusEmail = false.obs;
  RxBool focusPassword = false.obs;
  RxBool isEmailValid = true.obs;
  RxBool isPasswordValid = true.obs;

  String? tempToken;
}
