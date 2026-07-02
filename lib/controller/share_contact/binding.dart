import 'package:eventjar/controller/share_contact/controller.dart';
import 'package:get/get.dart';

class ShareContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareContactController>(() => ShareContactController());
  }
}
