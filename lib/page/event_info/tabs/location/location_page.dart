import 'package:eventjar_app/controller/event_info/controller.dart';
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/model/event_info/event_info_model.dart';
import 'package:eventjar_app/page/event_info/tabs/location/location_page_contact_card.dart';
import 'package:eventjar_app/page/event_info/tabs/location/location_page_utils.dart';
import 'package:eventjar_app/page/event_info/tabs/location/physical_location_card.dart';
import 'package:eventjar_app/page/event_info/tabs/location/virtual_location_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationPage extends StatelessWidget {
  final EventInfoController controller = Get.find();

  LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final eventInfo = controller.state.eventInfo.value;

      if (eventInfo == null) {
        return const Center(child: Text("No event info available"));
      }

      final isVirtual = eventInfo.isVirtual;
      final isHybrid = eventInfo.isHybrid;
      final hasPhysicalLocation =
          eventInfo.venue != null && eventInfo.venue!.isNotEmpty;

      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(4.wp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // virtual
              if (isVirtual || isHybrid) ...[
                _buildCardSection(
                  title: "Virtual Event",
                  icon: Icons.monitor,
                  child: buildVirtualEventCard(
                    platform: eventInfo.virtualPlatform ?? "Online Platform",
                    meetingLink: eventInfo.virtualLink,
                  ),
                ),
                SizedBox(height: 2.hp),
              ],

              // physical
              if (hasPhysicalLocation || isHybrid) ...[
                _buildCardSection(
                  title: "Physical Event",
                  icon: Icons.location_city,
                  child: buildPhysicalEventCard(eventInfo),
                ),
                SizedBox(height: 2.hp),
              ],

              // Contact Information
              if (eventInfo.organizerContactPhone != null &&
                  eventInfo.organizerContactPhone!.isNotEmpty) ...[
                _buildCardSection(
                  title: "Contact Information",
                  icon: Icons.contact_phone,
                  child: buildContactCard(
                    phone: eventInfo.organizerContactPhone!,
                    name: eventInfo.organizerContactName,
                    email: eventInfo.organizerContactEmail,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCardSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: AppColors.buttonGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientDarkStart.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.wp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(title, icon),
            SizedBox(height: 2.hp),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.wp),
          decoration: BoxDecoration(
            gradient: AppColors.buttonGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        SizedBox(width: 3.wp),
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
