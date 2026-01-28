import 'dart:io';
import 'package:eventjar/model/auth/login_model.dart';
import 'package:eventjar/model/user_profile/user_profile.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:eventjar/api/user_profile_api/user_profile_api.dart';
import 'package:eventjar/controller/dashboard/controller.dart';
import 'package:eventjar/controller/user_profile/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/page/user_profile/user_profile_security/user_profile_security_info.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileController extends GetxController {
  var appBarTitle = "EventJar";
  final state = UserProfileState();
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  RxBool get isLoggedIn => UserStore.to.isLoginReactive;
  RxMap<String, dynamic> get profile => UserStore.to.profile;

  final passwordController = TextEditingController();

  final DashboardController dashboardController = Get.find();

  @override
  void onInit() async {
    super.onInit();
  }

  void onTabOpen() async {
    state.isLoading.value = true;
    await fetchUserProfile();
    if (isLoggedIn.value == true) {
      await checkDeletionStatus();
    }
    state.isDeleteLoading.value = false;
  }

  void checkAndUpdateLocalProfileInfo() async {
    final currentUserProfile = state.userProfile.value;
    if (currentUserProfile == null || profile.isEmpty) {
      return;
    }

    final updatedUser = _mapUserProfileToUser(currentUserProfile);

    final localName = profile['name']?.toString();
    final localPhone = profile['phone']?.toString();
    final localAvatar = profile['avatarUrl']?.toString();

    final newName = updatedUser.name;
    final newPhone = updatedUser.phone;
    final newAvatar = updatedUser.avatarUrl;

    final hasChanges =
        localName != newName ||
        localPhone != newPhone ||
        localAvatar != newAvatar;

    if (hasChanges) {
      LoggerService.loggerInstance.d(
        "🔄 Profile sync: ${updatedUser.displayName}",
      );

      // Update UserStore
      await UserStore.to.handleSetLocalDataForProfileUpdate(updatedUser);
    } else {
      // LoggerService.loggerInstance.d(
      //   "✅ Profile up to date: ${updatedUser.displayName}",
      // );
    }
  }

  User _mapUserProfileToUser(UserProfile userProfile) {
    return User(
      id: userProfile.id,
      email: userProfile.email,
      name: userProfile.name,
      phone: userProfile.phone,
      role: userProfile.role,
      isVerified: userProfile.isVerified,
      avatarUrl: userProfile.avatarUrl,
      bio: userProfile.bio,
      company: userProfile.company,
      jobTitle: userProfile.jobTitle,
      location: userProfile.location,
      phoneParsed: userProfile.phoneParsed,
      linkedin:
          userProfile.linkedin ?? userProfile.extendedProfile?.linkedinProfile,
      website:
          userProfile.website ?? userProfile.extendedProfile?.businessWebsite,
      username: userProfile.username,
    );
  }

  Future<void> checkDeletionStatus() async {
    try {
      final response = await UserProfileApi.fetchDeletionAccountRequest();
      state.deleteAccountResponse.value = response;
    } catch (err) {
      LoggerService.loggerInstance.e(err);
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

  bool get isAccountDeleted {
    final response = state.deleteAccountResponse.value;
    if (response?.data.deletedAt != null) return true;
    return false;
  }

  bool get hasPendingDeletion {
    final response = state.deleteAccountResponse.value;
    return response?.data.hasPendingDeletion == true;
  }

  void checkPopupView() {
    if (isAccountDeleted) {
      showDeletedAccountDialog(this);
    } else if (hasPendingDeletion) {
      userProfileShowDeleteAccountDialog(this, isReactivate: true);
    } else {
      userProfileShowDeleteAccountDialog(this, isReactivate: false);
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await UserProfileApi.getUserProfile();
      state.userProfile.value = response.data;
      checkAndUpdateLocalProfileInfo();
    } catch (err) {
      LoggerService.loggerInstance.e(err);
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          await UserStore.to.clearStore();
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

  Future<void> selectAvatarImage() async {
    if (state.isProfileLoading.value) return;
    await Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Change Profile Photo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.blue),
              title: Text('Take Photo'),
              onTap: () {
                Get.back();
                _getImageFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.collections, color: Colors.blue),
              title: Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                _getImageFromGallery();
              },
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        state.selectedAvatarFile.value = File(pickedFile.path);
        state.isEditingAvatar.value = true;
      }
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      AppSnackbar.error(title: 'Error', message: 'Could not access camera');
    }
  }

  // 4. Pick from gallery
  Future<void> _getImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        state.selectedAvatarFile.value = File(pickedFile.path);
        state.isEditingAvatar.value = true;
      }
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      AppSnackbar.error(title: 'Error', message: 'Could not access gallery');
    }
  }

  Future<void> uploadProfileAvatar() async {
    final file = state.selectedAvatarFile.value;
    if (file == null) {
      AppSnackbar.error(
        title: 'Invalid',
        message: "Something went wrong, Kindly reupload file",
      );
      return;
    }

    // 1. Validate (same rules as web)
    final validationError = _validateAvatarImage(file);
    if (validationError != null) {
      AppSnackbar.error(title: 'Invalid', message: validationError);
      return;
    }

    try {
      state.isProfileLoading.value = true;

      // 2. Upload using API
      final bool newAvatarUrl = await UserProfileApi.uploadAvatar(file);
      if (newAvatarUrl == true) {
        AppSnackbar.success(
          title: 'Success',
          message: 'Profile picture updated!',
        );
        state.isEditingAvatar.value = false;
        state.selectedAvatarFile.value = null;
        onTabOpen();
      }
    } on DioException catch (e) {
      LoggerService.loggerInstance.e(e);
      if (e.response?.statusCode == 401) {
        UserStore.to.clearStore();
        navigateToSignInPage();
      }
      final msg = e.response?.data is Map
          ? e.response?.data['error']?.toString()
          : 'Failed to upload';
      AppSnackbar.error(title: 'Error', message: msg ?? 'Failed to upload');
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      AppSnackbar.error(title: 'Error', message: 'Failed to upload');
    } finally {
      state.isProfileLoading.value = false;
    }
  }

  String? _validateAvatarImage(File file) {
    final int fileSize = file.lengthSync();
    const int maxFileSize = 2 * 1024 * 1024; // 2 MB

    if (fileSize > maxFileSize) {
      return 'File too large. Maximum size is 2MB';
    }

    final String ext = file.path.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'webp'].contains(ext)) {
      return 'Only JPEG, PNG, WebP images are allowed';
    }

    final String filename = path.basename(file.path);
    if (filename.contains(RegExp(r'[<>:"/\\|?*]')) || filename.contains('..')) {
      return 'File name contains unsafe characters';
    }

    return null;
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
    return state.userProfile.value?.phoneParsed?.fullNumber ?? '';
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

  void navigateToBasicInfoUpdate() {
    Get.toNamed(
      RouteName.basicInfoFormPage,
      arguments: state.userProfile.value,
    )?.then(
      (val) => {
        if (val == 'refresh') {onTabOpen()},
      },
    );
  }

  void navigateToBusinessInfoUpdate() {
    Get.toNamed(
      RouteName.businessInfoFormPage,
      arguments: state.userProfile.value,
    )?.then(
      (val) => {
        if (val == 'refresh') {onTabOpen()},
      },
    );
  }

  void navigateToLocationInfoUpdate() {
    Get.toNamed(
      RouteName.locationFormPage,
      arguments: state.userProfile.value,
    )?.then(
      (val) => {
        if (val == 'refresh') {onTabOpen()},
      },
    );
  }

  void navigateToNetworkingInfoUpdate() {
    Get.toNamed(
      RouteName.networkingFormPage,
      arguments: state.userProfile.value,
    )?.then(
      (val) => {
        if (val == 'refresh') {onTabOpen()},
      },
    );
  }

  void navigateToProfessionalSummaryUpdate() {
    Get.toNamed(
      RouteName.summaryFormPage,
      arguments: state.userProfile.value,
    )?.then(
      (val) => {
        if (val == 'refresh') {onTabOpen()},
      },
    );
  }

  void navigateToSocialUpdate() {
    Get.toNamed(
      RouteName.socialFormPage,
      arguments: state.userProfile.value,
    )?.then(
      (val) => {
        if (val == 'refresh') {onTabOpen()},
      },
    );
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
    // dashboardController.state.selectedIndex.value = 0;
    Get.offAllNamed(RouteName.dashboardpage);
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
    // passwordController.dispose();
    super.onClose();
  }
}
