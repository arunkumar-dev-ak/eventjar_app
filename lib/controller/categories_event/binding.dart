import 'package:get/get.dart';

import 'controller.dart';

class CategoriesEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoriesEventController>(() => CategoriesEventController());
  }
}
