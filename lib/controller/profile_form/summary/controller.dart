import 'package:dio/dio.dart';
import 'package:eventjar/api/user_profile_api/user_profile_api.dart';
import 'package:eventjar/controller/profile_form/summary/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/user_profile/user_profile.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SummaryFormController extends GetxController {
  var appBarTitle = "Update Professional Summary";
  final state = SummaryFormState();
  final formKey = GlobalKey<FormState>();

  late String? _originalShortBio;
  late String? _originalYearsInBusiness;
  late String? _originalAvailabilitySlots;

  final shortBioController = TextEditingController();
  final yearsInBusinessController = TextEditingController();
  final availabilitySlotsController = TextEditingController();

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
    if (profile == null) return;

    final extended = profile.extendedProfile;

    // Store original values
    _originalShortBio = extended?.shortBio;
    _originalYearsInBusiness = extended?.yearsInBusiness?.toString();
    _originalAvailabilitySlots = extended?.availabilitySlots;

    // Populate controllers
    shortBioController.text = _originalShortBio ?? '';
    yearsInBusinessController.text = _originalYearsInBusiness ?? '';
    availabilitySlotsController.text = _originalAvailabilitySlots ?? '';
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
  }

  bool _hasFieldChanged({required String? original, required String current}) {
    if ((original == null || original.trim().isEmpty) &&
        current.trim().isEmpty) {
      return false;
    }
    return original?.trim() != current.trim();
  }

  Map<String, dynamic> _gatherFormData() {
    final data = <String, dynamic>{};

    if (_hasFieldChanged(
      original: _originalShortBio,
      current: shortBioController.text,
    )) {
      data['shortBio'] = shortBioController.text.trim();
    }

    if (_hasFieldChanged(
      original: _originalYearsInBusiness,
      current: yearsInBusinessController.text,
    )) {
      final years = int.tryParse(yearsInBusinessController.text.trim());
      if (years != null) {
        data['yearsInBusiness'] = years;
      }
    }

    if (_hasFieldChanged(
      original: _originalAvailabilitySlots,
      current: availabilitySlotsController.text,
    )) {
      data['availabilitySlots'] = availabilitySlotsController.text.trim();
    }

    return data;
  }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final data = _gatherFormData();
    if (data.isEmpty) {
      Navigator.pop(context);
      return;
    }

    try {
      state.isLoading.value = true;

      await UserProfileApi.updateUserProfile(data);

      AppSnackbar.success(
        title: "Success",
        message: "Profile summary updated successfully",
      );

      Navigator.pop(context, "refresh");
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          UserStore.to.clearStore();
          Get.toNamed(RouteName.signInPage);
          return;
        }
        ApiErrorHandler.handleError(err, "Failed to update summary");
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
}
