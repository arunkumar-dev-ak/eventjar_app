import 'package:eventjar/controller/add_contact/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiSelectTagsInput extends StatelessWidget {
  final AddContactController controller = Get.find();

  MultiSelectTagsInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller.tagController,
          decoration: InputDecoration(
            labelText: 'Add new tag',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                final newTag = controller.tagController.text.trim();
                controller.addTag(newTag);
                controller.tagController.clear();
              },
            ),
          ),
          onSubmitted: (val) {
            controller.addTag(val.trim());
            controller.tagController.clear();
          },
        ),
        SizedBox(height: 8),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 6,
            children: controller.state.selectedTags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag,
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 10.sp,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        controller.state.selectedTags.remove(tag);
                      },
                      child: Icon(
                        Icons.cancel,
                        size: 18,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
