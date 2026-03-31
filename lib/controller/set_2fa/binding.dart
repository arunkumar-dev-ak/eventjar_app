import 'package:eventjar/controller/set_2fa/controller.dart';
import 'package:get/get.dart';

class Set2faBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Set2faController>(() => Set2faController());
  }
}
