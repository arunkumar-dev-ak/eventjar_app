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
import 'package:eventjar/model/checkout/cart_line.dart';
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
      // if (state.eventInfo.value != null) {
      //   state.selectedTicketTier.value =
      //       state.eventInfo.value!.ticketTiers.first;
      //   checkEligibility(state.eventInfo.value!.ticketTiers.first);
      // }
    }
  }

  void addOrIncreaseTicket(TicketTier tier) {
    final index = state.cartLines.indexWhere(
      (line) => line.ticket.id == tier.id,
    );
    final remaining = tier.quantity - tier.sold;

    if (index == -1) {
      // NEW: Always start with qty=1 when adding
      if (remaining > 0) {
        state.cartLines.add(CartLine(ticket: tier, qty: 1));
      }
    } else {
      // Existing logic for increment
      final line = state.cartLines[index];
      if (line.quantity.value < remaining) {
        line.quantity.value++;
      }
    }
  }

  void decreaseTicketQty(TicketTier tier) {
    final index = state.cartLines.indexWhere(
      (line) => line.ticket.id == tier.id,
    );
    if (index == -1) return;

    final line = state.cartLines[index];
    if (line.quantity.value > 1) {
      line.quantity.value--;
    } else {
      // remove line when goes to 0
      state.cartLines.removeAt(index);
    }
  }

  double get subtotal {
    return state.cartLines.fold(0.0, (sum, line) {
      final price = double.tryParse(line.ticket.price) ?? 0;
      return sum + price * line.quantity.value;
    });
  }

  double get platformFee => 0; // later: compute

  double get total => subtotal + platformFee;

  /*----- Checkout -----*/

  Future<void> proceedToCheckout() async {
    if (state.cartLines.isEmpty) {
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

  Future<void> startPayment() async {
    state.isRegistering.value = true;

    try {
      final eventInfo = state.eventInfo.value;
      if (eventInfo == null) {
        AppSnackbar.error(title: "Error", message: "Event not found");
        return;
      }

      if (state.cartLines.isEmpty) {
        AppSnackbar.error(title: "Error", message: "No tickets in cart");
        return;
      }

      final paymentPayload = _buildPaymentPayload(eventInfo);

      TicketPaymentModel paymentResponse =
          await TicketBookingApi.createTicketPayment(paymentPayload);

      LoggerService.loggerInstance.dynamic_d(
        "Payment Response: ${paymentResponse.toJson()}",
      );

      final razorpayOptions = {
        'key': paymentResponse.razorpayKeyId,
        'order_id': paymentResponse.paymentId,
        'name': 'EventJar',
        'description': 'Tickets for ${eventInfo.title}',
        'prefill': {
          'contact': UserStore.to.profile['phone'] ?? '',
          'email': UserStore.to.profile['email'] ?? '',
        },
      };

      state.isPaymentLoading.value = true;
      _razorpay.open(razorpayOptions);
    } catch (e) {
      LoggerService.loggerInstance.e('Payment init failed: $e');
      AppSnackbar.error(
        title: "Payment Error",
        message: "Failed to start payment: $e",
      );
      state.isPaymentLoading.value = false;
    } finally {
      state.isRegistering.value = false;
    }
  }

  Future<void> _handleFreeTicket() async {
    final eventInfo = state.eventInfo.value;
    if (eventInfo == null) {
      AppSnackbar.error(title: "Error", message: "Event not found");
      return;
    }

    if (state.cartLines.isEmpty) {
      AppSnackbar.error(title: "Error", message: "No tickets in cart");
      return;
    }

    try {
      state.isRegistering.value = true;

      final freeTicketPayload = _buildFreeTicketPayload(eventInfo);

      LoggerService.loggerInstance.dynamic_d(
        "Free Ticket Payload: ${freeTicketPayload.toString()}",
      );

      // Call your free registration API
      await TicketBookingApi.createFreeEventRegistration(freeTicketPayload);

      navigateToMyTicketPage();
    } catch (err) {
      _handleError(err);
    } finally {
      state.isRegistering.value = false;
    }
  }

  double calculateTotalAmount() {
    return state.cartLines.fold<double>(0, (sum, line) {
      final price = double.tryParse(line.ticket.price) ?? 0;
      return sum + price * line.quantity.value;
    });
  }

  Map<String, dynamic> _buildPaymentPayload(EventInfo eventInfo) {
    // ✅ Extract lineItems from cartLines
    final lineItems = state.cartLines
        .map((cartLine) => cartLine.toJson())
        .toList();

    // ✅ Calculate order summary
    final subtotal = state.cartLines.fold<double>(0, (sum, line) {
      final unitPrice = double.tryParse(line.ticket.price) ?? 0;
      return sum + (unitPrice * line.quantity.value);
    });

    final totalQuantity = state.cartLines.fold<int>(
      0,
      (sum, line) => sum + line.quantity.value,
    );
    const discountAmount = 0; // Add promo logic later
    final finalAmount = subtotal - discountAmount;

    return {
      // === REQUIRED FIELDS ===
      'amount': finalAmount.toInt(), // Convert to paise for INR
      'currency': 'INR',
      'paymentType': 'event-ticket',
      'gateway': 'razorpay',

      // === EVENT TICKET FIELDS ===
      'eventId': eventInfo.id,
      'organizerId': eventInfo.organizerId,
      'userId': UserStore.to.profile['id']?.toString() ?? '',
      'customerEmail': UserStore.to.profile['email'] ?? '',

      // === LINE ITEMS ===
      'lineItems': lineItems,

      // === ORDER SUMMARY ===
      'orderSummary': {
        'subtotal': subtotal,
        'discountAmount': discountAmount,
        'totalQuantity': totalQuantity,
        'finalAmount': finalAmount,
      },

      // === OPTIONAL FIELDS ===
      'description': 'Tickets for ${eventInfo.title}',

      // === METADATA ===
      'metadata': {
        'eventTitle': eventInfo.title,
        'eventDate': eventInfo.startDate.toIso8601String(),
        'isOneMeeting': eventInfo.isOneMeetingEnabled,
      },

      // === ANALYTICS ===
      'devicePlatform': 'android',
    };
  }

  Map<String, dynamic> _buildFreeTicketPayload(EventInfo eventInfo) {
    final ticketSelections = state.cartLines.map((cartLine) {
      final price = double.tryParse(cartLine.ticket.price) ?? 0;
      return {
        'tierId': cartLine.ticket.id,
        'quantity': cartLine.quantity.value,
        'price': price,
      };
    }).toList();

    return {
      'userId': UserStore.to.profile['id']?.toString() ?? '',
      'eventId': eventInfo.id,
      'ticketSelections': ticketSelections,
      'promoCodeId': null,
      'promoDiscount': 0,
      'isOneMeeting': eventInfo.isOneMeetingEnabled,
    };
  }

  /*----- Razorpay -----*/

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

  void _onSuccess(PaymentSuccessResponse response) async {
    try {
      state.isPaymentLoading.value = false;
      state.isRegistering.value = true;

      final eventInfo = state.eventInfo.value;
      if (eventInfo == null) {
        AppSnackbar.error(title: "Error", message: "Event not found");
        return;
      }

      // ✅ Backend-exact payload structure
      final verifyPayload = {
        'gateway': 'razorpay',
        'paymentType': 'event-ticket',
        'paymentId': response.paymentId,
        'orderId': response.orderId,
        'signature': response.signature,
        'organizerId': eventInfo.organizerId,
        'eventId': eventInfo.id,
        'userId': UserStore.to.profile['id'],
        'ticketSelections': state.cartLines
            .map(
              (line) => ({
                'tierId': line.ticket.id,
                'quantity': line.quantity.value,
                'price': double.tryParse(line.ticket.price) ?? 0.0,
              }),
            )
            .toList(),
      };

      LoggerService.loggerInstance.d(
        'Verify payload: ${verifyPayload.toString()}',
      );

      await TicketBookingApi.verifyPaymentAndCreateTickets(verifyPayload);
      navigateToMyTicketPage();
    } catch (e) {
      LoggerService.loggerInstance.e('Payment verification failed: $e');
      AppSnackbar.error(
        title: "Verification Failed",
        message:
            "Payment succeeded but ticket creation failed. Contact support.",
      );
    } finally {
      state.isRegistering.value = false;
    }
  }

  void _onError(PaymentFailureResponse response) {
    // LoggerService.loggerInstance.dynamic_d("failure");
    LoggerService.loggerInstance.dynamic_d(response);
    // Get.snackbar("Payment Failed", response.message ?? "Error");
    AppSnackbar.error(
      title: "Payment Failed",
      message: "Payment Failed Please try again",
    );
    state.isPaymentLoading.value = false;
    state.isRegistering.value = false;
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  /*----- helper -----*/
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
