import 'package:eventjar/controller/meeting_preferences/controller.dart';
import 'package:get/get.dart';

class MeetingPreferencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeetingPreferencesController>(
      () => MeetingPreferencesController(),
    );
  }
}
