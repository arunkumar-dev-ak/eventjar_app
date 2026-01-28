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

import '../../routes/route_name.dart';

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

  Future<void> onTabOpen() async {
    await checkCameraStatus();

    if (scannerController == null) {
      scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        autoStart: false,
      );
      state.isScannerReady.value = true;
      // Wait for next frame to ensure widget is mounted
      await Future.delayed(const Duration(milliseconds: 300));
    }

    await startCamera();
  }

  Future<void> startCamera() async {
    if (state.isCameraActive.value || scannerController == null) return;
    try {
      await scannerController!.start();
      state.isCameraActive.value = true;
      state.isScanning.value = true;
      state.hasNavigated.value = false;
    } catch (e) {
      LoggerService.loggerInstance.dynamic_d('Error starting camera: $e');
    }
  }

  Future<void> stopCamera() async {
    if (!state.isCameraActive.value || scannerController == null) return;
    try {
      await scannerController!.stop();
      state.isCameraActive.value = false;
      state.isScanning.value = false;
    } catch (e) {
      LoggerService.loggerInstance.dynamic_d('Error stopping camera: $e');
    }
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
      LoggerService.loggerInstance.dynamic_d(contact.toJson());

      // Stop camera before navigating
      stopCamera();

      // Delay 1 second before navigating to add contact page
      Future.delayed(const Duration(seconds: 1), () {
        // Navigate and restart camera when returning
        Get.toNamed(RouteName.addContactPage, arguments: contact)?.then((_) {
          // Restart camera when user comes back
          _restartCameraAfterNavigation();
        });
      });
    } else {
      // Show error for invalid QR code
      // _showError('Invalid QR code. This QR code is not from Eventjar.');
      // Reset scanning state for invalid QR
      state.isScanning.value = true;
      state.hasNavigated.value = false;
    }
  }

  void _restartCameraAfterNavigation() {
    // Reset states and restart camera
    state.isScanning.value = true;
    state.hasNavigated.value = false;

    // Check if still on scan tab before restarting
    if (qrDashboard.state.selectedIndex.value == 1) {
      startCamera();
    }
  }

  // Handle barcode detection
  void onDetect(BarcodeCapture capture) {
    LoggerService.loggerInstance.dynamic_d(
      "in on detect - isCameraActive: ${state.isCameraActive.value}, isScanning: ${state.isScanning.value}, hasNavigated: ${state.hasNavigated.value}",
    );

    // Only process if camera is active and scanning is enabled
    if (!state.isCameraActive.value ||
        !state.isScanning.value ||
        state.hasNavigated.value)
      return;

    final List<Barcode> barcodes = capture.barcodes;
    LoggerService.loggerInstance.dynamic_d(
      "Barcodes found: ${barcodes.length}",
    );

    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      LoggerService.loggerInstance.dynamic_d("Barcode value: $rawValue");
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
    scannerController = null;
    state.isScannerReady.value = false;
    state.isCameraActive.value = false;
    super.onClose();
  }
}
