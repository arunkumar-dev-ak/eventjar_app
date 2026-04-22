import 'dart:io';

import 'package:eventjar/controller/my_qr/state.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:eventjar/services/encryption_service.dart';
import 'package:eventjar/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';
import 'package:showcaseview/showcaseview.dart';

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

  // Tour / showcase
  static const String _tourSeenStorageKey = 'my_qr_tour_seen_v1';
  final GlobalKey tourQrKey = GlobalKey();
  final GlobalKey tourShareKey = GlobalKey();
  final GlobalKey tourMyQrTabKey = GlobalKey();
  final GlobalKey tourScanQrTabKey = GlobalKey();
  final GlobalKey tourHelpKey = GlobalKey();
  // Attached inside QrCodePage under the ShowCaseWidget. Used by actions
  // outside the showcase subtree (not needed currently, but kept so
  // replayTour() can also be called from anywhere).
  final GlobalKey myQrTourScopeKey = GlobalKey();

  List<GlobalKey> get _tourSequence => [
    tourQrKey,
    tourShareKey,
    tourMyQrTabKey,
    tourScanQrTabKey,
    tourHelpKey,
  ];

  Future<bool> isTourSeen() async {
    final value = await StorageService.to.getString(_tourSeenStorageKey);
    return value == '1';
  }

  Future<void> markTourSeen() async {
    await StorageService.to.setString(_tourSeenStorageKey, '1');
  }

  Future<void> maybeStartTour(BuildContext context) async {
    if (await isTourSeen()) return;
    if (!context.mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      ShowCaseWidget.of(context).startShowCase(_tourSequence);
    });
  }

  /// Re-plays the tour from any context (e.g. QrCodePage AppBar) by resolving
  /// a descendant context via [myQrTourScopeKey].
  void replayTour() {
    final ctx = myQrTourScopeKey.currentContext;
    if (ctx == null || !ctx.mounted) return;
    ShowCaseWidget.of(ctx).startShowCase(_tourSequence);
  }

  @override
  void onInit() {
    UserStore.cancelAllRequests();
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
