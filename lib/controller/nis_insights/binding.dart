import 'package:get/get.dart';

import 'controller.dart';

class NisInsightsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NisInsightsController>(() => NisInsightsController());
  }
}
