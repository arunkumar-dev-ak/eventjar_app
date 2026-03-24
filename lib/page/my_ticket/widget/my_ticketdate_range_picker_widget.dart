import 'package:eventjar/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTicketDateRangePickerWidget {
  static Future<DateTimeRange?> show({
    required DateTimeRange? initialRange,
    required int selectedTab,
  }) async {
    DateTimeRange? result = initialRange;

    await showDateRangePicker(
      context: Get.context!,
      firstDate: selectedTab == 0 ? DateTime.now() : DateTime(2020),
      lastDate: selectedTab == 1 ? DateTime.now() : DateTime(2035),
      initialDateRange: initialRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: AppColors.gradientDarkStart,
              onSurface: Colors.black87,
              onPrimary: Colors.white,
            ),
          ),
          child: Stack(
            children: [
              child!,
              Positioned(
                bottom: 20,
                right: 16,
                child: SafeArea(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      result = null;
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close, size: 15),
                    label: const Text('Clear Filter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red.shade700,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: const StadiumBorder(),
                      side: BorderSide(color: Colors.red.shade200),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((picked) {
      if (picked != null) result = picked; // normal selection
    });

    return result;
  }
}
