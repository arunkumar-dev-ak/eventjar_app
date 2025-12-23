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
import 'package:eventjar/model/checkout/tikcet_payment_model.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:eventjar/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutController extends GetxController {
  var appBarTitle = "EventJar";
  final state = CheckoutState();
  late Razorpay _razorpay;

  final MyTicketController ticketController = Get.find();
  final DashboardController dashboardController = Get.find();

  @override
  void onInit() {
    // LoggerService.loggerInstance.dynamic_d("In oninit");
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
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

    if (state.eligibilityResponse.value?.eligible == false) {
      AppSnackbar.error(
        title: "Not Eligible",
        message:
            state.eligibilityResponse.value?.reason ??
            "You already have a ticket",
      );
      return;
    }

    final totalAmount = calculateTotalAmount();

    if (totalAmount == 0) {
      await _handleFreeTicket();
    } else {
      startPayment();
    }
  }

  Future<void> _handleFreeTicket() async {
    final eventInfo = state.eventInfo.value;
    if (eventInfo == null) return;

    try {
      state.isRegistering.value = true;
      await TicketBookingApi.registerTicket(
        eventId: eventInfo.id,
        ticketTierId: state.selectedTicketTier.value!.id,
      );
      navigateToMyTicketPage();
    } catch (err) {
      _handleError(err);
    } finally {
      state.isRegistering.value = false;
    }
  }

  void _handleError(dynamic err) {
    if (err is DioException) {
      if (err.response?.statusCode == 401) {
        UserStore.to.clearStore();
        navigateToSignInPage();
        return;
      }
      ApiErrorHandler.handleError(err, "Registration Failed");
    } else {
      AppSnackbar.error(title: "Error", message: "Something went wrong");
    }
  }

  void selectTicketTier(TicketTier ticket) {
    state.selectedTicketTier.value = ticket;
    // Check eligibility when ticket is selected
    checkEligibility(ticket);
  }

  /*----- Payment -----*/
  Future<void> startPayment() async {
    state.isRegistering.value = true;

    try {
      final eventInfo = state.eventInfo.value;
      if (eventInfo == null) {
        AppSnackbar.error(title: "Error", message: "Event not found");
        return;
      }

      final totalAmount = calculateTotalAmount(); // Implement this method

      TicketPaymentModel paymentResponse =
          await TicketBookingApi.createTicketPayment({
            "amount": totalAmount,
            "currency": "INR",
            "paymentType": "event-ticket",
            "gateway": "razorpay",
            "description": "Tickets for ${eventInfo.title}",
            "customerEmail": UserStore.to.profile['email'],
            "organizerId": eventInfo.organizerId,
            "eventId": eventInfo.id,
          });

      LoggerService.loggerInstance.dynamic_d(
        "paymentResponse, $paymentResponse",
      );

      // ✅ Open Razorpay with server response
      final razorpayOptions = {
        'key': paymentResponse.razorpayKeyId,
        'order_id': paymentResponse.paymentId,
        'name': 'EventJar',
        'description': 'Tickets for ${eventInfo.title}',
        'prefill': {
          'contact': UserStore.to.profile['phone'] ?? '',
          'email': UserStore.to.profile['email'] ?? '',
        },
        // 'currency': 'INR',
        // 'amount': totalAmount * 100,
      };

      _razorpay.open(razorpayOptions);
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      // LoggerService.loggerInstance.e('Payment init failed: $e');
      AppSnackbar.error(
        title: "Payment Error",
        message: "Failed to start payment",
      );
    } finally {
      state.isRegistering.value = false;
    }
  }

  double calculateTotalAmount() {
    final ticket = state.selectedTicketTier.value;
    if (ticket == null) return 0;

    double price = ticket.isEarlyBird && ticket.earlyBirdPrice != null
        ? ticket.earlyBirdPrice!
        : double.tryParse(ticket.price) ?? 0.0;

    return price * state.quantity.value;
  }

  void _onSuccess(PaymentSuccessResponse response) async {
    // LoggerService.loggerInstance.d("✅ Payment Success: ${response.paymentId}");

    // ✅ Validate payment & navigate
    // try {
    //   await validatePayment(response.paymentId);
    navigateToMyTicketPage();
    // } catch (e) {
    //   AppSnackbar.error(
    //     title: "Validation Failed",
    //     message: "Payment validation failed",
    //   );
    // }
    state.isRegistering.value = false;
  }

  void _onError(PaymentFailureResponse response) {
    // LoggerService.loggerInstance.dynamic_d("failure");
    LoggerService.loggerInstance.dynamic_d(response);
    // Get.snackbar("Payment Failed", response.message ?? "Error");
    AppSnackbar.error(
      title: "Payment Failed",
      message: "Payment Failed Please try again",
    );
    state.isRegistering.value = false;
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
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
