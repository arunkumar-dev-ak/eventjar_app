import 'package:eventjar/model/user_profile/user_profile.dart';
import 'package:get/get.dart';

class UserProfileState {
  final RxBool isLoading = false.obs;

  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
}
