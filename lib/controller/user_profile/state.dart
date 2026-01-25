import 'dart:io';

import 'package:eventjar/model/auth/delete_request_model.dart';
import 'package:eventjar/model/user_profile/user_profile.dart';
import 'package:get/get.dart';

class UserProfileState {
  final RxBool isLoading = false.obs;
  final RxBool isDeleteLoading = false.obs;
  final RxBool isProfileLoading = false.obs;

  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  final Rx<DeleteRequestResponse?> deleteAccountResponse =
      Rx<DeleteRequestResponse?>(null);

  final RxBool hasDeleteLoading = false.obs;

  RxBool isEditingAvatar = false.obs;
  Rx<File?> selectedAvatarFile = Rxn<File>();
}
