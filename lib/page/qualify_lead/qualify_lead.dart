import 'package:eventjar/controller/qualify_lead/controller.dart';
import 'package:eventjar/global/responsive/responsive.dart';
import 'package:eventjar/page/qualify_lead/qualify_lead_button.dart';
import 'package:eventjar/page/qualify_lead/qualify_lead_info_card.dart';
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
            style: const TextStyle(color: Colors.black),
          ),
          centerTitle: false,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 4,
          backgroundColor: Colors.white,
          shadowColor: Colors.black.withValues(alpha: 0.1),
        ),
        body: Obx(
          () => Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 4.wp, right: 4.wp, bottom: 4.wp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.hp),

                  // Contact Info Cards
                  buildLeadCard(
                    icon: Icons.person,
                    title: 'Name',
                    value: controller.state.contact.value?.name ?? '',
                    color: Colors.blue,
                  ),
                  SizedBox(height: 1.hp),
                  buildLeadCard(
                    icon: Icons.email,
                    title: 'Email',
                    value: controller.state.contact.value?.email ?? '',
                    color: Colors.green,
                  ),

                  SizedBox(height: 3.hp),

                  // Common TextFormFields
                  _buildSectionTitle('Lead Score'),
                  SizedBox(height: 0.5.hp),
                  qualifyLeadTextField(
                    controller: controller.leadScoreController,
                    label: 'Lead Score (1-10)',
                    prefixIcon: Icons.star,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter lead score';
                      }
                      final score = int.tryParse(value);
                      if (score == null || score < 1 || score > 10) {
                        return 'Score must be 1-10';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: 2.hp),
                  _buildSectionTitle('Qualification Details'),
                  SizedBox(height: 0.5.hp),

                  qualifyLeadTextField(
                    controller: controller.interestsController,
                    label: 'Interests/Needs',
                    prefixIcon: Icons.lightbulb_outline,
                    maxLines: 3,
                    minLines: 1,
                  ),

                  SizedBox(height: 2.hp),
                  qualifyLeadTextField(
                    controller: controller.budgetController,
                    label: 'Budget Range',
                    prefixIcon: Icons.attach_money,
                  ),

                  SizedBox(height: 2.hp),
                  qualifyLeadTextField(
                    controller: controller.timelineController,
                    label: 'Decision Timeline',
                    prefixIcon: Icons.schedule,
                  ),

                  SizedBox(height: 2.hp),
                  qualifyLeadTextField(
                    controller: controller.notesController,
                    label: 'Qualification Notes',
                    maxLines: 4,
                    minLines: 2,
                  ),

                  SizedBox(height: 4.hp),
                  QualifyLeadActionButtons(controller: controller),
                  SizedBox(height: 2.hp),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.wp, vertical: 1.hp),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
