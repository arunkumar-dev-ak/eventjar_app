import 'package:eventjar_app/controller/event_info/controller.dart';
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/global/utils/helpers.dart';
import 'package:eventjar_app/model/event_info/event_info_model.dart';
import 'package:eventjar_app/page/event_info/widget/event_info_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class EventInfoHeader extends StatelessWidget {
  final EventInfoController controller = Get.find();

  EventInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final EventInfo? eventInfo = controller.state.eventInfo.value;

      if (controller.state.isLoading.value) {
        return EventCardShimmer();
      }

      if (eventInfo == null) {
        return const SizedBox();
      }

      final organizer = eventInfo.organizer;

      // Format date and time display (customize formatting as needed)
      final dateStr =
          "${eventInfo.startDate.day.toString().padLeft(2, '0')}-${eventInfo.startDate.month.toString().padLeft(2, '0')}-${eventInfo.startDate.year}";
      final timeStr =
          eventInfo.startTime != null && eventInfo.startTime!.isNotEmpty
          ? controller.generateDateTimeAndFormatTime(
              eventInfo.startTime!,
              context,
            )
          : 'N/A';

      // Attendee info
      final attendedCount = eventInfo.currentAttendees;
      final maxAttendees = eventInfo.maxAttendees;
      final spotsLeft = maxAttendees - attendedCount;
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 3.wp, horizontal: 3.wp),
        child: Column(
          children: [
            // Event Title added at the top
            Text(
              eventInfo.title,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 1.hp),
            // Organizer row
            Row(
              children: [
                //organizer info
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Organized By",
                        style: TextStyle(
                          color: AppColors.eventInfoHeaderTextColor,
                          fontSize: 10.sp,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 2.wp),
                      buildOrganizerAvatar(organizer.avatarUrl, organizer.name),
                      SizedBox(width: 2.wp),
                      Expanded(
                        child: Text(
                          organizer.name,
                          style: TextStyle(
                            color: AppColors.eventInfoHeaderTextColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(Icons.info_outline, color: AppColors.gradientDarkStart),
                SizedBox(width: 3.wp),
              ],
            ),

            SizedBox(height: 1.hp),

            // Location row
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: const Color.fromARGB(
                    255,
                    255,
                    109,
                    99,
                  ).withValues(alpha: 0.8),
                ),
                SizedBox(width: 2.wp),
                Expanded(
                  child: Text(
                    eventInfo.city != null && eventInfo.city!.isNotEmpty
                        ? "${eventInfo.venue ?? ''}${eventInfo.city!.isNotEmpty ? ', ' : ''}${eventInfo.city ?? ''}"
                        : "Location not specified",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.eventInfoHeaderTextColor,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.hp),

            // Date & Time row
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.clock,
                  color: const Color.fromARGB(255, 7, 102, 180),
                  size: 18,
                ),
                SizedBox(width: 3.wp),
                Expanded(
                  child: Text(
                    "$dateStr • $timeStr",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.eventInfoHeaderTextColor,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.hp),

            Container(
              width: 100.wp,
              height: 1,
              color: Colors.white.withAlpha(125),
            ),

            SizedBox(height: 2.hp),

            // Attendee avatars and stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Attended avatars and going count
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 70,
                          height: 35,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 40,
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Colors.white,
                                  backgroundImage: const AssetImage(
                                    'assets/event_info/event_info_attendes_profile.jpg',
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 20,
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Colors.white,
                                  backgroundImage: const AssetImage(
                                    'assets/event_info/event_info_attendes_profile.jpg',
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.white,
                                backgroundImage: const AssetImage(
                                  'assets/event_info/event_info_attendes_profile.jpg',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    generateBadge(label: "$attendedCount going"),
                  ],
                ),

                // Attendance count and spots left
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: AppColors.gradientDarkStart),
                        SizedBox(width: 1.wp),
                        Text(
                          "$attendedCount/$maxAttendees",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.hp),
                    generateBadge(label: "$spotsLeft Spots left"),
                  ],
                ),

                // Event mode badge
                eventModeBadge(
                  mode: eventInfo.isVirtual ? "Virtual" : "In-Person",
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

Widget generateBadge({required String label}) {
  return Container(
    decoration: BoxDecoration(
      gradient: AppColors.buttonGradient,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: EdgeInsets.all(1.wp),
    child: Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget eventModeBadge({required String mode}) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.gradientDarkStart,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.grey, offset: Offset(0.5, 1), blurRadius: 1),
      ],
    ),
    child: Text(
      mode,
      style: TextStyle(
        color: Colors.white,
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget buildOrganizerAvatar(String? avatarUrl, String organizerName) {
  if (avatarUrl != null && avatarUrl.isNotEmpty) {
    return ClipOval(
      child: Image.network(
        getFileUrl(avatarUrl),
        width: 30,
        height: 30,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(width: 30, height: 30, color: Colors.grey.shade300);
        },
        errorBuilder: (context, error, stackTrace) {
          // Show default user icon on error
          return CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: AppColors.gradientDarkStart,
              size: 20,
            ),
          );
        },
      ),
    );
  } else {
    // Show default CircleAvatar with initial or icon for null/empty avatarUrl
    return CircleAvatar(
      radius: 15,
      backgroundColor: Colors.white,
      child: Text(
        organizerName.isNotEmpty ? organizerName[0] : '',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppColors.gradientDarkStart,
        ),
      ),
    );
  }
}
