import 'package:dio/dio.dart';
import 'package:eventjar/api/user_profile_api/user_profile_api.dart';
import 'package:eventjar/controller/profile_form/networking/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/user_profile/user_profile.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class NetworkingFormController extends GetxController {
  var appBarTitle = "Update Networking & Interests";
  final state = NetworkingFormState();
  final formKey = GlobalKey<FormState>();

  late String? _originalNetworkingGoal;
  late String? _originalConnectionTypes;
  late String? _originalHelpOfferings;
  late String? _originalDiscussionTopics;

  // Static data
  final List<String> networkingGoals = [
    'Seeking Partnerships',
    'Looking for Investors',
    'Hiring',
    'Exploring Collaborations',
    'Business Development',
    'Knowledge Sharing',
  ];

  final List<String> experienceRanges = [
    '0-1 years',
    '2-5 years',
    '6-10 years',
    '11-15 years',
    '16-20 years',
    '20+ years',
  ];

  final List<String> connectionTypes = [
    'Investors',
    'Vendors',
    'Tech Partners',
    'B2B Clients',
    'Franchise Opportunities',
    'Mentors',
    'Industry Experts',
  ];

  final List<String> helpOfferings = [
    'Funding/Investment',
    'Tech Development',
    'Digital Marketing',
    'Business Strategy',
    'Sales & Lead Generation',
    'Product Design',
    'Legal Services',
    'HR & Talent',
    'Operations',
    'Mentoring',
  ];

  final List<String> discussionTopics = [
    'Business Growth',
    'Sales Strategy',
    'Hiring & Talent',
    'SaaS',
    'E-commerce',
    'Exports',
    'Digital Transformation',
    'Funding',
    'Partnerships',
    'Technology Trends',
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
    if (profile == null) return;

    final extended = profile.extendedProfile;

    // Store original values
    _originalNetworkingGoal = extended?.networkingGoal;
    _originalConnectionTypes = extended?.interestedInConnecting?.join(',');
    _originalHelpOfferings = extended?.helpOfferings?.join(',');
    _originalDiscussionTopics = extended?.discussionTopics?.join(',');

    // Populate controllers
    state.selectedNetworkingGoal.value = _originalNetworkingGoal ?? '';

    if (_originalConnectionTypes != null) {
      state.selectedConnectionTypes.value = _originalConnectionTypes!
          .split(',')
          .map((e) => e.trim())
          .where((e) => connectionTypes.contains(e))
          .toList();
    }

    if (_originalHelpOfferings != null) {
      state.selectedHelpOfferings.value = _originalHelpOfferings!
          .split(',')
          .map((e) => e.trim())
          .where((e) => helpOfferings.contains(e))
          .toList();
    }

    if (_originalDiscussionTopics != null) {
      state.selectedDiscussionTopics.value = _originalDiscussionTopics!
          .split(',')
          .map((e) => e.trim())
          .where((e) => discussionTopics.contains(e))
          .toList();
    }
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
      original: _originalNetworkingGoal,
      current: state.selectedNetworkingGoal.value,
    )) {
      data['networkingGoal'] = state.selectedNetworkingGoal.value;
    }

    if (_hasFieldChanged(
      original: _originalConnectionTypes,
      current: state.selectedConnectionTypes.join(','),
    )) {
      data['interestedInConnecting'] = state.selectedConnectionTypes;
    }

    if (_hasFieldChanged(
      original: _originalHelpOfferings,
      current: state.selectedHelpOfferings.join(','),
    )) {
      data['helpOfferings'] = state.selectedHelpOfferings;
    }

    if (_hasFieldChanged(
      original: _originalDiscussionTopics,
      current: state.selectedDiscussionTopics.join(','),
    )) {
      data['discussionTopics'] = state.selectedDiscussionTopics;
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
        message: "Networking info updated successfully",
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
        ApiErrorHandler.handleError(err, "Failed to update networking info");
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
