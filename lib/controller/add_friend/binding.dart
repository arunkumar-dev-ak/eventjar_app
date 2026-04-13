import 'package:eventjar/controller/add_friend/controller.dart';
import 'package:get/get.dart';

class AddFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddFriendController>(() => AddFriendController());
  }
}
