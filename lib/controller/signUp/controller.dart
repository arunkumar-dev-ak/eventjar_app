import 'package:dio/dio.dart';
import 'package:eventjar/api/sign_up_api/sign_up_api.dart';
import 'package:eventjar/controller/signUp/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/global/global_values.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String? invitationToken;

  TextEditingController get emailController => _emailController.value;
  TextEditingController get passwordController => _passwordController.value;
  TextEditingController get fullNameController => _fullNameController.value;
  TextEditingController get mobileNumberController =>
      _mobileNumberController.value;

  @override
  void onInit() {
    UserStore.cancelAllRequests();
    super.onInit();

    final args = Get.arguments;

    if (args != null && args['token'] != null) {
      invitationToken = args['token'];
      _resolveInvitation(invitationToken!);
    }
  }

  void navigateToLogin() {
    Get.until((route) => route.settings.name == '/signInPage');
  }

  Map<String, dynamic> getSignUpData() {
    return {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "name": capitalizeName(fullNameController.text.trim()),
      "phone": mobileNumberController.text.trim(),
      "countryCode": state.selectedCountry.value.code,
      if (invitationToken != null) "invitationToken": invitationToken,
    };
  }

  void handleSignUpSubmit(BuildContext context) async {
    state.isLoading.value = true;
    try {
      final signUpData = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "name": capitalizeName(fullNameController.text.trim()),
        "phone": mobileNumberController.text.trim(),
        "countryCode": '+${state.selectedCountry.value.fullCountryCode}',
        "mobile": mobileNumberController.text.trim(),
      };

      var response = await SignUpApi.signUp(signUpData);

      // AppSnackbar.success(title: "Sign Up Successful", message: message);
      await UserStore.to.handleSetLocalData(response);
      AppSnackbar.success(
        title: "account_created".tr,
        message: "account_created_success".tr,
      );
      state.isLoading.value = false;
      Navigator.pop(context, "logged_in");
    } catch (err) {
      state.isLoading.value = false;
      if (err is DioException) {
        ApiErrorHandler.handleDioError(err, "sign_up_error".tr);
      } else {
        AppSnackbar.error(
          title: "sign_up_error".tr,
          message: "generic_try_again_error".tr,
        );
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  /* Handle Invitation */
  Future<void> _resolveInvitation(String token) async {
    try {
      state.isFetchigInvitation.value = true;

      final response = await SignUpApi.resolveInvitation(token);
      final data = response.data;

      // Prefill fields
      if (data.name != null) {
        fullNameController.text = data.name!;
      }

      if (data.email != null) {
        emailController.text = data.email!;
      }

      if (data.phoneParsed != null) {
        mobileNumberController.text = data.phoneParsed!.phoneNumber;

        //country code
        final selectedCountryCode = data.phoneParsed?.countryCode ?? "+91";
        final String cleanCountryCode = selectedCountryCode.replaceAll('+', '');
        state.selectedCountry.value = countries.firstWhere(
          (country) => country.fullCountryCode == cleanCountryCode,
          orElse: () => countries.first,
        );
      }
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 404) {
          AppSnackbar.error(
            title: "invalid_invite".tr,
            message: "invitation_not_found".tr,
          );
        } else if (statusCode == 410) {
          AppSnackbar.error(
            title: "expired_invite".tr,
            message: "invitation_expired".tr,
          );
        } else {
          ApiErrorHandler.handleDioError(err, "Invite Error");
        }
      }
    } finally {
      state.isFetchigInvitation.value = false;
    }
  }

  Future<void> handleLinkedIn() async {
    state.isLinkedinLoading.value = true;
    final url = "${backendBaseUrl()}/auth/linkedin?platform=mobile";
    final Uri authUri = Uri.parse(url);
    try {
      if (await canLaunchUrl(authUri)) {
        await launchUrl(authUri, mode: LaunchMode.inAppBrowserView);
      } else {
        throw 'Could not launch browser.Kindly try again after some time.';
      }
    } catch (err) {
      LoggerService.loggerInstance.e(err);
      if (err is DioException) {
        ApiErrorHandler.handleDioError(err, "authentication_failed".tr);
      } else {
        AppSnackbar.error(
          title: "authentication_failed".tr,
          message: "generic_try_again_error".tr,
        );
      }
    } finally {
      state.isLinkedinLoading.value = false;
    }
  }

  void navigateToBackPage(BuildContext context) {
    Navigator.pop(context);
  }

  void navigateToAuthProcessign(String idToken) {
    Get.toNamed(
      RouteName.authProcessingPage,
      arguments: {'idToken': idToken},
    )?.then((result) {
      if (result == "logged_in") {
        Navigator.pop(Get.context!, "logged_in");
      }
    });
  }

  // Full Name validator
  String? validateFullName(String? val) {
    if (val == null || val.trim().isEmpty) return "full_name_required".tr;
    if (val.trim().length < 2) return "Full Name must be at least 2 characters";
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(val.trim())) {
      return "Full Name can only contain letters, spaces, hyphens, or apostrophes";
    }
    return null;
  }

  // Email validator
  String? validateEmail(String? val) {
    if (val == null || val.isEmpty) return 'email_required'.tr;
    if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$",
    ).hasMatch(val)) {
      return "Enter a valid email address";
    }
    return null;
  }

  // Mobile Number validator
  String? validateMobileNumber(String? val) {
    if (val == null || val.isEmpty) return "Mobile Number is required";
    if (!RegExp(r"^\d{10}$").hasMatch(val)) {
      return "Mobile Number must be exactly 10 digits";
    }
    return null;
  }

  // Password validator
  String? validatePassword(String? val) {
    if (val == null || val.isEmpty) return "Password is required";
    if (val.length < 8) return "Password must be at least 8 characters";
    if (!RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$",
    ).hasMatch(val)) {
      return "Password must contain uppercase, lowercase, number, and special character";
    }
    return null;
  }
}
