import 'package:eventjar/controller/qr_add_contact/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrActionButtons extends GetView<QrAddContactController> {
  const QrActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final defaultFontSize = 14.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// CLEAR BUTTON
        Expanded(
          child: OutlinedButton(
            onPressed: controller.clearForm,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: colorScheme.primary, width: 1.8),
              foregroundColor: colorScheme.primary,
              backgroundColor: colorScheme.surface,
            ),
            child: Text(
              'Clear',
              style: TextStyle(
                fontSize: defaultFontSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // SAVE BUTTON
        Expanded(
          child: Obx(() {
            final isLoading = controller.state.isLoading.value;

            return ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      Get.focusScope?.unfocus();
                      controller.submitForm(context);
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Save Contact',
                      style: TextStyle(
                        fontSize: defaultFontSize,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
            );
          }),
        ),
      ],
    );
  }
}
