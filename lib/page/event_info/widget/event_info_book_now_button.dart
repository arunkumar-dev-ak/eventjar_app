import 'package:eventjar/controller/event_info/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/event_info/widget/event_info_back_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventInfoBookButton extends StatelessWidget {
  final bool isFree;

  const EventInfoBookButton({super.key, required this.isFree});

  static const LinearGradient _primaryGradient = AppColors.buttonGradient;

  static const LinearGradient _successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient _infoGradient = LinearGradient(
    colors: [Color(0xFF64748B), Color(0xFF475569)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventInfoController>();

    return Obx(() {
      final eventInfo = controller.state.eventInfo.value;
      final isRegistered = eventInfo?.userTicketStatus?.isRegistered == true;
      final isLoggedIn = controller.isLoggedIn.value;

      final organizerId = eventInfo?.organizer.id ?? '';
      final isEventBelongsToOrganizer =
          organizerId.isNotEmpty && controller.isOrganizer(organizerId);

      final bool isDisabled = isEventBelongsToOrganizer;
      final LinearGradient gradient = _resolveGradient(
        isRegistered,
        isEventBelongsToOrganizer,
      );

      if (controller.state.isLoading.value) {
        return const EventInfoBookButtonShimmer();
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5.wp),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: isDisabled ? null : controller.handleBottomButton,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 3.5.wp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isRegistered
                        ? Icons.check_circle_rounded
                        : Icons.confirmation_num_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  SizedBox(width: 3.wp),
                  Text(
                    _buttonText(
                      isEventBelongsToOrganizer,
                      isRegistered,
                      isLoggedIn,
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (isFree && !isRegistered && !isEventBelongsToOrganizer)
                    _freeBadge(),
                  SizedBox(width: 2.wp),
                  if (!isDisabled)
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  LinearGradient _resolveGradient(
    bool isRegistered,
    bool isEventBelongsToOrganizer,
  ) {
    if (isEventBelongsToOrganizer) return _infoGradient;
    if (isRegistered) return _successGradient;
    return _primaryGradient;
  }

  String _buttonText(
    bool isEventBelongsToOrganizer,
    bool isRegistered,
    bool isLoggedIn,
  ) {
    if (isEventBelongsToOrganizer) return "Your Event";
    if (isRegistered) return "View My Ticket";
    return isLoggedIn ? "Book Now" : "Login to Book";
  }

  Widget _freeBadge() {
    return Padding(
      padding: EdgeInsets.only(left: 3.wp),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        ),
        child: Text(
          "FREE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 8.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
