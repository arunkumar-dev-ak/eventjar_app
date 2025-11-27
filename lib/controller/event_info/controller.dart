import 'package:carousel_slider/carousel_controller.dart';
import 'package:dio/dio.dart';
import 'package:eventjar/api/event_info_api/event_info_api.dart';
import 'package:eventjar/api/event_info_api/event_info_attendee_list_api.dart';
import 'package:eventjar/api/event_info_api/event_info_attendee_req_api.dart';
import 'package:eventjar/controller/event_info/state.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/event_info/event_attendee_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventInfoController extends GetxController
    with GetTickerProviderStateMixin {
  var appBarTitle = "EventJar";
  final state = EventInfoState();
  late final TabController tabController;
  late final String eventId;

  final TextEditingController searchController = TextEditingController();
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();

  final imageUrl =
      "https://thumbs.dreamstime.com/b/abstract-illuminated-light-stage-colourful-background-bokeh-143498898.jpg";

  @override
  void onInit() async {
    tabController = TabController(length: 6, vsync: this);

    tabController.addListener(() async {
      if (tabController.indexIsChanging) return;

      if (tabController.index == 5) {
        if (!UserStore.to.isLogin) {
          navigateToSignInPage();
        }

        await fetchAllAttendeeData();
      }
    });

    eventId = Get.parameters['eventId'] ?? '';
    await fetchEventInfo();
    super.onInit();
  }

  Future<void> fetchAllAttendeeData() async {
    await Future.wait([
      fetchEventAttendeeList(eventId),
      fetchEventAttendeeRequestList(eventId),
    ]);
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

  Future<void> fetchEventAttendeeList(String eventId) async {
    try {
      state.attendeeListLoading.value = true;
      final response = await EventInfoApiAttendeeList.getEventAttendeeList(
        eventId,
      );
      // LoggerService.loggerInstance.dynamic_d("attendee list is $response");
      state.attendeeList.value = response;
    } catch (err) {
      LoggerService.loggerInstance.dynamic_d(err);
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          // Auth error handling example
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }

        ApiErrorHandler.handleError(err, "Failed to load attendee list");
      } else {
        AppSnackbar.error(
          title: "Failed",
          message:
              "Something went wrong. Please try again. in fetchEventAttendeeList",
        );
      }
    } finally {
      state.attendeeListLoading.value = false;
    }
  }

  Future<void> fetchEventAttendeeRequestList(String eventId) async {
    try {
      state.attendeeRequestLoading.value = true;
      final response =
          await EventInfoApiAttendeeRequestList.getAttendeeRequestList(eventId);
      state.attendeeRequests.value = response;
    } catch (err) {
      LoggerService.loggerInstance.dynamic_d(err);
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          return;
        }

        ApiErrorHandler.handleError(
          err,
          "Failed to load attendee meeting requests",
        );
      } else {
        AppSnackbar.error(
          title: "Failed",
          message:
              "Something went wrong. Please try again in fetchEventAttendeeReqList",
        );
      }
    } finally {
      state.attendeeRequestLoading.value = false;
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

  void navigateToCheckOut() {
    Get.toNamed(RouteName.checkoutPage, arguments: state.eventInfo);
  }

  void selectRequestTab(int index) {
    state.selectedAttendeeTab.value = index;
  }

  void respondToMeetingRequest(
    String requestId,
    String status,
    String buttonId,
  ) async {
    if (state.isProcessingRequest.value) {
      AppSnackbar.warning(
        title: "Please wait a moment",
        message: "Handling your previous request",
      );
      return;
    }
    try {
      state.buttonLoadingStates[buttonId] = true;
      state.isProcessingRequest.value = true;

      await EventInfoApiAttendeeRequestList.respondToRequestMessage(
        eventId,
        requestId,
        status,
      );

      await fetchAllAttendeeData();
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }
        ApiErrorHandler.handleError(err, "Failed to Update Status");
      } else {
        AppSnackbar.error(
          title: "Failed",
          message: "Something went wrong. Please try again.",
        );
      }
    } finally {
      state.buttonLoadingStates[buttonId] = false;
      state.isProcessingRequest.value = false;
    }
  }

  void sendMeetingRequest(String toUserId, String attendeeName) async {
    final buttonId = toUserId;
    LoggerService.loggerInstance.dynamic_d('buttonId $buttonId');
    if (state.isMeetReqProcessingRequest.value) {
      AppSnackbar.warning(
        title: "Please wait a moment",
        message: "Handling your previous request",
      );
      return;
    }
    try {
      state.meetReqButtonLoadingStates[buttonId] = true;
      state.isMeetReqProcessingRequest.value = true;

      final payload = {
        'to_user_id': toUserId,
        'message':
            'Hi $attendeeName, I\'d like to ${state.eventInfo.value?.isOneMeetingEnabled == true ? "schedule a one-on-one meeting" : "connect"} with you.',
        'collaboration_note': "",
        'preferred_time': "",
        'duration': state.eventInfo.value?.isOneMeetingEnabled == true
            ? 30
            : 15,
      };

      await EventInfoApiAttendeeList.sendMeetRequest(payload, eventId);

      await fetchAllAttendeeData();
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return;
        }
        ApiErrorHandler.handleError(err, "Failed to Update Status");
      } else {
        AppSnackbar.error(
          title: "Failed",
          message: "Something went wrong. Please try again.",
        );
      }
    } finally {
      state.meetReqButtonLoadingStates[buttonId] = false;
      state.isMeetReqProcessingRequest.value = false;
    }
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage)?.then((result) async {
      if (result == "logged_in") {
        await fetchAllAttendeeData();
      } else {
        tabController.index = 0;
      }
    });
  }

  void handleAttendeeButtonAction(String attendeeId, String buttonText) async {
    LoggerService.loggerInstance.dynamic_d(attendeeId + buttonText);
    if (buttonText == 'Add to Contacts') {
      // Add to contacts logic
    } else {
      // await respondToMeetingRequest(
      //   attendeeId,
      //   'pending',
      //   "attendee_request_$attendeeId",
      // );
    }
  }

  // In EventInfoController
  Map<String, dynamic> getDynamicButtonState(EventAttendee attendee) {
    final requestState = state.attendeeRequests.value;
    if (requestState == null) {
      return {
        'text': 'Send Meeting Request',
        'disabled': false,
        'color': 'blue',
        'loading': false,
      };
    }

    // Check if there's an existing request involving this attendee
    final existingRequest = [...requestState.sent, ...requestState.received]
        .firstWhereOrNull(
          (req) =>
              req.fromUser.id == attendee.id || req.toUser.id == attendee.id,
        );

    if (existingRequest != null) {
      final isOutgoing =
          existingRequest.fromUser.id == UserStore.to.profile['id'];

      switch (existingRequest.status.toLowerCase()) {
        case 'pending':
          return {
            'text': isOutgoing ? 'Request Sent' : 'Request received',
            'disabled': isOutgoing,
            'color': isOutgoing ? 'yellow' : 'blue',
            'loading': false,
          };
        case 'accepted':
          return {
            'text': 'Added to Contacts',
            'disabled': false,
            'color': 'green',
            'loading': false,
          };
        case 'declined':
          return {
            'text': 'Request Declined',
            'disabled': true,
            'color': 'orange',
            'loading': false,
          };
        default:
          return {
            'text': 'Request History Exists',
            'disabled': true,
            'color': 'grey',
            'loading': false,
          };
      }
    }

    // Default: Send new request
    return {
      'text': state.eventInfo.value?.isOneMeetingEnabled == true
          ? 'Send Meeting Request'
          : 'Send Request',
      'disabled': false,
      'color': 'blue',
      'loading': false,
    };
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
