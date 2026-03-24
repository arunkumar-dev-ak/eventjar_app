import 'package:eventjar/controller/nfc_read/controller.dart';
import 'package:get/get.dart';

class NfcReadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NfcReadController());
  }
}
