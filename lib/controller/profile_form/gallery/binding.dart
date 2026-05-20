import 'package:eventjar/controller/profile_form/gallery/controller.dart';
import 'package:get/get.dart';

class GalleryFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GalleryFormController>(() => GalleryFormController());
  }
}
