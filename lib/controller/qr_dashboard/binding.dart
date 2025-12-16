import 'package:eventjar/controller/my_qr/controller.dart';
import 'package:eventjar/controller/qr_add_contact/controller.dart';
import 'package:eventjar/controller/qr_dashboard/controller.dart';
import 'package:eventjar/controller/qr_scan/controller.dart';
import 'package:get/get.dart';

class QrDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrDashboardController>(() => QrDashboardController());
    Get.lazyPut<MyQrScreenController>(() => MyQrScreenController());
    Get.lazyPut<QrScanScreenController>(() => QrScanScreenController());
    Get.lazyPut<QrAddContactController>(() => QrAddContactController());
  }
}
