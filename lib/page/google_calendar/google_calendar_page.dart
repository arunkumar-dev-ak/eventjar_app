import 'package:eventjar/controller/google_calendar/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/google_calendar/disconnect_calendar_page.dart';
import 'package:eventjar/page/google_calendar/loading_google_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GoogleCalendarPage extends GetView<GoogleCalendarController> {
  const GoogleCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),

      appBar: AppBar(
        title: Text(
          "Google Calendar",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
        elevation: 0,
      ),

      body: Obx(() {
        if (controller.state.isLoading.value) {
          return GoogleCalendarLoadingView();
        }

        return DisconnectCalendarPage();
      }),
    );
  }
}
