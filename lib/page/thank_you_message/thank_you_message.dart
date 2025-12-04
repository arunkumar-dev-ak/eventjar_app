import 'package:eventjar/controller/thank_you_message/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/thank_you_message/thank_you_message_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThankYouMessagePage extends GetView<ThankYouMessageController> {
  const ThankYouMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.focusScope?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            controller.appBarTitle,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 4,
          backgroundColor: Colors.white,
          shadowColor: Colors.black.withValues(alpha: 0.1),
        ),
        body: Obx(() {
          return Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 4.wp, right: 4.wp, bottom: 4.wp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.hp),

                  // Contact Info Cards
                  _buildContactInfoCard(
                    icon: Icons.person,
                    title: 'Name',
                    value: controller.state.contact.value?.name ?? '',
                    color: Colors.blue,
                  ),
                  SizedBox(height: 1.hp),
                  _buildContactInfoCard(
                    icon: Icons.email,
                    title: 'Email',
                    value: controller.state.contact.value?.email ?? '',
                    color: Colors.green,
                  ),
                  if (controller.state.contact.value?.phone != null) ...[
                    SizedBox(height: 1.hp),
                    _buildContactInfoCard(
                      icon: Icons.phone,
                      title: 'Phone',
                      value: controller.state.contact.value!.phone!,
                      color: Colors.teal,
                    ),
                  ],

                  SizedBox(height: 3.hp),

                  // Send via section
                  Text(
                    'Send via:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(height: 1.5.hp),

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

                  SizedBox(height: 1.5.hp),

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

                  SizedBox(height: 3.hp),

                  // Message TextField
                  TextFormField(
                    controller: controller.messageController,
                    maxLines: 8,
                    minLines: 4,
                    expands: false,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      hintText: 'Hi [Name],\n\nThank you for connecting...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(3.wp),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Message cannot be empty';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 4.hp),

                  // Action Buttons
                  ThankYouMessageActionButtons(controller: controller),

                  SizedBox(height: 2.hp),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

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
        padding: EdgeInsets.all(4.wp),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
