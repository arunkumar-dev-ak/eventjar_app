import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutTicketDropDown extends GetView<CheckoutController> {
  const CheckoutTicketDropDown({super.key});
  @override
  Widget build(BuildContext context) {
    final eventInfo = controller.state.eventInfo.value;
    return Obx(() {
      final isCheckingEligibility =
          controller.state.isCheckingEligibility.value;
      final cartLines = controller.state.cartLines;
      final totalItems = cartLines.fold<int>(
        0,
        (sum, line) => sum + line.quantity.value,
      );

      return InkWell(
        onTap: isCheckingEligibility
            ? null
            : () => _showTicketSelectionDialog(eventInfo!.ticketTiers),
        child: Container(
          padding: EdgeInsets.all(3.wp),
          decoration: BoxDecoration(
            color: isCheckingEligibility
                ? Colors.grey.shade100
                : totalItems > 0
                ? Colors.green.shade50
                : Colors.green.shade50.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCheckingEligibility
                  ? Colors.grey.shade300
                  : totalItems > 0
                  ? Colors.green.shade200
                  : Colors.green.shade200.withValues(alpha: 0.7),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (isCheckingEligibility)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green.shade600,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.wp,
                          vertical: 0.5.hp,
                        ),
                        decoration: BoxDecoration(
                          color: totalItems > 0
                              ? Colors.green.shade600
                              : Colors.blue.shade600,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          totalItems > 0
                              ? "$totalItems tickets"
                              : "Add Tickets",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    SizedBox(width: 3.wp),
                    Expanded(
                      child: Text(
                        isCheckingEligibility
                            ? "Checking eligibility..."
                            : totalItems > 0
                            ? "$totalItems ticket${totalItems != 1 ? 's' : ''} selected"
                            : "Tap to select tickets",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: isCheckingEligibility
                              ? Colors.grey.shade600
                              : Colors.green.shade900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: isCheckingEligibility
                    ? Colors.grey.shade400
                    : Colors.green.shade700,
                size: 24,
              ),
            ],
          ),
        ),
      );
    });
  }
}

void _showTicketSelectionDialog(List<TicketTier> ticketTiers) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(maxHeight: 60.hp),
        padding: EdgeInsets.all(4.wp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dialog Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Tickets",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 2.hp),

            // Available Tickets (Selection Only)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...ticketTiers.map(
                      (ticket) => _buildSelectionOnlyTicket(ticket),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSelectionOnlyTicket(TicketTier ticket) {
  final controller = Get.find<CheckoutController>();
  final isInCart = controller.state.cartLines.any(
    (line) => line.ticket.id == ticket.id,
  );

  return InkWell(
    onTap: () {
      if (!isInCart) {
        controller.addOrIncreaseTicket(ticket);
      }
      Get.back();
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 2.hp),
      padding: EdgeInsets.all(3.5.wp),
      decoration: BoxDecoration(
        color: isInCart ? Colors.green.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isInCart ? Colors.green.shade400 : Colors.grey.shade300,
          width: isInCart ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Selection Indicator
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isInCart ? Colors.green.shade600 : Colors.grey.shade400,
                width: 2,
              ),
              color: isInCart ? Colors.green.shade600 : Colors.transparent,
            ),
            child: isInCart
                ? Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          SizedBox(width: 3.wp),

          // Ticket Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.name,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.hp),
                Text(
                  "${ticket.quantity - ticket.sold} tickets available • ₹${ticket.price}",
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Add Button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
            decoration: BoxDecoration(
              color: isInCart ? Colors.green.shade600 : Colors.green.shade500,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isInCart ? "Added" : "Add",
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
