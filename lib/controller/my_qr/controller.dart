import 'dart:io';

import 'package:eventjar/controller/my_qr/state.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:eventjar/services/encryption_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';

import 'package:path_provider/path_provider.dart';

class MyQrScreenController extends GetxController
    with GetTickerProviderStateMixin {
  var appBarTitle = "My QR";
  late AnimationController pulseController;
  late AnimationController rotateController;
  late Animation<double> pulseAnimation;

  final GlobalKey qrKey = GlobalKey();
  final state = MyQrScreenState();
  final selectedTab = 0.obs;

  @override
  void onInit() {
    _initAnimations();
    onTabOpen();
    super.onInit();
  }

  void onTabOpen() async {
    _feedQrData();
  }

  void _initAnimations() {
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );
  }

  void _feedQrData() {
    final profile = UserStore.to.profile;

    if (profile.isEmpty) {
      navigateToSignInPage();
    } else {
      state.myContact.value = profile;
    }
  }

  // final MobileScannerController cameraController = MobileScannerController(
  //   detectionSpeed: DetectionSpeed.noDuplicates,
  // );

  // switch front/back camera
  // void toggleCamera() {
  //   cameraController.switchCamera();
  // }

  // optional: toggle torch if you want
  // void toggleTorch() {
  //   cameraController.toggleTorch();
  // }

  // TODO: implement gallery scanning
  Future<void> scanFromGallery() async {
    // With mobile_scanner 7.x, you typically load an image and use a decoder.
    // For now, just stub:
    // pick image with image_picker, then decode using a QR library.
  }

  Future<void> shareQRCode() async {
    if (state.isSharing.value) return;

    state.isSharing.value = true;

    try {
      final boundary =
          qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        _showError('Could not capture QR code');
        return;
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        _showError('Could not generate image');
        return;
      }

      final bytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/my_qr_contact.png');
      await file.writeAsBytes(bytes);

      // final contactController = Get.find<ContactController>();
      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'Scan this QR code to save my contact - ${state.myContact['name']}',
        subject: 'Contact QR Code - ${state.myContact['name']}',
      );
    } catch (e) {
      _showError('Failed to share: $e');
    } finally {
      state.isSharing.value = false;
    }
  }

  String get qrData {
    return EncryptionService.encryptJson(state.myContact);
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) {
      if (result == "logged_in") {
        _feedQrData();
      }
    });
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
    );
  }

  @override
  void onClose() {
    pulseController.dispose();
    rotateController.dispose();
    super.onClose();
  }
}
