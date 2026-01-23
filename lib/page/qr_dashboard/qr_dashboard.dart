import 'package:eventjar/controller/qr_dashboard/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/my_qr/my_qr_page.dart';
import 'package:eventjar/page/qr_add_contact/qr_add_contact_page.dart';
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
        title: Text("Share or Scan QR", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            onPressed: () {
              controller.navigateToAddContact();
            },
            icon: Icon(Icons.person_add, color: Colors.black),
          ),
          SizedBox(width: 2.wp),
        ],
      ),
      backgroundColor: Colors.grey[50],
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
