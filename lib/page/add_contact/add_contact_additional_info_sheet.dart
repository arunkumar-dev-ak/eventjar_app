import 'package:eventjar/controller/add_contact/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddContactAdditionalInfoSheet extends GetView<AddContactController> {
  const AddContactAdditionalInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 4.wp,
        right: 4.wp,
        top: 3.hp,
        bottom: MediaQuery.of(context).viewInsets.bottom + 3.hp,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.hp),
            Text(
              'Additional Info from Card',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 0.5.hp),
            Text(
              'Check the fields you want to save with this contact.',
              style: TextStyle(fontSize: 9.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 2.hp),

            _AdditionalField(
              fieldKey: 'phone2',
              label: 'Phone 2',
              icon: Icons.phone_outlined,
              textController: controller.phone2Controller,
              keyboardType: TextInputType.phone,
            ),
            _AdditionalField(
              fieldKey: 'company',
              label: 'Company',
              icon: Icons.business_outlined,
              textController: controller.companyController,
            ),
            _AdditionalField(
              fieldKey: 'website',
              label: 'Website',
              icon: Icons.language_outlined,
              textController: controller.websiteController,
              keyboardType: TextInputType.url,
            ),
            _AdditionalField(
              fieldKey: 'address',
              label: 'Address',
              icon: Icons.location_on_outlined,
              textController: controller.addressController,
              maxLines: 2,
            ),

            SizedBox(height: 2.hp),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.8.hp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  elevation: 4,
                ),
                child: Text(
                  'Apply',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdditionalField extends GetView<AddContactController> {
  final String fieldKey;
  final String label;
  final IconData icon;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final int maxLines;

  const _AdditionalField({
    required this.fieldKey,
    required this.label,
    required this.icon,
    required this.textController,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isChecked =
          controller.state.additionalInfoSelection[fieldKey] ?? false;
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isChecked ? Colors.blue.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isChecked ? Colors.blue.shade200 : Colors.grey.shade200,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Checkbox(
                value: isChecked,
                activeColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (_) => controller.toggleAdditionalField(fieldKey),
              ),
            ),
            // Icon + field
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: textController,
                      keyboardType: keyboardType,
                      maxLines: maxLines,
                      style: TextStyle(fontSize: 9.5.sp),
                      onTap: () {
                        // Auto-check when user taps the field
                        if (!(controller
                                .state
                                .additionalInfoSelection[fieldKey] ??
                            false)) {
                          controller.toggleAdditionalField(fieldKey);
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: 'Enter $label',
                        hintStyle: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.grey[400],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.blue.shade400,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
