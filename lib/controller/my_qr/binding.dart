import 'package:eventjar/controller/my_qr/controller.dart';
import 'package:get/get.dart';

class MyQrScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyQrScreenController>(() => MyQrScreenController());
  }
}
