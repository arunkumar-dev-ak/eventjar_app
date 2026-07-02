import 'package:eventjar/controller/sent_received_contact_list/controller.dart';
import 'package:get/get.dart';

class SentReceivedContactListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SentReceivedContactListController>(
      () => SentReceivedContactListController(),
    );
  }
}
