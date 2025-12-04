import 'package:eventjar/controller/qualify_lead/controller.dart';
import 'package:get/get.dart';

class QualifyLeadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QualifyLeadController>(() => QualifyLeadController());
  }
}
