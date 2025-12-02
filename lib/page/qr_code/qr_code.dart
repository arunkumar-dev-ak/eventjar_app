import 'package:eventjar/controller/qr_code/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/qr_code/tabs/add_contact/qr_add_contact_page.dart';
import 'package:eventjar/page/qr_code/tabs/my_qr/my_qr_page.dart';
import 'package:eventjar/page/qr_code/tabs/qr_scanner/qr_scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrCodePage extends GetView<QrCodeScreenController> {
  const QrCodePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Qrcode",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appBarGradient),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        switch (controller.selectedTab.value) {
          case 0:
            return QrScannerView();
          case 1:
            return MyQrView(); // displays user's QR
          case 2:
            return AddContactView(); // triggers add contact
          default:
            return Container();
        }
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.selectedTab.value,
        onTap: controller.onTabSelected,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "Scanner",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "My QR"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: "Add Contact",
          ),
        ],
      ),
    );
  }
}
