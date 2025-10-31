import 'package:eventjar_app/controller/event_info/controller.dart';
import 'package:eventjar_app/global/app_colors.dart';
import 'package:eventjar_app/global/responsive/responsive.dart';
import 'package:eventjar_app/model/event_info/event_info_model.dart';
import 'package:eventjar_app/page/event_info/tabs/organizer/organizer_about_page.dart';
import 'package:eventjar_app/page/event_info/tabs/organizer/organizer_company_page.dart';
import 'package:eventjar_app/page/event_info/tabs/organizer/organizer_profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerPage extends StatelessWidget {
  final EventInfoController controller = Get.find();

  OrganizerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final eventInfo = controller.state.eventInfo.value;

      if (eventInfo == null) {
        return const Center(child: Text("No event info available"));
      }

      final organizer = eventInfo.organizer;

      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(4.wp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Organizer Profile Section
              buildOrganizerProfile(organizer),
              SizedBox(height: 3.hp),

              // About Section
              if (organizer.bio != null && organizer.bio!.isNotEmpty) ...[
                _buildCardSection(
                  title: "About Organizer",
                  icon: Icons.info_outline,
                  child: buildAboutSection(organizer.bio!),
                ),
                SizedBox(height: 2.hp),
              ],

              // Company Section
              if (_hasCompanyDetails(organizer, eventInfo)) ...[
                _buildCardSection(
                  title: "Company Details",
                  icon: Icons.business,
                  child: buildCompanySection(organizer, eventInfo),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  // Check if company details are available
  bool _hasCompanyDetails(Organizer organizer, EventInfo eventInfo) {
    return (organizer.company != null && organizer.company!.isNotEmpty) ||
        (eventInfo.organizerContactPhone != null &&
            eventInfo.organizerContactPhone!.isNotEmpty) ||
        (organizer.website != null && organizer.website!.isNotEmpty) ||
        (organizer.linkedin != null && organizer.linkedin!.isNotEmpty);
  }

  // Card Section Wrapper
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

  // Section Title with Icon
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
