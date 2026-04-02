import 'package:eventjar/controller/notification/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/notification/widget/email/email_notification.dart';
import 'package:eventjar/page/notification/widget/notification_build_tabs.dart';
import 'package:eventjar/page/notification/widget/whatspp/whatsapp_notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appBarGradient),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          NotificationBuildTabs(),
          Obx(() {
            return Expanded(
              child: controller.state.selectedTab.value == 0
                  ? EmailNotificationTab()
                  : GestureDetector(
                      onTap: () {
                        Get.focusScope?.unfocus();
                      },
                      child: WhatsAppNotificationTab(),
                    ),
            );
          }),
        ],
      ),
    );
  }
}
