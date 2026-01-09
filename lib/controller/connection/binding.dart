import 'package:eventjar/controller/connection/controller.dart';
import 'package:get/get.dart';

class ConnectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConnectionController>(() => ConnectionController());
  }
}
