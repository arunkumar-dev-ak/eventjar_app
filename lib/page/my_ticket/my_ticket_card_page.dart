import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/helper/date_handler.dart';
import 'package:eventjar/model/my_ticket/my_ticket_model.dart';
import 'package:eventjar/page/my_ticket/my_ticket_card_page_utils.dart';
import 'package:flutter/material.dart';

class MyTicketCard extends StatefulWidget {
  final MyTicket ticket;

  const MyTicketCard({super.key, required this.ticket});

  @override
  State<MyTicketCard> createState() => _MyTicketCardState();
}

class _MyTicketCardState extends State<MyTicketCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;
    final isActive = ticket.status.toLowerCase() == "active";
    final isFree = ticket.ticketTier?.price.toString() == '0';

    return Container(
      margin: EdgeInsets.only(bottom: 2.hp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? AppColors.gradientDarkStart.withValues(alpha: 0.1)
                : Colors.grey.shade200,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section - Always visible, tappable
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.all(4.wp),
              decoration: BoxDecoration(
                gradient: isActive ? AppColors.buttonGradient : null,
                color: isActive ? null : Colors.grey.shade100,
                borderRadius: _isExpanded
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )
                    : BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status, price and expand icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: isActive ? 0.2 : 0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isActive ? Icons.check_circle : Icons.cancel,
                              size: 12,
                              color: isActive ? Colors.white : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                fontSize: 7.sp,
                                fontWeight: FontWeight.w600,
                                color: isActive ? Colors.white : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (ticket.ticketTier != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: isActive ? 0.2 : 0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isFree ? 'FREE' : '₹${ticket.ticketTier!.price}',
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                              color: isActive ? Colors.white : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      SizedBox(width: 2.wp),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: isActive ? Colors.white : Colors.grey.shade600,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.hp),
                  // Event Title
                  Text(
                    ticket.event.title,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : Colors.grey.shade800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.hp),
                  // Badges Row
                  Row(
                    children: [
                      Wrap(
                        spacing: 2.wp,
                        runSpacing: 0.5.hp,
                        children: [
                          if (ticket.ticketTier != null)
                            _buildHeaderBadge(
                              ticket.ticketTier!.name,
                              isActive,
                            ),
                          _buildHeaderBadge(
                            'Qty: ${ticket.quantity}',
                            isActive,
                          ),
                        ],
                      ),
                      const Spacer(),
                      // QR hint when collapsed
                      if (!_isExpanded && isActive)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 0.4.hp),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.qr_code_rounded,
                                size: 12,
                                color: Colors.white,
                              ),
                              SizedBox(width: 1.wp),
                              Text(
                                'Tap for QR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 7.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expandable Details Section
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.all(4.wp),
              child: Column(
                children: [
                  // Venue & Registered On - Same Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildCompactInfoCard(
                          icon: Icons.location_on_rounded,
                          label: 'Venue',
                          value: ticket.event.venue.isNotEmpty
                              ? ticket.event.venue
                              : 'TBA',
                          iconColor: Colors.red.shade400,
                        ),
                      ),
                      SizedBox(width: 3.wp),
                      Expanded(
                        child: _buildCompactInfoCard(
                          icon: Icons.event_available_rounded,
                          label: 'Registered',
                          value: formatDate(ticket.registeredAt),
                          iconColor: Colors.green.shade400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.hp),

                  // Date & Time - Same Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildCompactInfoCard(
                          icon: Icons.calendar_today_rounded,
                          label: 'Date',
                          value: formatDate(ticket.event.startDate),
                          iconColor: Colors.blue.shade400,
                        ),
                      ),
                      SizedBox(width: 3.wp),
                      Expanded(
                        child: _buildCompactInfoCard(
                          icon: Icons.access_time_rounded,
                          label: 'Time',
                          value: formatTimeFromDateTime(ticket.event.startDate, context),
                          iconColor: Colors.orange.shade400,
                        ),
                      ),
                    ],
                  ),

                  // Check-in Status
                  if (ticket.checkInCount > 0) ...[
                    SizedBox(height: 1.5.hp),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.teal.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded, size: 16, color: Colors.teal.shade600),
                          SizedBox(width: 2.wp),
                          Text(
                            'Checked in ${ticket.checkInCount} / ${ticket.maxCheckIns}',
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 1.5.hp),

                  // QR Code Section
                  if (isActive)
                    myTicketBuildQRCodeSection(
                      ticket.qrCode,
                      ticket.confirmationCode,
                    ),
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}

// Wrapper function for backward compatibility
Widget myTicketBuildTicketCard(MyTicket ticket, BuildContext context) {
  return MyTicketCard(ticket: ticket);
}

Widget _buildHeaderBadge(String label, bool isActive) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 0.4.hp),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: isActive ? 0.2 : 0.8),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: isActive ? Colors.white : Colors.grey.shade700,
        fontSize: 7.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget _buildCompactInfoCard({
  required IconData icon,
  required String label,
  required String value,
  required Color iconColor,
}) {
  return Container(
    padding: EdgeInsets.all(3.wp),
    decoration: BoxDecoration(
      color: iconColor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        SizedBox(width: 2.wp),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 7.sp,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
