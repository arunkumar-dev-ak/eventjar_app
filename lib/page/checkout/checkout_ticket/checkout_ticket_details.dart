import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:eventjar/page/checkout/checkout_ticket/checkout_ticket_dropdown.dart';
import 'package:eventjar/page/checkout/checkout_ticket/checkout_ticket_existing_tic_warning.dart';
import 'package:eventjar/page/checkout/checkout_ticket/checkout_ticket_selected_list.dart';
import 'package:eventjar/page/checkout/checkout_ticket/checkout_ticket_title.dart';
import 'package:flutter/material.dart';

Widget buildCheckoutPageTicketDetailsCard(EventInfo eventInfo) {
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
          CheckoutTicketTitle(),
          SizedBox(height: 2.hp),

          // Existing ticket warning
          CheckoutTicketExistingTicketWarning(),

          // Add Tickets Dropdown
          CheckoutTicketDropDown(),
          SizedBox(height: 2.hp),

          // Selected Tickets List
          CheckoutTicketSelectedList(),
        ],
      ),
    ),
  );
}
