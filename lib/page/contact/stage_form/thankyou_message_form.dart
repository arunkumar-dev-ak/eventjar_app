import 'package:eventjar/controller/contact/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/contact/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThankYouMessagePopup extends StatelessWidget {
  final ContactController controller = Get.find();
  final Contact contact;

  ThankYouMessagePopup({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    controller.contactNameController.text = contact.name;
    controller.contactEmailController.text = contact.email;

    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Form(
        key: controller.thankYouFormKey,
        child: AlertDialog(
          title: Text(
            'Send Thank You Message',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
          ),
          content: SizedBox(
            width: 90.wp,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Readable Contact Info Cards
                  _buildContactInfoCard(
                    icon: Icons.person,
                    title: 'Name',
                    value: contact.name,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 1.hp),
                  _buildContactInfoCard(
                    icon: Icons.email,
                    title: 'Email',
                    value: contact.email,
                    color: Colors.green,
                  ),
                  if (contact.phone != null) ...[
                    SizedBox(height: 1.hp),
                    _buildContactInfoCard(
                      icon: Icons.phone,
                      title: 'Phone',
                      value: contact.phone!,
                      color: Colors.teal,
                    ),
                  ],

                  SizedBox(height: 2.hp),

                  // Card-style Checkboxes
                  Text(
                    'Send via:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 9.sp,
                    ),
                  ),
                  SizedBox(height: 1.hp),

                  // Email Card
                  Obx(
                    () => _buildMethodCard(
                      title: 'Email',
                      icon: Icons.email_outlined,
                      isSelected: controller.state.emailChecked.value,
                      onTap: () => controller.state.emailChecked.value =
                          !controller.state.emailChecked.value,
                    ),
                  ),

                  SizedBox(height: 1.hp),

                  // WhatsApp Card
                  Obx(
                    () => _buildMethodCard(
                      title: 'WhatsApp',
                      icon: Icons.message_outlined,
                      isSelected: controller.state.whatsappChecked.value,
                      onTap: () => controller.state.whatsappChecked.value =
                          !controller.state.whatsappChecked.value,
                    ),
                  ),

                  SizedBox(height: 2.hp),

                  // Message TextField
                  TextFormField(
                    controller: controller.messageController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      hintText: 'Hi [Name],\n\nThank you for connecting...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Message cannot be empty';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                foregroundColor: Colors.black87,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: TextStyle(fontSize: 9.sp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: () => Get.back(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: TextStyle(fontSize: 9.sp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              onPressed: () {
                if (controller.thankYouFormKey.currentState!.validate()) {
                  LoggerService.loggerInstance.dynamic_d(
                    'Sending: ${controller.messageController.text}',
                  );
                  Get.back();
                }
              },
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }

  // Readable Contact Info Card
  Widget _buildContactInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.wp),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.wp),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 2.wp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.hp),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card-style Selection Method
  Widget _buildMethodCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withValues(alpha: 0.08)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Spread children left-right
          children: [
            Row(
              children: [
                Icon(icon, color: isSelected ? Colors.blue : Colors.grey[600]),
                SizedBox(width: 3.wp),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.blue[700] : Colors.grey[700],
                  ),
                ),
              ],
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.blue : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
