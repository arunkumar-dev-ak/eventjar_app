import 'package:dio/dio.dart';
import 'package:eventjar/api/user_profile_api/user_profile_api.dart';
import 'package:eventjar/controller/dashboard/controller.dart';
import 'package:eventjar/controller/user_profile/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/page/user_profile/user_profile_security/user_profile_security_info.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  var appBarTitle = "EventJar";
  final state = UserProfileState();
  final formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();

  final DashboardController dashboardController = Get.find();

  void onInint() {
    super.onInit();
  }

  void onTabOpen() async {
    state.isLoading.value = true;
    await fetchUserProfile();
    await checkDeletionStatus();
    state.isDeleteLoading.value = false;
  }

  Future<void> checkDeletionStatus() async {
    try {
      final response = await UserProfileApi.fetchDeletionAccountRequest();
      state.deleteAccountResponse.value = response;
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return; // Stop further error handling
        }

        ApiErrorHandler.handleError(err, "Failed to fetch user status");
      } else if (err is Exception) {
        AppSnackbar.error(title: "Exception", message: err.toString());
      } else {
        AppSnackbar.error(
          title: "Error",
          message: "Something went wrong (${err.toString()})",
        );
      }
    }
  }

  void checkPopupView() {
    final deleteResponse = state.deleteAccountResponse.value;

    if (deleteResponse != null &&
        deleteResponse.data.hasPendingDeletion == true) {
      userProfileShowDeleteAccountDialog(this, isReactivate: true);
    } else {
      userProfileShowDeleteAccountDialog(this);
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await UserProfileApi.getUserProfile();
      state.userProfile.value = response.data;
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return; // Stop further error handling
        }

        ApiErrorHandler.handleError(err, "Failed to load User Profile");
      } else if (err is Exception) {
        AppSnackbar.error(title: "Exception", message: err.toString());
      } else {
        AppSnackbar.error(
          title: "Error",
          message: "Something went wrong (${err.toString()})",
        );
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) {
      if (result == "logged_in") {
        onTabOpen();
      } else {
        dashboardController.state.selectedIndex.value = 0;
      }
    });
  }

  Future<void> handleDeleteAccount({
    required bool isReactivate,
    required String password,
  }) async {
    if (state.isDeleteLoading.value) return;
    try {
      state.isDeleteLoading.value = true;

      final response = isReactivate
          ? await UserProfileApi.cancelDeletionRequest(password: password)
          : await UserProfileApi.deleteUserProfile(password: password);

      if (response == true) {
        passwordController.clear();
        // Use API message if present, otherwise fallback
        final message = isReactivate
            ? 'Your account deletion request has been cancelled. Your account is active again.'
            : 'Your account has been deactivated and scheduled for permanent deletion in 30 days. You can reactivate anytime within this period.';

        final title = isReactivate
            ? 'Account Reactivated'
            : 'Account Deactivated';
        Get.back();

        AppSnackbar.success(title: title, message: message);

        // Navigation / state changes
        if (isReactivate) {
          // Just refresh / reopen tab
          onTabOpen();
        } else {
          // Deactivated: logout and go to dashboard index 0
          UserStore.to.clearStore();
          dashboardController.state.selectedIndex.value = 0;
        }

        Get.back();
      }
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(
          err,
          "Failed to ${isReactivate ? "reactivte" : "deactivate"} account",
        );
      } else if (err is Exception) {
        AppSnackbar.error(title: "Exception", message: err.toString());
      } else {
        AppSnackbar.error(
          title: "Error",
          message: "Something went wrong (${err.toString()})",
        );
      }
    } finally {
      state.isDeleteLoading.value = false;
    }
  }

  //helper func
  String get displayName {
    return state.userProfile.value?.name ??
        state.userProfile.value?.username ??
        'User';
  }

  /// Get avatar URL with cache busting
  String? get avatarUrl {
    final url = state.userProfile.value?.avatarUrl;
    if (url == null) return null;
    return '$url?v=${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Check if user has extended profile
  bool get hasExtendedProfile {
    return state.userProfile.value?.extendedProfile != null;
  }

  /// Get business name (fallback to company)
  String get businessName {
    return state.userProfile.value?.extendedProfile?.businessName ??
        state.userProfile.value?.company ??
        '';
  }

  /// Get professional title (fallback to jobTitle)
  String get professionalTitle {
    return state.userProfile.value?.extendedProfile?.position ??
        state.userProfile.value?.jobTitle ??
        '';
  }

  /// Get bio (fallback to shortBio)
  String get bio {
    return state.userProfile.value?.bio ??
        state.userProfile.value?.extendedProfile?.shortBio ??
        '';
  }

  /// Get email
  String get email {
    return state.userProfile.value?.email ?? '';
  }

  /// Get phone
  String get phone {
    return state.userProfile.value?.phone ??
        state.userProfile.value?.extendedProfile?.mobileNumber ??
        '';
  }

  /// Get username
  String get username {
    return state.userProfile.value?.username ?? '';
  }

  /// Get role
  String get role {
    return state.userProfile.value?.role ?? 'ATTENDEE';
  }

  /// Check if user is verified
  bool get isVerified {
    return state.userProfile.value?.isVerified ?? false;
  }

  /// Get social media links
  Map<String, String> get socialLinks {
    final extended = state.userProfile.value?.extendedProfile;
    if (extended == null) {
      return {
        'linkedin': state.userProfile.value?.linkedin ?? '',
        'website': state.userProfile.value?.website ?? '',
        'twitter':
            state
                .userProfile
                .value
                ?.extendedProfile
                ?.socialMediaLinks
                .twitter ??
            "",
        'facebook':
            state
                .userProfile
                .value
                ?.extendedProfile
                ?.socialMediaLinks
                .facebook ??
            "",
        'instagram':
            state
                .userProfile
                .value
                ?.extendedProfile
                ?.socialMediaLinks
                .instagram ??
            "",
      };
    }

    return {
      'linkedin':
          extended.linkedinProfile ??
          state.userProfile.value?.linkedin ??
          extended.socialMediaLinks.linkedin,
      'website':
          extended.businessWebsite ?? state.userProfile.value?.website ?? '',
      'twitter': extended.socialMediaLinks.twitter,
      'facebook': extended.socialMediaLinks.facebook,
      'instagram': extended.socialMediaLinks.instagram,
    };
  }

  void handleLogout() {
    UserStore.to.clearStore();
    dashboardController.state.selectedIndex.value = 0;
    AppSnackbar.success(
      title: "Logged Out Successfully",
      message: "You have been logged out.",
    );
  }

  void navigateToResetPassword() {
    Get.toNamed(RouteName.forgotPasswordPage);
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}
