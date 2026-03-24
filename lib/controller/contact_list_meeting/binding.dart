import 'package:eventjar/controller/contact_list_meeting/controller.dart';
import 'package:get/get.dart';

class ContactListMeetingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactListMeetingController>(
      () => ContactListMeetingController(),
    );
  }
}
