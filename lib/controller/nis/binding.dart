import 'package:get/get.dart';

import 'controller.dart';

class NisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NisController>(() => NisController());
  }
}
