import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingPopup extends StatelessWidget {
  final ContactController controller = Get.find();

  MeetingPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.meetingFormKey,
      child: AlertDialog(
        title: const Text('Schedule Meeting'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Meeting Date
              TextFormField(
                readOnly: true,
                controller: controller.meetingDateController,
                decoration: const InputDecoration(
                  labelText: 'Meeting Date',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: Get.context!,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    controller.updateMeetingDateTime(picked);
                  }
                },
              ),

              const SizedBox(height: 16),

              // Meeting Time
              TextFormField(
                readOnly: true,
                controller: controller.meetingTimeController,
                decoration: const InputDecoration(
                  labelText: 'Meeting Time',
                  suffixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: Get.context!,
                    initialTime: TimeOfDay.now(),
                  );

                  if (picked != null) {
                    final now = DateTime.now();
                    controller.updateMeetingDateTime(
                      DateTime(
                        now.year,
                        now.month,
                        now.day,
                        picked.hour,
                        picked.minute,
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 16),

              // Email Checkbox
              Obx(
                () => CheckboxListTile(
                  title: const Text('Send Email'),
                  value: controller.state.meetingEmailChecked.value,
                  onChanged: (val) =>
                      controller.state.meetingEmailChecked.value = val ?? false,
                ),
              ),

              // WhatsApp Checkbox
              Obx(
                () => CheckboxListTile(
                  title: const Text('Send WhatsApp Message'),
                  value: controller.state.meetingWhatsappChecked.value,
                  onChanged: (val) =>
                      controller.state.meetingWhatsappChecked.value =
                          val ?? false,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.meetingFormKey.currentState!.validate()) {
                LoggerService.loggerInstance.dynamic_d(
                  'Scheduling meeting at ${controller.meetingDateController.text}',
                );
                Get.back();
              }
            },
            child: const Text('Schedule Meeting'),
          ),
        ],
      ),
    );
  }
}
