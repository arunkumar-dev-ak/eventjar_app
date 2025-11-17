import 'package:eventjar/controller/network/controller.dart';
import 'package:get/get.dart';

class NetworkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NetworkScreenController>(() => NetworkScreenController());
  }
}
