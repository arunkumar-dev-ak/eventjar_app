import 'package:dio/dio.dart';
import 'package:eventjar/api/user_profile_api/user_profile_api.dart';
import 'package:eventjar/controller/profile_form/basic_info/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/model/user_profile/user_profile.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:get/get.dart';

class BasicInfoFormController extends GetxController {
  var appBarTitle = "Update Basic Info";
  final state = BasicInfoFormState();
  final formKey = GlobalKey<FormState>();

  // String? profileId;

  late String? _originalFullName;
  late String? _originalPhone;
  late String? _originalJobTitle;

  final fullNameController = TextEditingController();
  // final usernameController = TextEditingController();
  // final emailController = TextEditingController();
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

    handleProfile(profile);
    super.onInit();
  }

  void handleProfile(UserProfile? profile) {
    if (profile == null) {
      return;
    }

    _originalFullName =
        profile.extendedProfile?.fullName ?? profile.name ?? profile.username;
    _originalPhone = profile.phoneParsed?.fullNumber;
    _originalJobTitle = profile.extendedProfile?.position ?? profile.jobTitle;

    // full name
    fullNameController.text =
        profile.extendedProfile?.fullName ??
        profile.name ??
        profile.username ??
        '';
    // professional title
    professionalTitleController.text =
        profile.extendedProfile?.position ?? profile.jobTitle ?? '';
    //mobile
    handlePhoneNumberArgs(profile);
  }

  void handlePhoneNumberArgs(UserProfile profile) {
    final selectedCountryCode = profile.phoneParsed?.countryCode ?? "+91";
    final String cleanCountryCode = selectedCountryCode.replaceAll('+', '');
    state.selectedCountry.value = countries.firstWhere(
      (country) => country.fullCountryCode == cleanCountryCode,
    );
    mobileController.text = profile.phoneParsed?.phoneNumber ?? "";
  }

  void clearForm() {
    final args = Get.arguments;
    UserProfile? profile;

    if (args is UserProfileResponse) {
      profile = args.data;
    } else if (args is UserProfile) {
      profile = args;
    } else if (args is Map && args.containsKey('profile')) {
      profile = args['profile'];
    }

    handleProfile(profile);
    // formKey.currentState?.reset();
  }

  bool _hasFieldChanged({required String? original, required String current}) {
    return original?.trim() != current.trim();
  }

  Map<String, dynamic> _gatherFormData() {
    final countryCode = state.selectedCountry.value.fullCountryCode;
    final localPhoneNumber = mobileController.text.trim();
    final fullPhoneNumber = '+$countryCode$localPhoneNumber';
    final data = <String, dynamic>{};

    if (_hasFieldChanged(
      original: _originalFullName,
      current: fullNameController.text,
    )) {
      data['name'] = fullNameController.text.trim();
    }

    if (_hasFieldChanged(original: _originalPhone, current: fullPhoneNumber)) {
      data['phone'] = fullPhoneNumber;
    }

    if (_hasFieldChanged(
      original: _originalJobTitle,
      current: professionalTitleController.text,
    )) {
      data['jobTitle'] = professionalTitleController.text.trim();
    }

    return data;
  }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    try {
      state.isLoading.value = true;
      final data = _gatherFormData();
      if (data.isEmpty) {
        Navigator.pop(context);
        return;
      }

      await UserProfileApi.updateUserProfile(data);

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

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage);
  }
}
