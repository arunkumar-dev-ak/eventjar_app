import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildCheckoutPageTicketDetailsCard(EventInfo eventInfo) {
  final CheckoutController controller = Get.find();

  return Obx(() {
    final hasExistingTicket =
        controller.state.eligibilityResponse.value?.eligible == false;
    final selectedTicket = controller.state.selectedTicketTier.value;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.wp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade100, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade50,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(4.wp),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50.withValues(alpha: 0.3), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(1.5.wp),
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.confirmation_number,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                SizedBox(width: 3.wp),
                Text(
                  "Ticket Details",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.hp),

            if (hasExistingTicket) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.orange.shade700,
                    size: 18,
                  ),
                  SizedBox(width: 2.wp),
                  Expanded(
                    child: Obx(() {
                      final reason =
                          controller.state.eligibilityResponse.value?.reason;
                      return Text(
                        reason ?? "You already have a ticket for this tier",
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 2.hp),
            ],

            // Ticket Selection (Clickable)
            Obx(() {
              final isCheckingEligibility =
                  controller.state.isCheckingEligibility.value;

              return InkWell(
                onTap: isCheckingEligibility
                    ? null
                    : () => _showTicketSelectionDialog(eventInfo.ticketTiers),
                child: Container(
                  padding: EdgeInsets.all(3.wp),
                  decoration: BoxDecoration(
                    color: isCheckingEligibility
                        ? Colors.grey.shade100
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCheckingEligibility
                          ? Colors.grey.shade300
                          : Colors.green.shade200,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            // Show loading indicator or badge
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
                                  color: selectedTicket?.price == "0"
                                      ? Colors.green.shade600
                                      : Colors.blue.shade600,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  selectedTicket?.price == "0"
                                      ? "FREE"
                                      : "PAID",
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
                                    : selectedTicket?.name ?? "Select Ticket",
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
                      Row(
                        children: [
                          if (!isCheckingEligibility)
                            Text(
                              selectedTicket != null
                                  ? "₹${selectedTicket.price}"
                                  : "",
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          SizedBox(width: 2.wp),
                          Icon(
                            Icons.arrow_drop_down,
                            color: isCheckingEligibility
                                ? Colors.grey.shade400
                                : Colors.green.shade700,
                            size: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            SizedBox(height: 2.hp),

            // Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Quantity",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade900,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green.shade300,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // child: Row(
                  //   children: [
                  //     _buildQuantityButton(
                  //       Icons.remove,
                  //       () => controller.decrementQuantity(),
                  //       Colors.green.shade400,
                  //     ),
                  //     Obx(
                  //       () => Container(
                  //         padding: EdgeInsets.symmetric(horizontal: 4.wp),
                  //         child: Text(
                  //           "${controller.state.quantity.value}",
                  //           style: TextStyle(
                  //             fontSize: 10.sp,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.green.shade900,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     _buildQuantityButton(
                  //       Icons.add,
                  //       () => controller.incrementQuantity(),
                  //       Colors.green.shade400,
                  //     ),
                  //   ],
                  // ),
                  child: AbsorbPointer(
                    absorbing: true, // disables taps
                    child: Opacity(
                      opacity: 0.4, // semi-transparent to look disabled
                      child: Row(
                        children: [
                          _buildQuantityButton(
                            Icons.remove,
                            () {}, // empty callback since disabled
                            Colors.grey.shade400,
                          ),
                          Obx(
                            () => Container(
                              padding: EdgeInsets.symmetric(horizontal: 4.wp),
                              child: Text(
                                "${controller.state.quantity.value}",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                          _buildQuantityButton(
                            Icons.add,
                            () {}, // empty callback since disabled
                            Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.5.hp), // some spacing
            Text(
              "You are allowed to select only one ticket for this event",
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade800,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  });
}

void _showTicketSelectionDialog(List<TicketTier> ticketTiers) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(4.wp),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Ticket",
                    style: TextStyle(
                      fontSize: 13.sp,
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

              // Ticket List
              ...ticketTiers.map((ticket) => _buildTicketOption(ticket)),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildTicketOption(TicketTier ticket) {
  final CheckoutController controller = Get.find();

  return Obx(() {
    final isSelected =
        controller.state.selectedTicketTier.value?.id == ticket.id;

    return InkWell(
      onTap: () {
        controller.selectTicketTier(ticket);
        Get.back();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.hp),
        padding: EdgeInsets.all(3.wp),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green.shade400 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Selection Indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Colors.green.shade600
                      : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? Colors.green.shade600 : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
            SizedBox(width: 3.wp),

            // Ticket Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        ticket.name,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 2.wp),
                      if (ticket.price == "0")
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.wp,
                            vertical: 0.3.hp,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "FREE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 7.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 0.5.hp),
                  Text(
                    "${ticket.quantity - ticket.sold} tickets available",
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Price
            Text(
              "₹${ticket.price}",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  });
}

Widget _buildQuantityButton(IconData icon, VoidCallback onTap, Color color) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(2.wp),
      child: Icon(icon, size: 18, color: color),
    ),
  );
}
