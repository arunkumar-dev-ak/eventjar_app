import 'package:eventjar/controller/meeting_preferences/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/dropdown/single_selected_dropdown.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/meeting_preferences/widget/preferences_dropdown.dart';
import 'package:eventjar/page/meeting_preferences/widget/weekly_availability_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MeetingPreferencesPage extends GetView<MeetingPreferencesController> {
  const MeetingPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: Text(
          'meeting_preferences'.tr,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appBarGradientFor(context),
          ),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.state.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(4.wp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timezone
              _buildCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'timezone'.tr),
                    SizedBox(height: 1.hp),
                    SingleSelectFilterDropdown<String>(
                      title: 'timezone'.tr,
                      items: controller.state.timezones,
                      selectedItem: controller.state.selectedTimezoneRxn,
                      getDefaultItem: () => 'UTC',
                      getDisplayValue: (tz) => tz.replaceAll('_', ' '),
                      getKeyValue: (tz) => tz,
                      onSelected: controller.updateTimezone,
                      searchable: true,
                      searchHint: 'search_timezone'.tr,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.hp),

              // Slot Interval + Minimum Notice
              _buildCard(
                context,
                child: Row(
                  children: [
                    Expanded(
                      child: PreferencesDropdown(
                        label: 'slot_interval'.tr,
                        selectedValue: controller.state.selectedSlotInterval,
                        items: controller.state.slotIntervals,
                        onChanged: controller.updateSlotInterval,
                      ),
                    ),
                    SizedBox(width: 3.wp),
                    Expanded(
                      child: PreferencesDropdown(
                        label: 'minimum_notice'.tr,
                        selectedValue: controller.state.selectedMinNotice,
                        items: controller.state.minNoticeOptions,
                        onChanged: controller.updateMinNotice,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.hp),

              // Buffers
              _buildCard(
                context,
                child: Row(
                  children: [
                    Expanded(
                      child: PreferencesDropdown(
                        label: 'buffer_before'.tr,
                        selectedValue: controller.state.selectedBufferBefore,
                        items: controller.state.bufferOptions,
                        onChanged: controller.updateBufferBefore,
                      ),
                    ),
                    SizedBox(width: 3.wp),
                    Expanded(
                      child: PreferencesDropdown(
                        label: 'buffer_after'.tr,
                        selectedValue: controller.state.selectedBufferAfter,
                        items: controller.state.bufferOptions,
                        onChanged: controller.updateBufferAfter,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.hp),

              // Max Advance Booking
              _buildCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'max_advance_booking'.tr),
                    SizedBox(height: 1.hp),
                    Obx(() => _buildMaxAdvanceDaysSelector(context)),
                  ],
                ),
              ),
              SizedBox(height: 2.hp),

              // Allowed Durations
              _buildCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'allowed_durations'.tr),
                    SizedBox(height: 1.hp),
                    Obx(() => _buildAllowedDurationsSelector(context)),
                    SizedBox(height: 0.5.hp),
                    Text(
                      'allowed_durations_hint'.tr,
                      style: TextStyle(
                        fontSize: 6.5.sp,
                        color: AppColors.textHint(context),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.hp),

              // Weekly Availability
              _buildCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'weekly_availability'.tr),
                    SizedBox(height: 1.hp),
                    Obx(
                      () => Column(
                        children: List.generate(
                          controller.state.weeklyAvailability.length,
                          (index) => WeeklyAvailabilityItem(
                            index: index,
                            day: controller.state.weeklyAvailability[index],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.hp),
              _buildSaveButton(context),
              SizedBox(height: 2.hp),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 9.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary(context),
      ),
    );
  }

  Widget _buildMaxAdvanceDaysSelector(BuildContext context) {
    final selected = controller.state.selectedMaxAdvanceDays.value;
    final options = controller.state.maxAdvanceDaysOptions;
    return Wrap(
      spacing: 2.wp,
      runSpacing: 1.hp,
      children: options.map((opt) {
        final value = opt['value'] as int;
        final label = opt['label'] as String;
        final isActive = selected == value;
        return GestureDetector(
          onTap: () => controller.updateMaxAdvanceDays(value),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF4A6CF7).withValues(alpha: 0.1)
                  : AppColors.inputBg(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive
                    ? const Color(0xFF4A6CF7)
                    : AppColors.border(context),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? const Color(0xFF4A6CF7)
                    : AppColors.textSecondary(context),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAllowedDurationsSelector(BuildContext context) {
    final selected = controller.state.selectedAllowedDurations;
    final options = controller.state.durationOptions;
    return Wrap(
      spacing: 2.wp,
      runSpacing: 1.hp,
      children: options.map((opt) {
        final mins = opt['value'] as int;
        final label = opt['label'] as String;
        final isActive = selected.contains(mins);
        return GestureDetector(
          onTap: () => controller.toggleDuration(mins),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.wp, vertical: 1.hp),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF4A6CF7).withValues(alpha: 0.1)
                  : AppColors.inputBg(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive
                    ? const Color(0xFF4A6CF7)
                    : AppColors.border(context),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? const Color(0xFF4A6CF7)
                    : AppColors.textSecondary(context),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.wp),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: controller.state.isSaving.value
              ? null
              : controller.savePreferences,
          icon: controller.state.isSaving.value
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.save_rounded, size: 20),
          label: Text(
            controller.state.isSaving.value
                ? 'saving'.tr
                : 'save_preferences'.tr,
            style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w700),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 2.hp),
            backgroundColor: const Color(0xFF4A6CF7),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
      ),
    );
  }
}
