import 'package:eventjar/controller/nfc_write/controller.dart';
import 'package:get/get.dart';

class NfcWriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NfcWriteController());
  }
}
