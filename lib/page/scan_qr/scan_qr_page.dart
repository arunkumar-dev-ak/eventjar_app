import 'package:eventjar/controller/qr_scan/controller.dart';
import 'package:eventjar/page/scan_qr/scan_qr_bottom_section.dart';
import 'package:eventjar/page/scan_qr/scan_qr_camera_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  final QrScanScreenController controller = Get.find();
  late final ShowcaseView _showcaseView;
  OverlayEntry? _skipOverlay;
  late final Worker _tourWatcher;

  @override
  void initState() {
    super.initState();
    _showcaseView = ShowcaseView.register(
      scope: QrScanScreenController.scanQrScope,
      onFinish: () {
        controller.isTourActive.value = false;
        controller.markTourSeen();
      },
      blurValue: 1,
    );
    _tourWatcher = ever(controller.isTourActive, (active) {
      if (active) {
        _showSkipOverlay();
      } else {
        _removeSkipOverlay();
      }
    });
  }

  void _showSkipOverlay() {
    _removeSkipOverlay();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !controller.isTourActive.value) return;
        _skipOverlay = OverlayEntry(
          builder: (ctx) {
            final bottomPadding = MediaQuery.of(ctx).padding.bottom;
            return Positioned(
              bottom: bottomPadding + 16,
              right: 16,
              child: GestureDetector(
                onTap: () => controller.skipTour(),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Skip Tour',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
        Overlay.of(context, rootOverlay: true).insert(_skipOverlay!);
      });
    });
  }

  void _removeSkipOverlay() {
    _skipOverlay?.remove();
    _skipOverlay = null;
  }

  @override
  void dispose() {
    _tourWatcher.dispose();
    _removeSkipOverlay();
    _showcaseView.unregister();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Expanded(child: ScanQrCameraSection(size: size)),
        ScanQrBottomSection(colorScheme: colorScheme),
      ],
    );
  }
}
