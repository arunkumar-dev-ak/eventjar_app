import 'package:eventjar/controller/checkout/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutTicketSelectedList extends GetView<CheckoutController> {
  const CheckoutTicketSelectedList({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cartLines = controller.state.cartLines;
      if (cartLines.isEmpty) return SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(1.5.wp),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.shopping_bag_rounded,
                  size: 14,
                  color: Colors.green.shade600,
                ),
              ),
              SizedBox(width: 2.wp),
              Text(
                "Your Selection",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 0.5.hp),
                decoration: BoxDecoration(
                  color: Colors.green.shade500,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${cartLines.length} ${cartLines.length == 1 ? 'item' : 'items'}",
                  style: TextStyle(
                    fontSize: 7.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.hp),
          ...cartLines.map(
            (line) => _buildSelectedTicketLine(line.ticket, line.quantity),
          ),
        ],
      );
    });
  }
}

Widget _buildSelectedTicketLine(TicketTier ticket, RxInt quantity) {
  final controller = Get.find<CheckoutController>();
  final remaining = ticket.quantity - ticket.sold;
  final price = double.tryParse(ticket.price) ?? 0.0;
  final lineTotal = price * quantity.value;

  return Obx(() => Container(
        margin: EdgeInsets.only(bottom: 1.5.hp),
        padding: EdgeInsets.all(3.wp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.green.shade100, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ticket Icon
            Container(
              padding: EdgeInsets.all(2.5.wp),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade500],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.confirmation_number_rounded,
                color: Colors.white,
                size: 16,
              ),
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
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.3.hp),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 8.sp),
                      children: [
                        TextSpan(
                          text: "₹${price.toStringAsFixed(0)}",
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: " × ${quantity.value} = ",
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        TextSpan(
                          text: "₹${lineTotal.toStringAsFixed(0)}",
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Controls
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildQuantityButton(
                    Icons.remove_rounded,
                    quantity.value > 0
                        ? () => controller.decreaseTicketQty(ticket)
                        : null,
                    quantity.value > 0,
                  ),
                  Container(
                    width: 36,
                    alignment: Alignment.center,
                    child: Text(
                      "${quantity.value}",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  _buildQuantityButton(
                    Icons.add_rounded,
                    quantity.value < remaining
                        ? () => controller.addOrIncreaseTicket(ticket)
                        : null,
                    quantity.value < remaining,
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
}

Widget _buildQuantityButton(IconData icon, VoidCallback? onTap, bool isActive) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 18,
        color: isActive ? Colors.green.shade600 : Colors.grey.shade300,
      ),
    ),
  );
}
