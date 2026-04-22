import 'package:eventjar/controller/qr_scan/controller.dart';
import 'package:eventjar/page/scan_qr/scan_qr_bottom_section.dart';
import 'package:eventjar/page/scan_qr/scan_qr_camera_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class ScanQrPage extends GetView<QrScanScreenController> {
  const ScanQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: () => controller.markTourSeen(),
      blurValue: 1,
      builder: (ctx) => _ScanQrTourAutoStart(
        key: controller.scanQrTourScopeKey,
        start: () => controller.maybeStartTour(ctx),
        child: _buildContent(ctx),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
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

class _ScanQrTourAutoStart extends StatefulWidget {
  final Widget child;
  final Future<void> Function() start;

  const _ScanQrTourAutoStart({
    super.key,
    required this.child,
    required this.start,
  });

  @override
  State<_ScanQrTourAutoStart> createState() => _ScanQrTourAutoStartState();
}

class _ScanQrTourAutoStartState extends State<_ScanQrTourAutoStart> {
  bool _triggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_triggered) return;
    _triggered = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.start());
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
