import 'package:eventjar/controller/image_viewer/controller.dart';
import 'package:get/get.dart';

class ImageViewerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageViewerController>(() => ImageViewerController());
  }
}
