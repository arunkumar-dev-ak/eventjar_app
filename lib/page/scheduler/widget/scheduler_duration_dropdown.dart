import 'package:eventjar/controller/scheduler/controller.dart';
import 'package:eventjar/global/dropdown/single_selected_dropdown.dart';
import 'package:eventjar/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchedulerDurationDropdown extends StatelessWidget {
  const SchedulerDurationDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SchedulerController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration *',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        SingleSelectFilterDropdown<Map<String, String>>(
          title: "Select Duration",
          items: controller.state.durations,
          selectedItem: controller.state.selectedDurationMap,
          getDefaultItem: () => controller.state.durations.first,
          getDisplayValue: (item) => item['value']!,
          getKeyValue: (item) => item,
          onSelected: (duration) {
            return controller.selectDuration(duration);
          },
          hintText: "Select duration",
        ),
      ],
    );
  }
}
