import 'package:get/get.dart';

import 'controller.dart';

class ScanCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanCardController>(() => ScanCardController());
  }
}
