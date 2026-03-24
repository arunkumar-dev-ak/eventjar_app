import 'package:eventjar/controller/contact_analytics/controller.dart';
import 'package:get/get.dart';

class ContactAnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactAnalyticsController>(() => ContactAnalyticsController());
  }
}
