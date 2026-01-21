import 'package:eventjar/controller/qr_add_contact/controller.dart';
import 'package:eventjar/controller/qr_dashboard/controller.dart';
import 'package:eventjar/controller/qr_scan/state.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/qr_contact_model.dart';
import 'package:eventjar/services/encryption_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QrScanScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var appBarTitle = "Network";
  final state = QrScanScreenState();
  final ImagePicker _imagePicker = ImagePicker();
  MobileScannerController? scannerController;

  final QrDashboardController qrDashboard = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  void onTabOpen() async {
    scannerController ??= MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );

    checkCameraStatus();
  }

  Future<void> checkCameraStatus() async {
    if (state.isRequesting.value) return;
    try {
      state.isRequesting.value = true;
      final status = await Permission.camera.status;

      if (status.isGranted) {
        state.isCameraAccessGranted.value = true;
      } else {
        state.isCameraAccessGranted.value = false;
      }
    } catch (err) {
      LoggerService.loggerInstance.dynamic_d('error: $err');
    } finally {
      state.isRequesting.value = false;
    }
  }

  Future<void> requestCameraPermission() async {
    if (state.isRequesting.value) return;
    try {
      state.isRequesting.value = true;
      final status = await Permission.camera.status;

      if (status.isGranted) {
        state.isCameraAccessGranted.value = true;
        return;
      }

      await openAppSettings();
    } catch (e) {
      LoggerService.loggerInstance.dynamic_d('error: $e');
    } finally {
      state.isRequesting.value = false;
    }
  }

  void processScannedData(String rawData) {
    LoggerService.loggerInstance.dynamic_d("in processscanner data");
    if (!state.isScanning.value || state.hasNavigated.value) return;

    state.isScanning.value = false;
    state.hasNavigated.value = true;

    LoggerService.loggerInstance.dynamic_d("Before encryption");
    // Try to decrypt the QR data
    final jsonData = EncryptionService.decryptJson(rawData);

    if (jsonData != null) {
      final contact = QrContactModel.fromJson(jsonData);
      LoggerService.loggerInstance.dynamic_d(contact);

      scannerController?.stop();

      // Update contact controller with scanned data
      final contactController = Get.find<QrAddContactController>();
      contactController.handleArgs(contact);

      qrDashboard.state.selectedIndex.value = 2;

      // Navigate to Add Contact tab
      // final tabsController = Get.find<QRTabsController>();
      // tabsController.goToAddContact();
    } else {
      // Show error for invalid QR code
      // _showError('Invalid QR code. This QR code is not from Eventjar.');
    }

    // Reset scanning state
    Future.delayed(const Duration(milliseconds: 500), () {
      state.isScanning.value = true;
      state.hasNavigated.value = false;
    });
  }

  // Handle barcode detection
  void onDetect(BarcodeCapture capture) {
    LoggerService.loggerInstance.dynamic_d("in on detect");
    if (!state.isScanning.value || state.hasNavigated.value) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue != null && rawValue.isNotEmpty) {
        processScannedData(rawValue);
        break;
      }
    }
  }

  // Scan QR from gallery image
  Future<void> scanFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image == null) return;

      // Use mobile_scanner to analyze the image
      final BarcodeCapture? result = await scannerController?.analyzeImage(
        image.path,
      );

      if (result != null && result.barcodes.isNotEmpty) {
        final String? rawValue = result.barcodes.first.rawValue;
        if (rawValue != null && rawValue.isNotEmpty) {
          processScannedData(rawValue);
        } else {
          _showError('No QR code found in the image');
        }
      } else {
        _showError('No QR code found in the image');
      }
    } catch (e) {
      _showError('Failed to scan image: $e');
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    scannerController?.dispose();
    super.onClose();
  }
}
