import 'package:eventjar/controller/profile_form/networking/controller.dart';
import 'package:get/get.dart';

class NetworkingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NetworkingFormController>(() => NetworkingFormController());
  }
}
