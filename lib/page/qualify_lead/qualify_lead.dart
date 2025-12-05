import 'package:eventjar/controller/qualify_lead/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/qualify_lead/qualify_lead_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QualifyLeadPage extends GetView<QualifyLeadController> {
  const QualifyLeadPage({super.key});

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

                  SizedBox(height: 3.hp),

                  // Lead Score
                  TextFormField(
                    controller: controller.leadScoreController,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    decoration: InputDecoration(
                      labelText: 'Lead Score (0-10)',
                      hintText: 'Enter score between 0-10',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(3.wp),
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

                  SizedBox(height: 2.hp),

                  // Interest / Needs
                  TextFormField(
                    controller: controller.interestNeedsController,
                    decoration: InputDecoration(
                      labelText: 'Interest / Needs',
                      hintText: 'What are they interested in?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(3.wp),
                    ),
                  ),

                  SizedBox(height: 2.hp),

                  // Decision Timeline
                  TextFormField(
                    controller: controller.decisionTimelineController,
                    decoration: InputDecoration(
                      labelText: 'Decision Timeline',
                      hintText: 'Expected decision date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(3.wp),
                    ),
                  ),

                  SizedBox(height: 2.hp),

                  // Qualification Notes
                  TextFormField(
                    controller: controller.qualificationNotesController,
                    maxLines: 4,
                    minLines: 2,
                    expands: false,
                    decoration: InputDecoration(
                      labelText: 'Qualification Notes',
                      hintText: 'Additional qualification details...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(3.wp),
                    ),
                  ),

                  SizedBox(height: 4.hp),

                  // Action Buttons
                  QualifyLeadActionButtons(controller: controller),
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
}
