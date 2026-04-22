import 'package:eventjar/controller/my_qr/controller.dart';
import 'package:eventjar/controller/qr_dashboard/controller.dart';
import 'package:eventjar/controller/qr_scan/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/my_qr/my_qr_page.dart';
import 'package:eventjar/page/qr_dashboard/widget/navigation_bar.dart';
import 'package:eventjar/page/scan_qr/scan_qr_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class QrCodePage extends GetView<QrDashboardController> {
  const QrCodePage({super.key});
  @override
  Widget build(BuildContext context) {
    final myQrController = Get.find<MyQrScreenController>();
    return ShowCaseWidget(
      onFinish: () => myQrController.markTourSeen(),
      blurValue: 1,
      builder: (ctx) => _MyQrTourScope(
        key: myQrController.myQrTourScopeKey,
        start: () => myQrController.maybeStartTour(ctx),
        child: _buildScaffold(ctx, myQrController),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, MyQrScreenController myQr) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.blueGrey),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        title: Text(
          "Share or Scan QR",
          style: TextStyle(color: AppColors.textPrimary(context)),
        ),
        actions: [
          Obx(() {
            final index = controller.state.selectedIndex.value;
            if (index == 0) {
              // My QR tab — this button IS a Showcase target (tourHelpKey) and
              // calls the MyQR tour.
              return Showcase(
                key: myQr.tourHelpKey,
                title: 'Replay',
                description: 'Tap anytime to see the tour again.',
                targetShapeBorder: const CircleBorder(),
                tooltipBackgroundColor: AppColors.gradientLightStart,
                textColor: Colors.white,
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                descTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.help_outline_rounded,
                    color: Colors.blueGrey,
                  ),
                  tooltip: 'Replay tour',
                  onPressed: myQr.replayTour,
                ),
              );
            }
            // Scan QR tab — plain replay button; the scan tour lives in the
            // ScanQrPage's own ShowCaseWidget subtree, reached via scope key.
            return IconButton(
              icon: const Icon(
                Icons.help_outline_rounded,
                color: Colors.blueGrey,
              ),
              tooltip: 'Replay tour',
              onPressed: () {
                Get.find<QrScanScreenController>().replayTour();
              },
            );
          }),
          SizedBox(width: 2.wp),
        ],
      ),
      backgroundColor: AppColors.scaffoldBg(context),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Obx(() {
            final index = controller.state.selectedIndex.value.clamp(0, 1);
            return IndexedStack(
              index: index,
              children: const [MyQrCodePage(), ScanQrPage()],
            );
          }),
        ),
      ),
      bottomNavigationBar: QrDashboardBottomNavigation(),
    );
  }
}

/// Lives inside the ShowCaseWidget subtree so its `context` is a valid
/// descendant — exposed via a GlobalKey so the AppBar / controller can
/// invoke `replayTour()` from anywhere. Also kicks off the tour once on
/// first open.
class _MyQrTourScope extends StatefulWidget {
  final Widget child;
  final Future<void> Function() start;

  const _MyQrTourScope({super.key, required this.child, required this.start});

  @override
  State<_MyQrTourScope> createState() => _MyQrTourScopeState();
}

class _MyQrTourScopeState extends State<_MyQrTourScope> {
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
