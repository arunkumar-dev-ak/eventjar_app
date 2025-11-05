import 'package:dio/dio.dart';
import 'package:eventjar_app/api/user_profile_api/user_profile_api.dart';
import 'package:eventjar_app/controller/user_profile/state.dart';
import 'package:eventjar_app/global/app_snackbar.dart';
import 'package:eventjar_app/helper/apierror_handler.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  var appBarTitle = "EventJar";
  final state = UserProfileState();

  void onInint() {
    super.onInit();
  }

  void onTabOpen() {
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      state.isLoading.value = true;

      final response = await UserProfileApi.getUserProfile();
      state.userProfile.value = response.data;
    } catch (err) {
      if (err is DioException) {
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
        'twitter': '',
        'facebook': '',
        'instagram': '',
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
}
