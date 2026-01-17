import 'package:eventjar/controller/qr_add_contact/controller.dart';
import 'package:eventjar/page/qr_add_contact/widget/qr_action_buttons.dart';
import 'package:eventjar/page/qr_add_contact/widget/qr_phone_input.dart';
import 'package:eventjar/page/qr_add_contact/widget/qr_section_label.dart';
import 'package:eventjar/page/qr_add_contact/widget/qr_tag_selector.dart';
import 'package:eventjar/page/qr_add_contact/widget/qr_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrContactForm extends GetView<QrAddContactController> {
  const QrContactForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QrSectionLabel('Name *'),
        const SizedBox(height: 8),
        QrTextField(
          controller: controller.nameController,
          hint: 'Enter full name',
          icon: Icons.person_rounded,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Name is required' : null,
        ),

        const SizedBox(height: 20),
        const QrSectionLabel('Phone Number *'),
        const SizedBox(height: 8),
        QrPhoneInput(
          controller: controller.phoneController,
          countryCode: controller.state.selectedCountryCode,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Phone number is required' : null,
        ),

        const SizedBox(height: 20),
        const QrSectionLabel('Email'),
        const SizedBox(height: 8),
        QrTextField(
          controller: controller.emailController,
          hint: 'Enter email address',
          icon: Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return 'Email is required';
            }
            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            if (!emailRegex.hasMatch(val.trim())) {
              return 'Enter a valid email';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),
        const QrSectionLabel('Tags'),
        const SizedBox(height: 8),
        QrTagInput(),
        const QrSectionLabel('Notes'),
        const SizedBox(height: 8),
        QrTextField(
          controller: controller.notesController,
          hint: 'Add any notes...',
          maxLines: 3,
        ),
        const SizedBox(height: 32),
        const QrActionButtons(),
      ],
    );
  }
}
