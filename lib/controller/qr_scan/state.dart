import 'package:get/get.dart';

class QrScanScreenState {
  RxBool isLoading = false.obs;

  final RxBool isScanning = true.obs;
  final RxBool hasNavigated = false.obs;
  final RxBool isCameraActive = false.obs;
  final RxBool isScannerReady = false.obs;

  final RxBool isCameraAccessGranted = false.obs;
  final RxBool isRequesting = false.obs;
  RxDouble enableButtonScale = 1.0.obs;
}
