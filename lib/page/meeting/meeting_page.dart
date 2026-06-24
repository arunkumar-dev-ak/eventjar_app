import 'package:eventjar/controller/meeting/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/meeting/widget/meeting_build_tabs.dart';
import 'package:eventjar/page/meeting/widget/meeting_list.dart';
import 'package:flutter/material.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:get/get.dart';

import '../../global/widget/appbar_button.dart';

class MeetingPage extends GetView<MeetingController> {
  const MeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
        elevation: 0,
        centerTitle: false,
        actions: [
          Obx(() {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // AppbarButton(
                //   icon: Icons.settings_outlined,
                //   onPressed: () =>
                //       Get.toNamed(RouteName.meetingPreferencesPage),
                // ),
                if (controller.state.selectedTab.value == 1)
                  SizedBox(width: 2.wp),
                if (controller.state.selectedTab.value == 1)
                  AppbarButton(
                    icon: Icons.add,
                    onPressed: controller.navigateToSchedulePage,
                  ),
                SizedBox(width: 3.wp),
              ],
            );
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MeetingBuildTabs(),
            SizedBox(height: 1.hp),
            Expanded(child: MeetingList()),
          ],
        ),
      ),
    );
  }
}
