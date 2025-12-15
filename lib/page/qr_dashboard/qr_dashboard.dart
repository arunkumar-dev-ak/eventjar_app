import 'package:eventjar/controller/qr_dashboard/controller.dart';
import 'package:eventjar/page/my_qr/my_qr_page.dart';
import 'package:eventjar/page/qr_dashboard/widget/navigation_bar.dart';
import 'package:eventjar/page/scan_qr/scan_qr_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrCodePage extends GetView<QrDashboardController> {
  const QrCodePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.blueGrey),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: IndexedStack(
            index: controller.state.selectedIndex.value,
            children: const [MyQrCodePage(), ScanQrPage(), Text("Add contact")],
          ),
        ),
      ),
      bottomNavigationBar: QrDashboardBottomNavigation(),
    );
  }
}
