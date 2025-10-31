import 'package:eventjar_app/api/event_info_api/event_info_api.dart';
import 'package:eventjar_app/controller/event_info/state.dart';
import 'package:eventjar_app/global/app_snackbar.dart';
import 'package:eventjar_app/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventInfoController extends GetxController
    with GetTickerProviderStateMixin {
  var appBarTitle = "EventJar";
  final state = EventInfoState();
  late final TabController tabController;
  late final String eventId;

  final imageUrl =
      "https://thumbs.dreamstime.com/b/abstract-illuminated-light-stage-colourful-background-bokeh-143498898.jpg";

  @override
  void onInit() async {
    tabController = TabController(length: 6, vsync: this);
    eventId = Get.parameters['eventId'] ?? '';
    await fetchEventInfo();
    super.onInit();
  }

  Future<void> fetchEventInfo() async {
    try {
      state.isLoading.value = true;
      final response = await EventInfoApi.getEventInfo(eventId);
      state.eventInfo.value = response;
    } catch (e) {
      LoggerService.loggerInstance.e('Failed to load event info: $e');
      AppSnackbar.error(title: "error", message: e.toString());
    } finally {
      state.isLoading.value = false;
    }
  }

  String generateDateTimeAndFormatTime(
    String timeString,
    BuildContext context,
  ) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final dateTime = DateTime(0, 1, 1, hour, minute);

    final localTime = formatTimeToLocale(dateTime, context);

    return localTime;
  }

  String formatTimeToLocale(DateTime time, BuildContext context) {
    final timeFormat12 = DateFormat('hh:mm a');
    final timeFormat24 = DateFormat('HH:mm');

    final userPrefers24Hour = MediaQuery.of(context).alwaysUse24HourFormat;

    final formattedTime = userPrefers24Hour
        ? timeFormat24.format(time)
        : timeFormat12.format(time);

    return formattedTime;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
