import 'package:eventjar/controller/meeting_preferences/controller.dart';
import 'package:eventjar/global/app_colors.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HolidayImportDialog extends StatelessWidget {
  const HolidayImportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MeetingPreferencesController>();
    final currentYear = DateTime.now().year;
    final years = [currentYear, currentYear + 1];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.cardBg(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 70.hp),
        child: Padding(
          padding: EdgeInsets.all(4.wp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'import_holidays'.tr,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                ),
              ),
              SizedBox(height: 0.5.hp),
              Text(
                'import_holidays_hint'.tr,
                style: TextStyle(
                  fontSize: 7.sp,
                  color: AppColors.textSecondary(context),
                ),
              ),
              SizedBox(height: 2.hp),
              Obx(() {
                if (controller.state.isLoadingCountries.value) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.hp),
                    child: const Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Obx(() {
                      final countries = controller.state.holidayCountries;
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.wp),
                        decoration: BoxDecoration(
                          color: AppColors.inputBg(context),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border(context)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.state.selectedCountryCode.value.isEmpty
                                ? null
                                : controller.state.selectedCountryCode.value,
                            isExpanded: true,
                            hint: Text(
                              'select_country'.tr,
                              style: TextStyle(fontSize: 8.sp),
                            ),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.iconMuted(context),
                            ),
                            dropdownColor: AppColors.cardBg(context),
                            style: TextStyle(
                              fontSize: 8.sp,
                              color: AppColors.textPrimary(context),
                            ),
                            items: countries.map((c) {
                              return DropdownMenuItem<String>(
                                value: c.code,
                                child: Text(c.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.state.selectedCountryCode.value = value;
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(width: 2.wp),
                  Expanded(
                    child: Obx(() {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.wp),
                        decoration: BoxDecoration(
                          color: AppColors.inputBg(context),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border(context)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: controller.state.selectedHolidayYear.value,
                            isExpanded: true,
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.iconMuted(context),
                            ),
                            dropdownColor: AppColors.cardBg(context),
                            style: TextStyle(
                              fontSize: 8.sp,
                              color: AppColors.textPrimary(context),
                            ),
                            items: years.map((y) {
                              return DropdownMenuItem<int>(
                                value: y,
                                child: Text('$y'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.state.selectedHolidayYear.value = value;
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 1.5.hp),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.fetchHolidays,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6CF7),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.2.hp),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'fetch_holidays'.tr,
                    style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: 1.5.hp),
              Obx(() {
                if (controller.state.isLoadingHolidays.value) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.hp),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                final holidays = controller.state.holidays;
                if (holidays.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.hp),
                    child: Center(
                      child: Text(
                        'no_holidays_found'.tr,
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: AppColors.textHint(context),
                        ),
                      ),
                    ),
                  );
                }

                final existingDates = controller.state.dateOverrides
                    .map((o) => o.date)
                    .toSet();

                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${holidays.length} ${'holidays'.tr}',
                            style: TextStyle(
                              fontSize: 7.sp,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                          TextButton(
                            onPressed: controller.selectAllHolidays,
                            child: Text(
                              'select_all'.tr,
                              style: TextStyle(fontSize: 7.sp),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: holidays.length,
                          itemBuilder: (context, index) {
                            final holiday = holidays[index];
                            final alreadyAdded = existingDates.contains(holiday.date);
                            return Obx(() {
                              final isSelected = controller.state.selectedHolidayDates
                                  .contains(holiday.date);
                              return ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 1.wp),
                                leading: alreadyAdded
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 5.wp,
                                      )
                                    : Checkbox(
                                        value: isSelected,
                                        onChanged: alreadyAdded
                                            ? null
                                            : (_) => controller.toggleHolidaySelection(holiday.date),
                                        activeColor: const Color(0xFF4A6CF7),
                                      ),
                                title: Text(
                                  holiday.name,
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                                subtitle: Text(
                                  holiday.date,
                                  style: TextStyle(
                                    fontSize: 7.sp,
                                    color: AppColors.textSecondary(context),
                                  ),
                                ),
                                trailing: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.wp,
                                    vertical: 0.3.hp,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.inputBg(context),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    holiday.type,
                                    style: TextStyle(
                                      fontSize: 6.sp,
                                      color: AppColors.textSecondary(context),
                                    ),
                                  ),
                                ),
                                onTap: alreadyAdded
                                    ? null
                                    : () => controller.toggleHolidaySelection(holiday.date),
                              );
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 1.hp),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.2.hp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'cancel'.tr,
                        style: TextStyle(fontSize: 8.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.wp),
                  Expanded(
                    child: Obx(() {
                      final count = controller.state.selectedHolidayDates.length;
                      return ElevatedButton(
                        onPressed: count > 0
                            ? () {
                                controller.importSelectedHolidays();
                                Navigator.pop(context);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A6CF7),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 1.2.hp),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          count > 0 ? '${'add'.tr} ($count)' : 'add'.tr,
                          style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w600),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
