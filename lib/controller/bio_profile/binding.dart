import 'package:get/get.dart';

import 'controller.dart';

class BioProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BioProfileController>(() => BioProfileController());
  }
}
