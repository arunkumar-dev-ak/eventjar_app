import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/app_colors.dart';
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
      final isCheckingEligibility = controller.state.isCheckingEligibility.value;
      final cartLines = controller.state.cartLines;
      final totalItems = cartLines.fold<int>(
        0,
        (sum, line) => sum + line.quantity.value,
      );

      return GestureDetector(
        onTap: isCheckingEligibility
            ? null
            : () => _showTicketSelectionBottomSheet(context, eventInfo!.ticketTiers),
        child: Container(
          padding: EdgeInsets.all(3.5.wp),
          decoration: BoxDecoration(
            color: isCheckingEligibility
                ? Colors.grey.shade100
                : totalItems > 0
                    ? Colors.green.shade50
                    : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isCheckingEligibility
                  ? Colors.grey.shade300
                  : totalItems > 0
                      ? Colors.green.shade300
                      : Colors.grey.shade200,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: EdgeInsets.all(2.5.wp),
                decoration: BoxDecoration(
                  gradient: isCheckingEligibility
                      ? null
                      : totalItems > 0
                          ? LinearGradient(
                              colors: [Colors.green.shade500, Colors.green.shade600],
                            )
                          : LinearGradient(
                              colors: [AppColors.gradientDarkStart, AppColors.gradientDarkEnd],
                            ),
                  color: isCheckingEligibility ? Colors.grey.shade300 : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isCheckingEligibility
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(
                        totalItems > 0
                            ? Icons.check_circle_rounded
                            : Icons.add_circle_outline_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
              ),
              SizedBox(width: 3.wp),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCheckingEligibility
                          ? "Checking eligibility..."
                          : totalItems > 0
                              ? "$totalItems ticket${totalItems != 1 ? 's' : ''} selected"
                              : "Add Tickets",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: isCheckingEligibility
                            ? Colors.grey.shade600
                            : totalItems > 0
                                ? Colors.green.shade800
                                : Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 0.3.hp),
                    Text(
                      isCheckingEligibility
                          ? "Please wait..."
                          : totalItems > 0
                              ? "Tap to modify selection"
                              : "Tap to select tickets",
                      style: TextStyle(
                        fontSize: 7.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Container(
                padding: EdgeInsets.all(1.5.wp),
                decoration: BoxDecoration(
                  color: isCheckingEligibility
                      ? Colors.grey.shade200
                      : totalItems > 0
                          ? Colors.green.shade100
                          : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isCheckingEligibility
                      ? Colors.grey.shade400
                      : totalItems > 0
                          ? Colors.green.shade700
                          : Colors.grey.shade600,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

void _showTicketSelectionBottomSheet(BuildContext context, List<TicketTier> ticketTiers) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      constraints: BoxConstraints(maxHeight: 70.hp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 1.5.hp),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.wp),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.5.wp),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade500, Colors.green.shade600],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.confirmation_number_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.wp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Tickets",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        "${ticketTiers.length} ticket types available",
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: EdgeInsets.all(2.wp),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded, size: 18, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade100),

          // Ticket List
          Flexible(
            child: ListView.separated(
              padding: EdgeInsets.all(4.wp),
              shrinkWrap: true,
              itemCount: ticketTiers.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.hp),
              itemBuilder: (context, index) => _buildTicketTile(ticketTiers[index]),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildTicketTile(TicketTier ticket) {
  final controller = Get.find<CheckoutController>();

  return Obx(() {
    final isInCart = controller.state.cartLines.any(
      (line) => line.ticket.id == ticket.id,
    );
    final remaining = ticket.quantity - ticket.sold;
    final isSoldOut = remaining <= 0;
    final price = double.tryParse(ticket.price) ?? 0;

    return GestureDetector(
      onTap: isSoldOut
          ? null
          : () {
              if (!isInCart) {
                controller.addOrIncreaseTicket(ticket);
              }
              Get.back();
            },
      child: Container(
        padding: EdgeInsets.all(4.wp),
        decoration: BoxDecoration(
          color: isSoldOut
              ? Colors.grey.shade100
              : isInCart
                  ? Colors.green.shade50
                  : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSoldOut
                ? Colors.grey.shade300
                : isInCart
                    ? Colors.green.shade400
                    : Colors.grey.shade200,
            width: isInCart ? 2 : 1.5,
          ),
          boxShadow: isInCart
              ? [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Selection Indicator
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isInCart
                    ? LinearGradient(
                        colors: [Colors.green.shade500, Colors.green.shade600],
                      )
                    : null,
                border: !isInCart
                    ? Border.all(
                        color: isSoldOut ? Colors.grey.shade400 : Colors.grey.shade300,
                        width: 2,
                      )
                    : null,
                color: isInCart ? null : Colors.transparent,
              ),
              child: isInCart
                  ? Icon(Icons.check_rounded, color: Colors.white, size: 18)
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
                      Expanded(
                        child: Text(
                          ticket.name,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: isSoldOut ? Colors.grey.shade500 : Colors.grey.shade800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSoldOut)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 0.5.hp),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "Sold Out",
                            style: TextStyle(
                              fontSize: 7.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 0.5.hp),
                  Row(
                    children: [
                      Icon(
                        Icons.local_activity_outlined,
                        size: 14,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(width: 1.wp),
                      Text(
                        isSoldOut ? "No tickets left" : "$remaining tickets available",
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Price & Action
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price > 0 ? "₹${price.toStringAsFixed(0)}" : "Free",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: isSoldOut
                        ? Colors.grey.shade400
                        : price > 0
                            ? Colors.green.shade700
                            : AppColors.gradientDarkStart,
                  ),
                ),
                SizedBox(height: 0.5.hp),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 0.8.hp),
                  decoration: BoxDecoration(
                    gradient: isSoldOut
                        ? null
                        : isInCart
                            ? LinearGradient(
                                colors: [Colors.green.shade500, Colors.green.shade600],
                              )
                            : LinearGradient(
                                colors: [AppColors.gradientDarkStart, AppColors.gradientDarkEnd],
                              ),
                    color: isSoldOut ? Colors.grey.shade300 : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isSoldOut
                        ? "Unavailable"
                        : isInCart
                            ? "Selected"
                            : "Select",
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  });
}
