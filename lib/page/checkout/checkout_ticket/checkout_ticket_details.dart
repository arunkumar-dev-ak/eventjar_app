import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/model/event_info/event_info_model.dart';
import 'package:eventjar/page/checkout/checkout_ticket/checkout_ticket_dropdown.dart';
import 'package:eventjar/page/checkout/checkout_ticket/checkout_ticket_existing_tic_warning.dart';
import 'package:eventjar/page/checkout/checkout_ticket/checkout_ticket_selected_list.dart';
import 'package:flutter/material.dart';

Widget buildCheckoutPageTicketDetailsCard(EventInfo eventInfo) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 4.wp),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.green.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient
          Container(
            padding: EdgeInsets.all(4.wp),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade50,
                  Colors.green.shade50.withValues(alpha: 0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                // Ticket Icon
                Container(
                  padding: EdgeInsets.all(3.wp),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade500, Colors.green.shade600],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
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
                        "Select Your Tickets",
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                      SizedBox(height: 0.3.hp),
                      Text(
                        "Choose ticket type and quantity",
                        style: TextStyle(
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Ticket count indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
                  decoration: BoxDecoration(
                    color: Colors.green.shade500,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_activity_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 1.wp),
                      Text(
                        "${eventInfo.ticketTiers.length}",
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(4.wp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
        ],
      ),
    ),
  );
}
