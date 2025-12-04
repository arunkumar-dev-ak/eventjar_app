import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QualifyLeadPopup extends StatelessWidget {
  final ContactController controller = Get.find();

  QualifyLeadPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.qualifyFormKey,
      child: AlertDialog(
        title: const Text('Qualify Lead'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lead Score
              TextFormField(
                controller: controller.leadScoreController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                decoration: const InputDecoration(
                  labelText: 'Lead Score (0-10)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter lead score';
                  }
                  final score = int.tryParse(value);
                  if (score == null || score < 0 || score > 10) {
                    return 'Score must be 0-10';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Interest / Needs
              TextFormField(
                controller: controller.interestNeedsController,
                decoration: const InputDecoration(
                  labelText: 'Interest / Needs',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Decision Timeline
              TextFormField(
                controller: controller.decisionTimelineController,
                decoration: const InputDecoration(
                  labelText: 'Decision Timeline',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Qualification Notes
              TextFormField(
                controller: controller.qualificationNotesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Qualification Notes',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.qualifyFormKey.currentState!.validate()) {
                LoggerService.loggerInstance.dynamic_d(
                  'Qualifying lead with score: ${controller.leadScoreController.text}',
                );
                Get.back();
              }
            },
            child: const Text('Qualify Lead'),
          ),
        ],
      ),
    );
  }
}
