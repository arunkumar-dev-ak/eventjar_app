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
      onFinish: () {
        myQrController.isTourActive.value = false;
        myQrController.markTourSeen();
      },
      blurValue: 1,
      builder: (ctx) => _MyQrTourScope(
        key: myQrController.myQrTourScopeKey,
        showcaseContext: ctx,
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
  final BuildContext showcaseContext;
  final Future<void> Function() start;

  const _MyQrTourScope({
    super.key,
    required this.child,
    required this.showcaseContext,
    required this.start,
  });

  @override
  State<_MyQrTourScope> createState() => _MyQrTourScopeState();
}

class _MyQrTourScopeState extends State<_MyQrTourScope> {
  final MyQrScreenController _controller = Get.find();
  bool _triggered = false;
  OverlayEntry? _skipOverlay;
  late final Worker _tourWatcher;

  @override
  void initState() {
    super.initState();
    _tourWatcher = ever(_controller.isTourActive, (active) {
      if (active) {
        _showSkipOverlay();
      } else {
        _removeSkipOverlay();
      }
    });
  }

  void _showSkipOverlay() {
    _removeSkipOverlay();
    // Wait two frames: showcaseview inserts its overlay in addPostFrameCallback,
    // so we need to be after that to guarantee our entry is on top.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_controller.isTourActive.value) return;
        _skipOverlay = OverlayEntry(
          builder: (ctx) {
            final bottomPadding = MediaQuery.of(ctx).padding.bottom;
            return Positioned(
              bottom: bottomPadding + 16,
              right: 16,
              child: GestureDetector(
                onTap: () => _controller.skipTour(widget.showcaseContext),
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_triggered) return;
    _triggered = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.start());
  }

  @override
  void dispose() {
    _tourWatcher.dispose();
    _removeSkipOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
