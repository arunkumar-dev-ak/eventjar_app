import 'package:get/get.dart';

class QrScanScreenState {
  RxBool isLoading = false.obs;

  final RxBool isScanning = true.obs;
  final RxBool hasNavigated = false.obs;
}
