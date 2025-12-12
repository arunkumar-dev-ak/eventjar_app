import 'package:eventjar/controller/qr_dashboard/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/page/my_qr/my_qr_page.dart';
import 'package:eventjar/page/qr_dashboard/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrCodePage extends GetView<QrDashboardController> {
  const QrCodePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientLightStart, AppColors.gradientLightEnd],
          ),
        ),
        child: SafeArea(
          child: IndexedStack(
            index: controller.state.selectedIndex.value,
            children: const [
              MyQrCodePage(),
              Text("Qr Scan"),
              Text("Add contact"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: QrDashboardBottomNavigation(),
    );
  }
}
