import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/helper/date_handler.dart';
import 'package:eventjar/model/my_ticket/my_ticket_model.dart';
import 'package:eventjar/page/my_ticket/my_ticket_card_page_utils.dart';
import 'package:flutter/material.dart';

Widget myTicketBuildTicketCard(MyTicket ticket, BuildContext context) {
  final isActive = ticket.status.toLowerCase() == "active" ? true : false;
  final isFree = ticket.ticketTier.price.toString() == '0' ? true : false;

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
        // Header Section
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
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title
              Text(
                ticket.event.title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 1.5.hp),

              // Badges Row
              Wrap(
                spacing: 2.wp,
                runSpacing: 1.hp,
                children: [
                  // Ticket Tier Badge
                  myTicketBuildBadge(
                    ticket.ticketTier.name,
                    isFree ? Colors.green.shade600 : Colors.blue.shade600,
                    isFree ? Colors.green.shade50 : Colors.blue.shade50,
                  ),

                  // Quantity Badge
                  myTicketBuildBadge(
                    'Qty: ${ticket.quantity}',
                    Colors.orange.shade700,
                    Colors.orange.shade50,
                  ),

                  // Total/Free Badge
                  myTicketBuildBadge(
                    isFree ? 'FREE' : 'Total: ₹${ticket.ticketTier.price}',
                    isFree ? Colors.green.shade700 : Colors.purple.shade700,
                    isFree ? Colors.green.shade100 : Colors.purple.shade100,
                  ),

                  // Status Badge
                  // _buildBadge(
                  //   isActive ? "Active" : "Inactive",
                  //   isActive ? Colors.green.shade700 : Colors.grey.shade700,
                  //   isActive ? Colors.green.shade100 : Colors.grey.shade200,
                  // ),
                ],
              ),
            ],
          ),
        ),

        // Details Section
        Padding(
          padding: EdgeInsets.all(4.wp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location
              myTicketBuildInfoRow(
                Icons.location_on,
                'Venue',
                '${ticket.event.venue}${ticket.event.address.isNotEmpty ? ', ${ticket.event.address}' : ''}',
                Colors.red.shade400,
              ),
              SizedBox(height: 1.5.hp),

              // Date
              myTicketBuildInfoRow(
                Icons.calendar_today,
                'Event Date',
                formatDate(ticket.event.startDate),
                Colors.blue.shade400,
              ),
              SizedBox(height: 1.5.hp),

              // Time (if you have start/end time in your model)
              myTicketBuildInfoRow(
                Icons.access_time,
                'Time',
                // '${formatTimeFromDateTime(ticket.event.startDate, context)} - ${formatTimeFromDateTime(ticket.event.endDate, context)}',
                '${formatTimeFromDateTime(ticket.event.startDate, context)}',
                Colors.orange.shade400,
              ),

              // Check-in Status (if checked in)
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

              // QR Code Section
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
