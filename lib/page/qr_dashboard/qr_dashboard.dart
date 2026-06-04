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

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  final QrDashboardController controller = Get.find();
  late final MyQrScreenController myQrController;
  late final ShowcaseView _showcaseView;
  OverlayEntry? _skipOverlay;
  late final Worker _tourWatcher;
  bool _tourTriggered = false;

  @override
  void initState() {
    super.initState();
    myQrController = Get.find<MyQrScreenController>();
    _showcaseView = ShowcaseView.register(
      scope: MyQrScreenController.myQrScope,
      onFinish: () {
        myQrController.isTourActive.value = false;
        myQrController.markTourSeen();
      },
      blurValue: 1,
    );
    _tourWatcher = ever(myQrController.isTourActive, (active) {
      if (active) {
        _showSkipOverlay();
      } else {
        _removeSkipOverlay();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_tourTriggered) return;
    _tourTriggered = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      myQrController.maybeStartTour(context);
    });
  }

  void _showSkipOverlay() {
    _removeSkipOverlay();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !myQrController.isTourActive.value) return;
        _skipOverlay = OverlayEntry(
          builder: (ctx) {
            final bottomPadding = MediaQuery.of(ctx).padding.bottom;
            return Positioned(
              bottom: bottomPadding + 16,
              right: 16,
              child: GestureDetector(
                onTap: () => myQrController.skipTour(),
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
              return Showcase(
                scope: MyQrScreenController.myQrScope,
                key: myQrController.tourHelpKey,
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
                  onPressed: myQrController.replayTour,
                ),
              );
            }
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
