import 'package:dio/dio.dart';
import 'package:eventjar/api/checkout_api/booking_api.dart';
import 'package:eventjar/api/checkout_api/eligibility_api.dart';
import 'package:eventjar/controller/checkout/state.dart';
import 'package:eventjar/controller/dashboard/controller.dart';
import 'package:eventjar/controller/my_ticket/controller.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/helper/apierror_handler.dart';
import 'package:eventjar/helper/date_handler.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CheckoutController extends GetxController {
  var appBarTitle = "EventJar";
  final state = CheckoutState();

  final MyTicketController ticketController = Get.find();
  final DashboardController dashboardController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _fetchEventInfo();
  }

  void _fetchEventInfo() {
    // Get the eventInfo passed from navigation
    final eventInfoArg = Get.arguments;

    if (eventInfoArg != null && eventInfoArg is Rxn<EventInfo>) {
      state.eventInfo.value = eventInfoArg.value;
      if (state.eventInfo.value != null) {
        state.selectedTicketTier.value =
            state.eventInfo.value!.ticketTiers.first;
        checkEligibility(state.eventInfo.value!.ticketTiers.first);
      }
    }
  }

  void incrementQuantity() {
    state.quantity.value++;
  }

  void decrementQuantity() {
    if (state.quantity.value > 1) {
      state.quantity.value--;
    }
  }

  Future<void> proceedToCheckout() async {
    if (state.selectedTicketTier.value == null) {
      AppSnackbar.error(title: "Error", message: "Please select a ticket tier");
      return;
    }

    // Check if user is eligible
    if (state.eligibilityResponse.value?.eligible == false) {
      AppSnackbar.error(
        title: "Not Eligible",
        message:
            state.eligibilityResponse.value?.reason ??
            "You already have a ticket for this tier",
      );
      return;
    }

    final eventInfo = state.eventInfo.value;
    if (eventInfo == null) return;

    try {
      state.isRegistering.value = true;

      await TicketBookingApi.registerTicket(
        eventId: eventInfo.id,
        ticketTierId: state.selectedTicketTier.value!.id,
        // quantity: state.quantity.value,
      );

      navigateToMyTicketPage();
    } catch (err) {
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return; // Stop further error handling
        }
        ApiErrorHandler.handleError(err, "Registration Failed");
      } else {
        AppSnackbar.error(
          title: "Registration Failed",
          message: "Something went wrong. Please try again.",
        );
      }
    } finally {
      state.isRegistering.value = false;
    }
  }

  void selectTicketTier(TicketTier ticket) {
    state.selectedTicketTier.value = ticket;
    // Check eligibility when ticket is selected
    checkEligibility(ticket);
  }

  Future<void> checkEligibility(TicketTier ticket) async {
    final eventInfo = state.eventInfo.value;
    if (eventInfo == null) return;

    try {
      state.isCheckingEligibility.value = true;

      final response = await CheckoutApi.checkTicketEligibility(
        eventId: eventInfo.id,
        ticketTierId: ticket.id,
      );

      state.eligibilityResponse.value = response;
    } catch (err) {
      state.isCheckingEligibility.value = false;
      if (err is DioException) {
        final statusCode = err.response?.statusCode;

        if (statusCode == 401) {
          UserStore.to.clearStore();
          navigateToSignInPage();
          return; // Stop further error handling
        }
        ApiErrorHandler.handleError(err, "Ticket Eligibity Failed");
      } else {
        AppSnackbar.error(
          title: "Ticket Eligibity Failed",
          message: "Something went wrong",
        );
      }
    } finally {
      state.isCheckingEligibility.value = false;
    }
  }

  void navigateToSignInPage() {
    Get.toNamed(RouteName.signInPage);
  }

  void navigateToMyTicketPage() {
    Get.until((route) => route.settings.name == RouteName.dashboardpage);
    dashboardController.state.selectedIndex.value = 3;
    ticketController.onTabOpen();
  }

  String formatEventDateTimeForHome(dynamic event, BuildContext context) {
    try {
      DateTime dateTime;

      if (event.startTime.contains('T') || event.startTime.contains('Z')) {
        dateTime = DateTime.parse(event.startTime).toLocal();
      } else {
        final formattedDate = DateFormat('yyyy-MM-dd').format(event.startDate);
        dateTime = DateTime.parse(
          "$formattedDate ${event.startTime}:00",
        ).toLocal();
      }

      final formattedDate =
          '${event.startDate.day.toString().padLeft(2, '0')}-${event.startDate.month.toString().padLeft(2, '0')}-${event.startDate.year}';
      final formattedTime = formatTimeFromDateTime(dateTime, context);

      return "$formattedDate • $formattedTime";
    } catch (e) {
      LoggerService.loggerInstance.e('Date parse error: $e');
      return "Invalid date";
    }
  }
}
