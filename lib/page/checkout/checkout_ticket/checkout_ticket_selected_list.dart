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
          Text(
            "Selected Tickets",
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
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

  return Container(
    margin: EdgeInsets.only(bottom: 2.hp),
    padding: EdgeInsets.all(3.wp),
    decoration: BoxDecoration(
      color: Colors.green.shade50,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.green.shade100, width: 1),
    ),
    child: Row(
      children: [
        // Ticket Icon
        Container(
          padding: EdgeInsets.all(1.5.wp),
          decoration: BoxDecoration(
            color: Colors.green.shade400,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(Icons.confirmation_number, color: Colors.white, size: 14),
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
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "₹${price.toStringAsFixed(0)} × ${quantity.value} = ₹${lineTotal.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Quantity Controls
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQuantityButton(
              Icons.remove,
              quantity.value > 0
                  ? () => controller.decreaseTicketQty(ticket)
                  : null,
              quantity.value > 0 ? Colors.green.shade500 : Colors.grey.shade400,
            ),

            Container(
              width: 40,
              height: 26,
              padding: EdgeInsets.symmetric(horizontal: 1.wp),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.green.shade300, width: 1.5),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${quantity.value}",
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
            ),
            _buildQuantityButton(
              Icons.add,
              quantity.value < remaining
                  ? () => controller.addOrIncreaseTicket(ticket)
                  : null,
              quantity.value < remaining
                  ? Colors.green.shade500
                  : Colors.grey.shade400,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildQuantityButton(IconData icon, VoidCallback? onTap, Color color) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Icon(icon, size: 16, color: color),
    ),
  );
}
