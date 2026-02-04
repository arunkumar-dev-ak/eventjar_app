import 'package:eventjar/controller/schedule_meeting/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/schedule_meeting/schedule_meeting_button.dart';
import 'package:eventjar/page/schedule_meeting/widget/schedule_meeting_message_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleMeetingPage extends GetView<ScheduleMeetingController> {
  const ScheduleMeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.focusScope?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            controller.appBarTitle,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 4,
          backgroundColor: Colors.white,
          shadowColor: Colors.black.withValues(alpha: 0.1),
        ),
        body: Obx(() {
          return Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 4.wp, right: 4.wp, bottom: 4.wp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.hp),

                  // Contact Info Cards
                  _buildContactInfoCard(
                    icon: Icons.person,
                    title: 'Name',
                    value: controller.state.contact.value?.name ?? '',
                    color: Colors.blue,
                  ),
                  SizedBox(height: 1.hp),
                  _buildContactInfoCard(
                    icon: Icons.email,
                    title: 'Email',
                    value: controller.state.contact.value?.email ?? '',
                    color: Colors.green,
                  ),

                  SizedBox(height: 3.hp),

                  // Meeting Date
                  TextFormField(
                    readOnly: true,
                    controller: controller.meetingDateController,
                    decoration: InputDecoration(
                      labelText: 'Meeting Date',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(3.wp),
                    ),
                    onTap: controller.pickMeetingDate,
                  ),

                  SizedBox(height: 2.hp),

                  // Meeting Time
                  TextFormField(
                    readOnly: true,
                    controller: controller.meetingTimeController,
                    decoration: InputDecoration(
                      labelText: 'Meeting Time',
                      suffixIcon: Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(3.wp),
                    ),
                    onTap: controller.pickMeetingTime,
                  ),

                  // Send via section - Updated with config checks
                  SizedBox(height: 3.hp),

                  Text(
                    'Send Invitation via:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(height: 1.5.hp),

                  // ✅ Email Card with Config + Loading
                  Obx(
                    () => scheduleMeetingMessageBuildMethodCard(
                      // Reuse the same widget!
                      title: 'Email',
                      icon: Icons.email_outlined,
                      isSelected: controller.state.meetingEmailChecked.value,
                      isDisabled: !controller.canSendEmail,
                      isLoading: controller.state.configLoading.value,
                      badgeText: controller.canSendEmail
                          ? null
                          : 'Not Configured',
                      onTap: controller.canSendEmail
                          ? () => controller.toggleMeetingEmail()
                          : null,
                    ),
                  ),

                  SizedBox(height: 1.5.hp),

                  // ✅ WhatsApp Card with Config + Loading
                  Obx(
                    () => scheduleMeetingMessageBuildMethodCard(
                      title: 'WhatsApp',
                      icon: Icons.message_outlined,
                      isSelected: controller.state.meetingWhatsappChecked.value,
                      isDisabled: !controller.canSendWhatsApp,
                      isLoading: controller.state.configLoading.value,
                      badgeText: controller.canSendWhatsApp
                          ? null
                          : 'Not Configured',
                      onTap: controller.canSendWhatsApp
                          ? () => controller.toggleMeetingWhatsApp()
                          : null,
                    ),
                  ),

                  SizedBox(height: 4.hp),

                  // Action Buttons
                  ScheduleMeetingActionButtons(controller: controller),
                  SizedBox(height: 2.hp),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContactInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.wp),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.wp),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 2.wp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.hp),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
