import 'package:eventjar/controller/qr_add_contact/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrTagInput extends GetView<QrAddContactController> {
  QrTagInput({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = colorScheme.outline.withAlpha(50);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input field
        TextField(
          controller: controller.tagController,
          decoration: InputDecoration(
            hintText: 'Add tag and press enter',
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withAlpha(30),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.add, color: colorScheme.primary),
              onPressed: () {
                final tag = controller.tagController.text.trim();
                if (tag.isNotEmpty &&
                    !controller.state.selectedTags.contains(tag)) {
                  controller.state.selectedTags.add(tag);
                }
                controller.tagController.clear();
              },
            ),
          ),
          onSubmitted: (value) {
            final tag = value.trim();
            if (tag.isNotEmpty &&
                !controller.state.selectedTags.contains(tag)) {
              controller.state.selectedTags.add(tag);
            }
            controller.tagController.clear();
          },
        ),

        const SizedBox(height: 8),

        // Selected tags
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
                  color: colorScheme.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colorScheme.primary.withAlpha(80)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => controller.state.selectedTags.remove(tag),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: colorScheme.primary,
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
