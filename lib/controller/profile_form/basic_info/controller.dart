import 'package:dio/dio.dart';
import 'package:eventjar/controller/profile_form/basic_info/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/user_profile/user_profile.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BasicInfoFormController extends GetxController {
  var appBarTitle = "Update Basic Info";
  final state = BasicInfoFormState();
  final formKey = GlobalKey<FormState>();

  String? profileId;

  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final professionalTitleController = TextEditingController();

  @override
  void onInit() {
    final args = Get.arguments;
    UserProfile? profile;

    if (args is UserProfileResponse) {
      profile = args.data;
    } else if (args is UserProfile) {
      profile = args;
    } else if (args is Map && args.containsKey('profile')) {
      profile = args['profile'];
    }

    LoggerService.loggerInstance.dynamic_d(profile);

    handleProfile(profile);
    super.onInit();
  }

  void handleProfile(UserProfile? profile) {
    if (profile == null) {
      profileId = null;
      return;
    }

    profileId = profile.id;
    fullNameController.text = profile.extendedProfile?.fullName ?? '';
    usernameController.text = profile.username;
    emailController.text = profile.email;
    mobileController.text = profile.extendedProfile?.mobileNumber ?? '';
    professionalTitleController.text = profile.extendedProfile?.position ?? '';
  }

  void clearForm() {
    fullNameController.clear();
    usernameController.clear();
    emailController.clear();
    mobileController.clear();
    professionalTitleController.clear();
    formKey.currentState?.reset();
  }

  Map<String, dynamic> _gatherFormData() {
    return {
      'fullName': fullNameController.text.trim(),
      'username': usernameController.text.trim(),
      'email': emailController.text.trim(),
      'mobileNumber': mobileController.text.trim(),
      'position': professionalTitleController.text.trim(),
    };
  }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    try {
      state.isLoading.value = true;
      final data = _gatherFormData();

      if (profileId == null) {
        throw Exception("Profile ID is required for update");
      }

      // await ProfileUpdateApi.updateBasicInfo(
      //   data: data,
      //   id: profileId!,
      // ); // Adjust API call

      AppSnackbar.success(
        title: "Success",
        message: "Basic info updated successfully",
      );

      Navigator.pop(context, "refresh");
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }
        ApiErrorHandler.handleError(err, "Failed to update basic info");
      } else {
        AppSnackbar.error(
          title: "Failed",
          message: "Something went wrong. Please try again.",
        );
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  bool checkIsForUpdate() {
    return profileId != null && profileId!.isNotEmpty;
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage);
  }
}
