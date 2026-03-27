import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/helper/date_handler.dart';
import 'package:eventjar/page/my_ticket/my_ticket_shaper_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EventInfoTicketSheet extends StatelessWidget {
  const EventInfoTicketSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventInfoController>();
    final event = controller.state.eventInfo.value!;
    final ticket = event.userTicketStatus!;

    final isActive = ticket.status?.toLowerCase() == "active";
    final timeStr = formatTimeFromHHMM(event.startTime, context);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xfff8fafc),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 1.5.hp),

          /// Drag handle
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          SizedBox(height: 2.hp),

          /// Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.wp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Ticket",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          /// Ticket Card
          Padding(
            padding: EdgeInsets.fromLTRB(5.wp, 0, 5.wp, 3.hp),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? AppColors.gradientDarkStart.withValues(alpha: 0.3)
                      : Colors.grey.shade300,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientDarkStart.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top Gradient Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.wp),
                    decoration: const BoxDecoration(
                      gradient: AppColors.buttonGradient,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: TextStyle(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 1.hp),

                        /// Tier Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ticket.ticketTier?.name ?? "N/A",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Details Section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _infoRow(
                          Icons.calendar_today,
                          "Date",
                          formatDate(event.startDate),
                        ),
                        const SizedBox(height: 12),
                        _infoRow(Icons.access_time, "Time", timeStr),
                        const SizedBox(height: 12),
                        _infoRow(
                          Icons.location_on,
                          "Venue",
                          event.isVirtual
                              ? "Virtual Event"
                              : event.venue ?? "N/A",
                        ),

                        const SizedBox(height: 25),

                        /// QR Section
                        CustomPaint(
                          painter: TicketShapePainter(
                            borderColor: Colors.grey.shade300,
                            borderRadius: 12,
                            circleRadius: 12,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                QrImageView(
                                  data: ticket.qrCode ?? "N/A",
                                  size: 160,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  "Registration ID",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  ticket.registrationId ?? "N/A",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                if (ticket.registeredAt != null) ...[
                                  Text(
                                    "Registered On ${formatDate(ticket.registeredAt!)}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "$label : $value",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 8.5.sp),
          ),
        ),
      ],
    );
  }
}
