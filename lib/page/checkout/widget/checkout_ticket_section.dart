import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/checkout/widget/checkout_ticket_dropdown.dart';
import 'package:eventjar/page/checkout/widget/checkout_ticket_selected_list.dart';
import 'package:flutter/material.dart';

class CheckoutTicketSection extends StatelessWidget {
  final dynamic eventInfo;

  const CheckoutTicketSection({super.key, required this.eventInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.wp),
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: AppColors.shadow(context),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tickets",
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2.hp),
          CheckoutTicketDropDown(),
          CheckoutTicketSelectedList(),
        ],
      ),
    );
  }
}
