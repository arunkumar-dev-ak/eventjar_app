import 'package:dio/dio.dart';
import 'package:eventjar/api/user_profile_api/user_profile_api.dart';
import 'package:eventjar/controller/profile_form/business_info/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart' show ApiErrorHandler;
import 'package:eventjar/model/user_profile/user_profile.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BusinessInfoFormController extends GetxController {
  var appBarTitle = "Update Business Info";
  final state = BusinessInfoFormState();
  final formKey = GlobalKey<FormState>();

  late String? _originalBusinessName;
  late String? _originalBusinessCategory;
  late String? _originalBusinessWebsite;
  late String? _originalBusinessEmail;
  late String? _originalBusinessPhone;
  late String? _originalBusinessAddress;

  final businessNameController = TextEditingController();
  final businessWebsiteController = TextEditingController();
  final businessEmailController = TextEditingController();
  final businessPhoneController = TextEditingController();
  final businessAddressController = TextEditingController();

  // Business categories
  final List<String> businessCategories = [
    'IT',
    'Retail',
    'Healthcare',
    'Finance',
    'Education',
    'Manufacturing',
    'Consulting',
    'Marketing',
    'Real Estate',
    'Food & Beverage',
    'Other',
  ];

  final List<String> operatingRegions = [
    'Local/City',
    'State/Province',
    'National',
    'International',
    'North America',
    'Europe',
    'Asia Pacific',
    'Middle East',
    'Africa',
    'South America',
  ];

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

    final extended = profile.extendedProfile;

    // Store original values for comparison
    _originalBusinessName = profile.company;
    _originalBusinessCategory = extended?.businessCategory;
    _originalBusinessWebsite = profile.website;
    _originalBusinessEmail = extended?.businessEmail;
    _originalBusinessPhone = extended?.businessPhone;
    _originalBusinessAddress = profile.location;

    // Populate form controllers
    businessNameController.text = _originalBusinessName ?? '';
    state.selectedBusinessCategory.value = _originalBusinessCategory ?? '';
    businessWebsiteController.text = _originalBusinessWebsite ?? '';
    businessEmailController.text = _originalBusinessEmail ?? '';

    final localPhone = getLocalNumberSimple(_originalBusinessPhone);
    businessPhoneController.text = localPhone;

    businessAddressController.text = _originalBusinessAddress ?? '';
  }

  String getLocalNumberSimple(String? phone) {
    if (phone == null || phone.isEmpty) return '';
    if (phone.startsWith('+') && phone.length > 3) {
      return phone.substring(3);
    }
    return phone;
  }

  void clearForm() {
    // Reset to original values like in basic_info
    final args = Get.arguments;
    handleProfile(args);
  }

  bool _hasFieldChanged({required String? original, required String current}) {
    if ((original == null || original.trim().isEmpty) &&
        current.trim().isEmpty) {
      return false;
    }

    return original?.trim() != current.trim();
  }

  Map<String, dynamic> _gatherFormData() {
    final phoneWithCode =
        '${state.selectedCountryCode.value}${businessPhoneController.text.trim()}';
    final data = <String, dynamic>{};

    if (_hasFieldChanged(
      original: _originalBusinessName,
      current: businessNameController.text,
    )) {
      data['company'] = businessNameController.text.trim();
    }
    if (state.selectedBusinessCategory.value.isNotEmpty &&
        _hasFieldChanged(
          original: _originalBusinessCategory,
          current: state.selectedBusinessCategory.value,
        )) {
      data['businessCategory'] = state.selectedBusinessCategory.value;
    }
    if (_hasFieldChanged(
      original: _originalBusinessWebsite,
      current: businessWebsiteController.text,
    )) {
      data['website'] = businessWebsiteController.text.trim();
    }
    if (_hasFieldChanged(
      original: _originalBusinessEmail,
      current: businessEmailController.text,
    )) {
      data['businessEmail'] = businessEmailController.text.trim();
    }

    if (_hasFieldChanged(
      original: _originalBusinessPhone,
      current: phoneWithCode,
    )) {
      data['businessPhone'] = phoneWithCode;
    }

    if (_hasFieldChanged(
      original: _originalBusinessAddress,
      current: businessAddressController.text,
    )) {
      data['location'] = businessAddressController.text.trim();
    }

    return data;
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    final data = _gatherFormData();
    if (data.isEmpty) {
      Navigator.pop(Get.context!);
      return;
    }

    try {
      state.isLoading.value = true;
      await UserProfileApi.updateUserProfile(data); // Your API
      AppSnackbar.success(title: "Success", message: "Business info updated");
      Navigator.pop(Get.context!, "refresh");
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
