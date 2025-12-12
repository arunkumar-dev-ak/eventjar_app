import 'package:eventjar/controller/qr_scan/controller.dart';
import 'package:get/get.dart';

class QrScanScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrScanScreenController>(() => QrScanScreenController());
  }
}
