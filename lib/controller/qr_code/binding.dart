import 'package:eventjar/controller/qr_code/controller.dart';
import 'package:get/get.dart';

class QrCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrCodeScreenController>(() => QrCodeScreenController());
  }
}
