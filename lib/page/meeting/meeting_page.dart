import 'package:eventjar/controller/meeting/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/meeting/widget/meeting_build_tabs.dart';
import 'package:eventjar/page/meeting/widget/meeting_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingPage extends GetView<MeetingController> {
  const MeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          controller.appBarTitle,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.appBarGradient),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => controller.navigateToSchedulePage(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
