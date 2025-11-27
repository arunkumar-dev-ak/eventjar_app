import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/event_info/widget/event_info_appbar.dart';
import 'package:eventjar/page/event_info/widget/event_info_content.dart';
import 'package:eventjar/page/event_info/widget/event_info_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EventInfoPage extends GetView<EventInfoController> {
  const EventInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // White icons (Android)
        statusBarBrightness: Brightness.dark, // White icons (iOS)
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: 100.wp,
          decoration: BoxDecoration(gradient: AppColors.appBarGradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventInfoAppBar(),
              EventInfoHeader(),
              EventInfoContent(),
            ],
          ),
        ),
        bottomNavigationBar: Obx(() {
          return SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 0.5.hp),
              height: 6.hp,
              child: eventInfoBookButton(
                isFree: !(controller.state.eventInfo.value?.isPaid ?? false),
                onTap: () {
                  controller.navigateToCheckOut();
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
