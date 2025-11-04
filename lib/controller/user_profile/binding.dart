import 'package:eventjar_app/controller/user_profile/controller.dart';
import 'package:get/get.dart';

class MyTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProfileController>(() => UserProfileController());
  }
}
