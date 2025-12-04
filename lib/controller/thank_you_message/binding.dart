import 'package:eventjar/controller/thank_you_message/controller.dart';
import 'package:get/get.dart';

class ThankYouMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThankYouMessageController>(() => ThankYouMessageController());
  }
}
