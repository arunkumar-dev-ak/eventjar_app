import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:eventjar/helper/date_handler.dart';
import 'package:eventjar/model/my_ticket/my_ticket_model.dart';
import 'package:eventjar/page/my_ticket/my_ticket_card_page_utils.dart';
import 'package:flutter/material.dart';

Widget myTicketBuildTicketCard(
  MyTicket ticket,
  BuildContext context, {
  VoidCallback? onNavigate,
}) {
  final event = ticket.ticketEventDetail;
  final tier = ticket.ticketTierDetail;

  final isActive = ticket.status.toLowerCase() == "active";
  final isFree = tier?.price.toString() == '0';

  final eventTitle = event?.title ?? "Event";
  final tierName = tier?.name ?? "Ticket";
  final price = tier?.price ?? "0";

  final rawVenue = event?.venue ?? '';
  final address = event?.address ?? '';
  final hasVenue = rawVenue.isNotEmpty;
  final venueDisplay = hasVenue
      ? '$rawVenue${address.isNotEmpty ? ', $address' : ''}'
      : 'Online Event';

  final startDate = event?.startDate;
  final imageUrl = event?.featuredImageUrl;

  final dateStr = startDate != null
      ? formatDate(startDate)
      : 'Date unavailable';
  final timeStr = startDate != null
      ? formatTimeFromDateTime(startDate, context)
      : '';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // "Registered on" label
      Padding(
        padding: EdgeInsets.only(left: 1.wp, bottom: 0.8.hp),
        child: Text(
          'Registered on:  ${formatDate(ticket.registeredAt)}',
          style: TextStyle(
            fontSize: 8.sp,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),

      // Card — entire card is tappable for navigation (opaque catches empty space).
      // The inner QR GestureDetector wins the gesture arena so tapping QR only
      // shows the sheet, never navigates.
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onNavigate,
        child: Container(
          margin: EdgeInsets.only(bottom: 3.hp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive ? Colors.green.shade100 : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Image + details
              Padding(
                padding: EdgeInsets.fromLTRB(3.5.wp, 3.5.wp, 3.5.wp, 1.5.wp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 18.wp,
                        height: 11.hp,
                        child: (imageUrl != null && imageUrl.isNotEmpty)
                            ? Image.network(
                                imageUrl.startsWith('http')
                                    ? imageUrl
                                    : getFileUrl(imageUrl),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) =>
                                    _myTicketImagePlaceholder(),
                              )
                            : _myTicketImagePlaceholder(),
                      ),
                    ),

                    SizedBox(width: 3.wp),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            eventTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),

                          SizedBox(height: 0.7.hp),

                          // Tier badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.wp,
                              vertical: 0.3.hp,
                            ),
                            decoration: BoxDecoration(
                              color: isFree
                                  ? Colors.green.shade50
                                  : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tierName,
                              style: TextStyle(
                                fontSize: 7.sp,
                                fontWeight: FontWeight.w600,
                                color: isFree
                                    ? Colors.green.shade700
                                    : Colors.blue.shade700,
                              ),
                            ),
                          ),

                          SizedBox(height: 0.8.hp),

                          // DATE & TIME — highlighted
                          Text(
                            timeStr.isNotEmpty
                                ? '$dateStr  |  $timeStr'
                                : dateStr,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),

                          SizedBox(height: 0.7.hp),

                          // Venue
                          Row(
                            children: [
                              Icon(
                                hasVenue
                                    ? Icons.location_on_outlined
                                    : Icons.videocam_outlined,
                                size: 12,
                                color: Colors.grey.shade500,
                              ),
                              SizedBox(width: 1.wp),
                              Expanded(
                                child: Text(
                                  venueDisplay,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Qty + Price row with View QR button
              Padding(
                padding: EdgeInsets.fromLTRB(3.5.wp, 0, 3.5.wp, 1.5.wp),
                child: Row(
                  children: [
                    Text(
                      '${ticket.quantity} Ticket${ticket.quantity > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '  •  ',
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      isFree ? 'FREE' : '₹$price',
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                        color: isFree
                            ? Colors.green.shade600
                            : Colors.orange.shade700,
                      ),
                    ),

                    if (isActive) ...[
                      const Spacer(),
                      // Inner GestureDetector wins the arena — only QR sheet fires,
                      // outer navigation does not.
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => myTicketShowQRSheet(
                          context: context,
                          qrData: ticket.qrCode,
                          confirmationCode: ticket.confirmationCode,
                          registeredDate: formatDate(ticket.registeredAt),
                          eventTitle: eventTitle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.wp,
                            vertical: 0.5.hp,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View QR',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 1.wp),
                              Icon(
                                Icons.qr_code_2_rounded,
                                size: 22,
                                color: Colors.green.shade700,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Check-ins row (only if any)
              if (ticket.checkInCount > 0) ...[
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.5.wp,
                    right: 3.5.wp,
                    bottom: 1.hp,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 13,
                        color: Colors.teal.shade400,
                      ),
                      SizedBox(width: 1.5.wp),
                      Text(
                        'Check-ins: ${ticket.checkInCount} / ${ticket.maxCheckIns}',
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: Colors.teal.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Divider + bottom strip (finished tickets only)
              if (!isActive) ...[
                Divider(height: 1, color: Colors.grey.shade200),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.5.wp,
                    vertical: 1.2.hp,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.wp,
                          vertical: 0.6.hp,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'FINISHED',
                          style: TextStyle(
                            fontSize: 7.5.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.wp),
                      Container(
                        height: 3.hp,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(width: 3.wp),
                      Expanded(
                        child: Text(
                          'Hope you enjoyed the Show!',
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _myTicketImagePlaceholder() {
  return Container(
    color: Colors.grey.shade100,
    child: Center(
      child: Icon(Icons.event_outlined, color: Colors.grey.shade300, size: 32),
    ),
  );
}
