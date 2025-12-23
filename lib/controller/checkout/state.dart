import 'package:eventjar/model/checkout/cart_line.dart';
import 'package:eventjar/model/checkout/eligibility_model.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:get/get.dart';

class CheckoutState {
  Rxn<EventInfo> eventInfo = Rxn<EventInfo>();

  final RxList<CartLine> cartLines = <CartLine>[].obs;

  final Rx<TicketEligibilityResponse?> eligibilityResponse =
      Rx<TicketEligibilityResponse?>(null);
  final RxBool isCheckingEligibility = false.obs;

  final RxBool isRegistering = false.obs;
  final RxBool isPaymentLoading = false.obs;
}
