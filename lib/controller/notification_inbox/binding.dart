import 'package:eventjar/controller/notification_inbox/controller.dart';
import 'package:get/get.dart';

class NotificationInboxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationInboxController>(
      () => NotificationInboxController(),
    );
  }
}
