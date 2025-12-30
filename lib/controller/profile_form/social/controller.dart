import 'package:dio/dio.dart';
import 'package:eventjar/api/user_profile_api/user_profile_api.dart';
import 'package:eventjar/controller/profile_form/social/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/user_profile/user_profile.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SocialFormController extends GetxController {
  var appBarTitle = "Update Social & Contact Links";
  final state = SocialFormState();
  final formKey = GlobalKey<FormState>();

  late String? _originalLinkedin;
  late String? _originalWhatsapp;
  late String? _originalInstagram;
  late String? _originalTwitter;
  late String? _originalFacebook;

  final linkedinController = TextEditingController();
  final whatsappController = TextEditingController();
  final instagramController = TextEditingController();
  final twitterController = TextEditingController();
  final facebookController = TextEditingController();

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
    final socialLinks = extended?.socialMediaLinks;

    // Store original values
    _originalLinkedin = socialLinks?.linkedin;
    _originalWhatsapp = extended?.businessPhone;
    _originalInstagram = socialLinks?.instagram;
    _originalTwitter = socialLinks?.twitter;
    _originalFacebook = socialLinks?.facebook;

    // Populate controllers
    linkedinController.text = _originalLinkedin ?? '';
    whatsappController.text = _originalWhatsapp ?? '';
    instagramController.text = _originalInstagram ?? '';
    twitterController.text = _originalTwitter ?? '';
    facebookController.text = _originalFacebook ?? '';
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

  Map<String, dynamic> _gatherFormData() {
    final socialMediaLinks = <String, dynamic>{};

    // Always include all social links (empty string if unchanged/empty)
    socialMediaLinks['linkedin'] = linkedinController.text.trim();
    socialMediaLinks['instagram'] = instagramController.text.trim();
    socialMediaLinks['twitter'] = twitterController.text.trim();
    socialMediaLinks['facebook'] = facebookController.text.trim();

    final data = <String, dynamic>{};

    // Always send socialMediaLinks object
    data['socialMediaLinks'] = socialMediaLinks;

    // Always send businessPhone (WhatsApp/Telegram)
    data['businessPhone'] = whatsappController.text.trim();

    // Always send contact visibility
    // data['contactVisibility'] = state.contactVisibility.value;

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
        message: "Social links updated successfully",
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
        ApiErrorHandler.handleError(err, "Failed to update social links");
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
