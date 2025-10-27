import 'package:eventjar_app/api/event_info_api/event_info_api.dart';
import 'package:eventjar_app/controller/event_info/state.dart';
import 'package:eventjar_app/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    eventId = Get.parameters['eventId'] ?? '';
    await fetchEventInfo();
    tabController = TabController(length: 6, vsync: this);
    super.onInit();
  }

  Future<void> fetchEventInfo() async {
    try {
      state.isLoading.value = true;
      final response = await EventInfoApi.getEventInfo(eventId);
      state.eventInfo.value = response.data;
      LoggerService.loggerInstance.dynamic_d(
        'EventInfo loaded for id: $eventId',
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Failed to load event info: $e');
      // Optionally handle error state here (show error message etc.)
    } finally {
      state.isLoading.value = false;
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
