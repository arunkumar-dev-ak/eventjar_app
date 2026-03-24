import 'package:eventjar/controller/profile_form/business_info/controller.dart';
import 'package:get/get.dart';

class BusinessInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessInfoFormController>(() => BusinessInfoFormController());
  }
}
