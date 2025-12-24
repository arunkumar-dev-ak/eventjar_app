import 'package:eventjar/controller/profile_form/basic_info/controller.dart';
import 'package:get/get.dart';

class BasicInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BasicInfoFormController>(() => BasicInfoFormController());
  }
}
