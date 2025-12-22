import 'package:eventjar/controller/nfc/controller.dart';
import 'package:get/get.dart';

class NfcBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NfcController());
  }
}
