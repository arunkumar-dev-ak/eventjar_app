import 'package:eventjar/controller/meeting_preferences/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/meeting_preferences/widget/preferences_dropdown.dart';
import 'package:eventjar/page/meeting_preferences/widget/timezone_search_dropdown.dart';
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
          'Meeting Preferences',
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
              _buildCard(
                context,
                child: TimezoneSearchDropdown(
                  label: 'Timezone',
                  selectedValue: controller.state.selectedTimezone,
                  items: controller.state.timezones,
                  onChanged: controller.updateTimezone,
                ),
              ),
              SizedBox(height: 2.hp),
              _buildCard(
                context,
                child: Row(
                  children: [
                    Expanded(
                      child: PreferencesDropdown(
                        label: 'Slot Interval',
                        selectedValue: controller.state.selectedSlotInterval,
                        items: controller.state.slotIntervals,
                        onChanged: controller.updateSlotInterval,
                      ),
                    ),
                    SizedBox(width: 3.wp),
                    Expanded(
                      child: PreferencesDropdown(
                        label: 'Minimum Notice',
                        selectedValue: controller.state.selectedMinNotice,
                        items: controller.state.minNoticeOptions,
                        onChanged: controller.updateMinNotice,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.hp),
              _buildCard(
                context,
                child: Row(
                  children: [
                    Expanded(
                      child: PreferencesDropdown(
                        label: 'Buffer Before',
                        selectedValue: controller.state.selectedBufferBefore,
                        items: controller.state.bufferOptions,
                        onChanged: controller.updateBufferBefore,
                      ),
                    ),
                    SizedBox(width: 3.wp),
                    Expanded(
                      child: PreferencesDropdown(
                        label: 'Buffer After',
                        selectedValue: controller.state.selectedBufferAfter,
                        items: controller.state.bufferOptions,
                        onChanged: controller.updateBufferAfter,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.hp),
              _buildCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Availability',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
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
            controller.state.isSaving.value ? 'Saving...' : 'Save Preferences',
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
