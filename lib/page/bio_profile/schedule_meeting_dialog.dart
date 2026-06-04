import 'package:eventjar/controller/bio_profile/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/app_snackbar.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScheduleMeetingDialog extends StatelessWidget {
  final String name;
  final String position;
  final String company;

  const ScheduleMeetingDialog({
    super.key,
    required this.name,
    required this.position,
    required this.company,
  });

  static Future<void> show(
    BuildContext context, {
    required String name,
    required String position,
    required String company,
  }) {
    final controller = Get.find<BioProfileController>();
    controller.resetMeetingForm();
    return showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => ScheduleMeetingDialog(
        name: name,
        position: position,
        company: company,
      ),
    );
  }

  static const _durations = ['15m', '30m', '45m', '1hr'];
  static const _gradientColors = [
    AppColors.gradientDarkStart,
    AppColors.gradientLightStart,
  ];

  String get _firstName => name.split(' ').first;

  Future<void> _pickDate(BuildContext context) async {
    final controller = Get.find<BioProfileController>();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.state.meetingDate.value ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(
            ctx,
          ).colorScheme.copyWith(primary: AppColors.gradientDarkStart),
        ),
        child: child!,
      ),
    );
    if (picked != null) controller.state.meetingDate.value = picked;
  }

  Future<void> _pickTime(BuildContext context) async {
    final controller = Get.find<BioProfileController>();
    final picked = await showTimePicker(
      context: context,
      initialTime: controller.state.meetingTime.value ?? TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(
            ctx,
          ).colorScheme.copyWith(primary: AppColors.gradientDarkStart),
        ),
        child: child!,
      ),
    );
    if (picked != null) controller.state.meetingTime.value = picked;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5.wp, vertical: 3.hp),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Padding(
              padding: EdgeInsets.all(5.wp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateTimeRow(context),
                  SizedBox(height: 2.hp),
                  _buildDurationSelector(context),
                  SizedBox(height: 2.hp),
                  _buildMessageField(context),
                  SizedBox(height: 2.5.hp),
                  _buildConfirmButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 3.hp, bottom: 2.hp),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: _gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white70, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Text(
                      _getInitials(name),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: _gradientColors[0],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.2.hp),
                Text(
                  'Schedule a Meeting',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'with $name',
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$position at $company',
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeRow(BuildContext context) {
    final controller = Get.find<BioProfileController>();
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => _buildPickerField(
              context,
              icon: Icons.calendar_month_outlined,
              label: 'date'.tr,
              value: controller.state.meetingDate.value != null
                  ? DateFormat(
                      'dd/MM/yyyy',
                    ).format(controller.state.meetingDate.value!)
                  : null,
              placeholder: 'dd/mm/yyyy',
              onTap: () => _pickDate(context),
            ),
          ),
        ),
        SizedBox(width: 3.wp),
        Expanded(
          child: Obx(
            () => _buildPickerField(
              context,
              icon: Icons.access_time_outlined,
              label: 'time'.tr,
              value: controller.state.meetingTime.value?.format(context),
              placeholder: '--:--',
              onTap: () => _pickTime(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPickerField(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String? value,
    required String placeholder,
    required VoidCallback onTap,
  }) {
    final hasValue = value != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.gradientDarkStart),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.gradientDarkStart,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.2.hp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: hasValue
                    ? AppColors.gradientDarkStart
                    : AppColors.divider(context),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? placeholder,
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      color: hasValue
                          ? AppColors.textPrimary(context)
                          : AppColors.textHint(context),
                    ),
                  ),
                ),
                Icon(icon, size: 18, color: AppColors.textSecondary(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSelector(BuildContext context) {
    final controller = Get.find<BioProfileController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.timer_outlined,
              size: 16,
              color: AppColors.gradientDarkStart,
            ),
            const SizedBox(width: 6),
            Text(
              'duration'.tr,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.gradientDarkStart,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(
          () => Row(
            children: List.generate(_durations.length, (i) {
              final selected = i == controller.state.meetingDurationIndex.value;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.state.meetingDurationIndex.value = i,
                  child: Container(
                    margin: EdgeInsets.only(
                      right: i < _durations.length - 1 ? 8 : 0,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1.hp),
                    decoration: BoxDecoration(
                      color: selected
                          ? _gradientColors[0].withValues(alpha: 0.1)
                          : null,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? _gradientColors[0]
                            : AppColors.divider(context),
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _durations[i],
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: selected
                              ? _gradientColors[0]
                              : AppColors.textSecondary(context),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageField(BuildContext context) {
    final controller = Get.find<BioProfileController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 16,
              color: AppColors.gradientDarkStart,
            ),
            const SizedBox(width: 6),
            Text(
              'Message for $_firstName',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.gradientDarkStart,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '(optional)',
              style: TextStyle(
                fontSize: 8.sp,
                color: AppColors.textHint(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.notesController,
          maxLines: 3,
          maxLength: 1000,
          decoration: InputDecoration(
            hintText: 'Hi $_firstName, I\'d like to connect about...',
            hintStyle: TextStyle(
              fontSize: 9.5.sp,
              color: AppColors.textHint(context),
            ),
            counterText: '',
            contentPadding: EdgeInsets.symmetric(
              horizontal: 3.wp,
              vertical: 1.2.hp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.divider(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.divider(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.gradientDarkStart),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    final controller = Get.find<BioProfileController>();
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: controller.state.isMeetingSubmitting.value
              ? null
              : () async {
                  if (controller.state.meetingDate.value == null ||
                      controller.state.meetingTime.value == null) {
                    AppSnackbar.warning(
                      message: 'select_date_and_time_error'.tr,
                    );
                    return;
                  }
                  final success = await controller.submitMeeting();
                  if (success) {
                    Get.back();
                    AppSnackbar.success(
                      title: 'meeting_scheduled'.tr,
                      message: 'meeting_request_sent'.tr,
                    );
                  } else {
                    AppSnackbar.error(
                      message: 'could_not_schedule_meeting'.tr,
                    );
                  }
                },
          icon: controller.state.isMeetingSubmitting.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.calendar_month_outlined, size: 20),
          label: Text(
            controller.state.isMeetingSubmitting.value
                ? 'Submitting...'
                : 'Confirm Meeting',
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _gradientColors[0],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
