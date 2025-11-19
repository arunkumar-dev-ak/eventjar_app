import 'package:eventjar/controller/add_contact/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactStageDropdown extends StatelessWidget {
  final AddContactController controller = Get.find();

  ContactStageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.state.selectedStage.value;

      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 24,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50, // light themed background
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      'Select Stage',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blue.shade700, // theme-customized color
                      ),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    const SizedBox(height: 8),
                    // List of stages with scrolling
                    Expanded(child: _buildStageSelection(context)),
                    const SizedBox(height: 8),
                    // Cancel / Close button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.blue.shade50,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selected['value'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStageSelection(BuildContext context) {
    return Obx(() {
      final stages = controller.state.stages;
      final selectedKey = controller.state.selectedStage.value["key"];

      return ListView.separated(
        padding: const EdgeInsets.only(top: 8),
        shrinkWrap: true,
        itemCount: stages.length,
        separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
        itemBuilder: (_, index) {
          final stage = stages[index];
          final isSelected = stage['key'] == selectedKey;

          return ListTile(
            title: Text(stage['value'] ?? ''),
            trailing: isSelected
                ? Icon(Icons.check_circle, color: Colors.green.shade700)
                : null,
            onTap: () {
              controller.selectStage(stage);
              Navigator.pop(context); // close dialog after selection
            },
          );
        },
      );
    });
  }
}
