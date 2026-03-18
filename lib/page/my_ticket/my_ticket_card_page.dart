import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/helper/date_handler.dart';
import 'package:eventjar/model/my_ticket/my_ticket_model.dart';
import 'package:eventjar/page/my_ticket/my_ticket_card_page_utils.dart';
import 'package:flutter/material.dart';

Widget myTicketBuildTicketCard(MyTicket ticket, BuildContext context) {
  final event = ticket.ticketEventDetail;
  final tier = ticket.ticketTierDetail;

  final isActive = ticket.status.toLowerCase() == "active";
  final isFree = tier?.price.toString() == '0';

  final eventTitle = event?.title ?? "Event";
  final tierName = tier?.name ?? "Ticket";
  final price = tier?.price ?? "0";

  final venue = event?.venue ?? "Venue not available";
  final address = event?.address ?? "";

  final startDate = event?.startDate;

  return Container(
    margin: EdgeInsets.only(bottom: 3.hp),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isActive ? Colors.green.shade100 : Colors.grey.shade300,
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: isActive ? Colors.green.shade50 : Colors.grey.shade100,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
        Container(
          padding: EdgeInsets.all(4.wp),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isActive
                  ? [Colors.green.shade50.withValues(alpha: 0.3), Colors.white]
                  : [Colors.grey.shade50.withValues(alpha: 0.3), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// EVENT TITLE
              Text(
                eventTitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 1.5.hp),

              /// BADGES
              Wrap(
                spacing: 2.wp,
                runSpacing: 1.hp,
                children: [
                  /// TICKET TIER
                  myTicketBuildBadge(
                    tierName,
                    isFree ? Colors.green.shade600 : Colors.blue.shade600,
                    isFree ? Colors.green.shade50 : Colors.blue.shade50,
                  ),

                  /// QUANTITY
                  myTicketBuildBadge(
                    'Qty: ${ticket.quantity}',
                    Colors.orange.shade700,
                    Colors.orange.shade50,
                  ),

                  /// PRICE
                  myTicketBuildBadge(
                    isFree ? 'FREE' : 'Total: ₹$price',
                    isFree ? Colors.green.shade700 : Colors.purple.shade700,
                    isFree ? Colors.green.shade100 : Colors.purple.shade100,
                  ),
                ],
              ),
            ],
          ),
        ),

        /// DETAILS SECTION
        Padding(
          padding: EdgeInsets.all(4.wp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LOCATION
              myTicketBuildInfoRow(
                Icons.location_on,
                'Venue',
                '$venue${address.isNotEmpty ? ', $address' : ''}',
                Colors.red.shade400,
              ),

              SizedBox(height: 1.5.hp),

              /// DATE
              myTicketBuildInfoRow(
                Icons.calendar_today,
                'Event Date',
                startDate != null ? formatDate(startDate) : "Date unavailable",
                Colors.blue.shade400,
              ),

              SizedBox(height: 1.5.hp),

              /// TIME
              myTicketBuildInfoRow(
                Icons.access_time,
                'Time',
                startDate != null
                    ? formatTimeFromDateTime(startDate, context)
                    : "Time unavailable",
                Colors.orange.shade400,
              ),

              /// CHECK-IN STATUS
              if (ticket.checkInCount > 0) ...[
                SizedBox(height: 1.5.hp),
                myTicketBuildInfoRow(
                  Icons.check_circle,
                  'Check-ins',
                  '${ticket.checkInCount} / ${ticket.maxCheckIns}',
                  Colors.teal.shade400,
                ),
              ],

              SizedBox(height: 1.5.hp),

              /// QR SECTION
              if (isActive)
                myTicketBuildQRCodeSection(
                  ticket.qrCode,
                  ticket.confirmationCode,
                  formatDate(ticket.registeredAt),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
