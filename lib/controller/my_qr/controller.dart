import 'package:eventjar/controller/my_qr/state.dart';
import 'package:get/get.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

class MyQrScreenController extends GetxController
    with GetTickerProviderStateMixin {
  var appBarTitle = "Network";
  final state = MyQrScreenState();

  @override
  void onInit() {
    super.onInit();
  }

  final selectedTab = 0.obs;

  void onTabSelected(int index) {
    selectedTab.value = index;
  }

  // final MobileScannerController cameraController = MobileScannerController(
  //   detectionSpeed: DetectionSpeed.noDuplicates,
  // );

  // switch front/back camera
  void toggleCamera() {
    // cameraController.switchCamera();
  }

  // optional: toggle torch if you want
  void toggleTorch() {
    // cameraController.toggleTorch();
  }

  // TODO: implement gallery scanning
  Future<void> scanFromGallery() async {
    // With mobile_scanner 7.x, you typically load an image and use a decoder.
    // For now, just stub:
    // pick image with image_picker, then decode using a QR library.
  }

  @override
  void onClose() {
    // cameraController.dispose();
    super.onClose();
  }
}
