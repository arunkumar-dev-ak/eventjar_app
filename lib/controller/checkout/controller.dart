import 'package:dio/dio.dart';
import 'package:eventjar_app/api/checkout_api/booking_api.dart';
import 'package:eventjar_app/api/checkout_api/eligibility_api.dart';
import 'package:eventjar_app/controller/checkout/state.dart';
import 'package:eventjar_app/global/app_snackbar.dart';
import 'package:eventjar_app/helper/apierror_handler.dart';
import 'package:eventjar_app/model/event_info/event_info_model.dart';
import 'package:eventjar_app/routes/route_name.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  var appBarTitle = "EventJar";
  final state = CheckoutState();

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

  void navigateToMyTicketPage() {
    Get.offAndToNamed(RouteName.myTicketPage);
  }
}
