import 'dart:io';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ImageViewerState {
  RxBool isLoading = false.obs;
  RxString header = "".obs;
  Rxn<String> imageUrl = Rxn();
  Rx<File?> selectedImage = Rx<File?>(null);
}
