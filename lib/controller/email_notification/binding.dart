import 'package:eventjar/controller/email_notification/controller.dart';
import 'package:get/get.dart';

class EmailNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailNotificationController>(
      () => EmailNotificationController(),
    );
  }
}
