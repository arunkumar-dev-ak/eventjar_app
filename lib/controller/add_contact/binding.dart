import 'package:eventjar/controller/add_contact/controller.dart';
import 'package:get/get.dart';

class AddContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddContactController>(() => AddContactController());
  }
}
