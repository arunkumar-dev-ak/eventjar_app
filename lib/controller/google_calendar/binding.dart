import 'package:eventjar/controller/google_calendar/controller.dart';
import 'package:get/get.dart';

class GoogleCalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoogleCalendarController>(() => GoogleCalendarController());
  }
}
