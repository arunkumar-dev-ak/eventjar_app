import 'package:eventjar/controller/auth_processing/controller.dart';
import 'package:get/get.dart';

class AuthProcessignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthProcessingController>(() => AuthProcessingController());
  }
}
