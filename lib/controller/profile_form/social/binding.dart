import 'package:eventjar/controller/profile_form/social/controller.dart';
import 'package:get/get.dart';

class SocialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SocialFormController>(() => SocialFormController());
  }
}
