import 'package:eventjar/controller/scheduler/controller.dart';
import 'package:eventjar/global/dropdown/single_selected_dropdown.dart';
import 'package:eventjar/model/contact-meeting/contact_meeting_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchedulerStatusDropdown extends StatelessWidget {
  const SchedulerStatusDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SchedulerController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status *',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        SingleSelectFilterDropdown<MeetingStatusForReschedule>(
          title: "Select Status",
          items: MeetingStatusForReschedule.values,
          selectedItem: controller.state.selectedStatus,
          getDefaultItem: () => MeetingStatusForReschedule.SCHEDULED,
          getDisplayValue: (MeetingStatusForReschedule status) =>
              status.displayName,
          getKeyValue: (MeetingStatusForReschedule status) => status,
          onSelected: (MeetingStatusForReschedule status) {
            controller.state.selectedStatus.value = status;
          },
          hintText: "Select status",
        ),
      ],
    );
  }
}
