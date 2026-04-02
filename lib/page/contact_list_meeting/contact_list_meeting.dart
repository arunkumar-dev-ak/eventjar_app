import 'package:eventjar/controller/contact_list_meeting/controller.dart';
import 'package:eventjar/controller/contact_list_meeting/state.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/global/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactListMeetingPage extends GetView<ContactListMeetingController> {
  const ContactListMeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.focusScope?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Obx(
            () => Text(
              controller.state.appBarTitle.value,
              style: TextStyle(color: AppColors.textPrimary(context)),
            ),
          ),
          centerTitle: false,
          iconTheme: IconThemeData(color: AppColors.textPrimary(context)),
          elevation: 4,
          backgroundColor: AppColors.cardBg(context),
          shadowColor: Colors.black.withValues(alpha: 0.1),
        ),
        body: Obx(() {
          // if (controller.state.isShimmerLoading.value) {
          //   return const ContactListShimmerLoading();
          // }

          if (controller.state.currentMeeting.value == null) {
            return const Center(child: Text('No meetings found'));
          }

          return _buildMeetingContent();
        }),
      ),
    );
  }

  Widget _buildMeetingContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.wp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact Info Card
          _buildContactCard(),

          SizedBox(height: 2.hp),

          // Meeting Details Card
          _buildMeetingDetailsCard(),
          SizedBox(height: 2.hp),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(2.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBgStatic,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, color: Colors.blue, size: 24),
              ),
              SizedBox(width: 3.wp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        controller.state.mobileContact.value?.name ?? '',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.state.mobileContact.value!.email,
                        style: TextStyle(
                          color: AppColors.textSecondaryStatic,
                          fontSize: 8.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingDetailsCard() {
    final meeting = controller.state.currentMeeting.value;
    final method = meeting?.method;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(2.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBgStatic,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meeting Details',
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 2.hp),
          _buildDetailRow(
            Icons.calendar_today,
            'Date',
            controller.formattedDate,
          ),
          _buildDetailRow(Icons.access_time, 'Time', controller.formattedTime),
          _buildDetailRow(
            Icons.email,
            'Method',
            method == 'both'
                ? 'Email, Whatsapp'
                : (method != null ? capitalize(method) : ''),
          ),
          if (controller.state.currentMeeting.value?.notes != null) ...[
            SizedBox(height: 2.hp),
            ExpansionTile(
              leading: Container(
                padding: EdgeInsets.all(1.wp),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(1.wp),
                ),
                child: Icon(
                  Icons.notes_outlined,
                  color: Colors.orange[700],
                  size: 15.sp,
                ),
              ),
              tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              title: Text(
                'Notes ',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryStatic,
                ),
              ),
              childrenPadding: EdgeInsets.all(3.wp),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.wp),
                side: BorderSide(color: AppColors.dividerStatic),
              ),
              backgroundColor: AppColors.scaffoldBgStatic,
              collapsedBackgroundColor: Colors.transparent,
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.wp),
                side: BorderSide(color: AppColors.dividerStatic),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.wp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.wp),
                    border: Border.all(color: AppColors.chipBgStatic),
                  ),
                  child: Text(
                    controller.state.currentMeeting.value!.notes!,
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: AppColors.textSecondaryStatic,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondaryStatic),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              color: AppColors.textSecondaryStatic,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 9.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Primary Button
        Obx(() {
          final buttonType = controller.state.primaryButtonType.value;
          return SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.state.isLoading.value
                  ? null
                  : _getButtonAction(buttonType),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: controller.state.isLoading.value ? 0 : 2,
              ),
              child: controller.state.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                        strokeCap: StrokeCap.round,
                      ),
                    )
                  : Text(
                      _getButtonText(buttonType),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          );
        }),

        const SizedBox(height: 12),

        // Secondary Button (Reschedule) - Only for SCHEDULED
        Obx(
          () =>
              controller.state.primaryButtonType.value ==
                  MeetingButtonType.accept
              ? SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: controller.state.isLoading.value
                        ? null
                        : controller.onRescheduleMeeting,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.borderStatic, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Reschedule',
                      style: TextStyle(
                        color: AppColors.textSecondaryStatic,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  VoidCallback? _getButtonAction(MeetingButtonType type) {
    switch (type) {
      case MeetingButtonType.accept:
        return () => controller.onAcceptMeeting(
          controller.state.currentMeeting.value!.id,
        );
      case MeetingButtonType.complete:
        return () => controller.onCompleteMeeting(
          controller.state.currentMeeting.value!.id,
        );
      case MeetingButtonType.reschedule:
        return controller.onRescheduleMeeting;
    }
  }

  String _getButtonText(MeetingButtonType type) {
    switch (type) {
      case MeetingButtonType.accept:
        return 'Accept Meeting';
      case MeetingButtonType.complete:
        return 'Mark Complete';
      case MeetingButtonType.reschedule:
        return 'Reschedule';
    }
  }
}
