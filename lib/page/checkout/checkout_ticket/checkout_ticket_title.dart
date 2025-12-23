import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';

class CheckoutTicketTitle extends StatelessWidget {
  const CheckoutTicketTitle({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(1.5.wp),
          decoration: BoxDecoration(
            color: Colors.green.shade400,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.confirmation_number, color: Colors.white, size: 15),
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
    );
  }
}
