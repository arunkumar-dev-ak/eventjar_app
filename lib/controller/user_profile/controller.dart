import 'dart:io';
import 'package:eventjar/model/auth/login_model.dart';
import 'package:eventjar/model/user_profile/user_profile.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'dart:async';

import '../../api/verify_api/email.dart';
import '../../api/verify_api/phone.dart';

import '../../global/image_process.dart';

class UserProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var appBarTitle = "EventJar";
  final state = UserProfileState();
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // late AnimationController shakeController;
  // late Animation<double> shakeAnimation;

  RxBool get isLoggedIn => UserStore.to.isLoginReactive;
  RxMap<String, dynamic> get profile => UserStore.to.profile;

  final passwordController = TextEditingController();

  final DashboardController dashboardController = Get.find();

  bool isProcessing = false;

  @override
  void onInit() async {
    super.onInit();
    loadAppInfo();
    // shakeController = AnimationController(
    //   duration: Duration(milliseconds: 800),
    //   vsync: this,
    // );

    // shakeAnimation = Tween<double>(begin: -0.08, end: 0.08).animate(
    //   CurvedAnimation(parent: shakeController, curve: Curves.easeInOut),
    // );

    // shakeController.repeat(reverse: true);
  }

  Future<void> loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    state.appVersion.value = '${info.version} (${info.buildNumber})';
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
                //_getImageFromCamera();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.collections, color: Colors.blue),
              title: Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                //_getImageFromGallery();
                _pickImage(ImageSource.gallery);
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 90,
      );

      if (pickedFile != null) {
        // Crop the image
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Profile Photo',
              toolbarColor: const Color(0xFF1A73E8),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
              hideBottomControls: false,
              showCropGrid: true,
            ),
            IOSUiSettings(
              title: 'Crop Profile Photo',
              aspectRatioLockEnabled: true,
              resetAspectRatioEnabled: false,
            ),
          ],
        );

        if (croppedFile == null) {
          return; // User cancelled cropping
        }

        state.isProfileLoading.value = true;
        state.isEditingAvatar.value = true;

        final bytes = await File(croppedFile.path).readAsBytes();

        // Remove background using remove.bg API
        final result = await ProfileImageProcessor.processFromBytes(bytes);

        if (result.success && result.imageBytes != null) {
          await _saveProcessedImage(result.imageBytes!);
        } else {
          // Fallback: use cropped image as-is if bg removal fails
          state.selectedAvatarFile.value = File(croppedFile.path);
          AppSnackbar.error(
            title: 'Background removal failed',
            message: result.errorMessage ?? 'Using original image',
          );
        }

        state.isProfileLoading.value = false;
      }
    } catch (e) {
      isProcessing = false;
    }
  }

  Future<void> _saveProcessedImage(Uint8List imageBytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/profile_image_$timestamp.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);
      imageCache.clear();
      imageCache.clearLiveImages();
      state.selectedAvatarFile.value = File(filePath);
      state.isEditingAvatar.value = true;
    } catch (e) {
      debugPrint('Error saving processed image: $e');
    }
  }

  // Future<void> _getImageFromCamera() async {
  //   try {
  //     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  //     if (pickedFile != null) {
  //       state.selectedAvatarFile.value = File(pickedFile.path);
  //       state.isEditingAvatar.value = true;
  //     }
  //   } catch (e) {
  //     LoggerService.loggerInstance.e(e);
  //     AppSnackbar.error(title: 'Error', message: 'Could not access camera');
  //   }
  // }

  // // 4. Pick from gallery
  // Future<void> _getImageFromGallery() async {
  //   try {
  //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       state.selectedAvatarFile.value = File(pickedFile.path);
  //       print(state.selectedAvatarFile.value);
  //       state.isEditingAvatar.value = true;
  //     }
  //   } catch (e) {
  //     LoggerService.loggerInstance.e(e);
  //     AppSnackbar.error(title: 'Error', message: 'Could not access gallery');
  //   }
  // }

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
        imageCache.clear();
        imageCache.clearLiveImages();
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

  /// Check if phone is verified
  bool get isPhoneVerified {
    return state.userProfile.value?.phoneVerified ?? false;
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

  void navigateToConfigureNotification() {
    Get.toNamed(RouteName.notificationpage)?.then(
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

  /*----- Phone OTP Verification -----*/
  Timer? _resendTimer;

  Future<bool> sendPhoneOtp() async {
    final phone =
        state.userProfile.value?.phone ??
        state.userProfile.value?.phoneParsed?.fullNumber;
    if (phone == null || phone.isEmpty) {
      AppSnackbar.error(
        title: "Error",
        message: "No phone number found on your profile",
      );
      return false;
    }

    state.isSendingOtp.value = true;
    state.otpError.value = '';
    try {
      await VerifyPhoneApi.sendOtp(phone);
      _startResendCooldown();
      return true;
    } catch (err) {
      if (err is DioException) {
        ApiErrorHandler.handleError(err, "Failed to send OTP");
      } else {
        AppSnackbar.error(title: "Error", message: err.toString());
      }
      return false;
    } finally {
      state.isSendingOtp.value = false;
    }
  }

  Future<bool> verifyPhoneOtp(String otp) async {
    final phone =
        state.userProfile.value?.phone ??
        state.userProfile.value?.phoneParsed?.fullNumber;
    if (phone == null || phone.isEmpty) return false;

    state.isVerifyingOtp.value = true;
    state.otpError.value = '';
    try {
      await VerifyPhoneApi.verifyOtp(phone, otp);
      await fetchUserProfile();
      return true;
    } catch (err) {
      if (err is DioException) {
        final data = err.response?.data;
        if (data is Map && data['message'] is String) {
          state.otpError.value = data['message'];
        } else if (data is String) {
          state.otpError.value = data;
        } else {
          state.otpError.value = 'Verification failed. Please try again.';
        }
      } else {
        state.otpError.value = err.toString();
      }
      return false;
    } finally {
      state.isVerifyingOtp.value = false;
    }
  }

  void _startResendCooldown() {
    state.resendCooldown.value = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCooldown.value <= 1) {
        timer.cancel();
        state.resendCooldown.value = 0;
      } else {
        state.resendCooldown.value--;
      }
    });
  }

  void resetOtpState() {
    state.otpError.value = '';
    state.isSendingOtp.value = false;
    state.isVerifyingOtp.value = false;
  }

  /*----- Email Verification -----*/

  Future<bool> sendEmailVerification() async {
    try {
      await VerifyEmailApi.resendVerify();
      return true;
    } catch (err) {
      if (err is DioException) {
        ApiErrorHandler.handleError(err, "Failed to send verification email");
      } else {
        AppSnackbar.error(
          title: "Error",
          message: "Something went wrong. Please try again.",
        );
      }
      return false;
    }
  }

  void openEmailApp() async {
    try {
      if (Platform.isIOS) {
        for (final uri in [
          Uri.parse('googlegmail://'),
          Uri.parse('ms-outlook://'),
          Uri.parse('message://'),
        ]) {
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
            return;
          }
        }
      } else {
        final androidApps = [
          'intent://#Intent;package=com.google.android.gm;action=android.intent.action.MAIN;category=android.intent.category.LAUNCHER;end',
          'intent://#Intent;package=com.microsoft.office.outlook;action=android.intent.action.MAIN;category=android.intent.category.LAUNCHER;end',
          'intent://#Intent;package=com.samsung.android.email.provider;action=android.intent.action.MAIN;category=android.intent.category.LAUNCHER;end',
        ];
        for (final intentStr in androidApps) {
          try {
            await launchUrl(
              Uri.parse(intentStr),
              mode: LaunchMode.externalApplication,
            );
            return;
          } catch (_) {}
        }
      }
      AppSnackbar.error(title: "Error", message: "No email app found.");
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      AppSnackbar.error(title: "Error", message: "Could not open email app.");
    }
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    // shakeController.dispose();
    super.onClose();
  }
}
