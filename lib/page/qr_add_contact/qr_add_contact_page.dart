import 'package:eventjar/controller/qr_add_contact/controller.dart';
import 'package:eventjar/page/qr_add_contact/widget/qr_add_contact_header.dart';
import 'package:eventjar/page/qr_add_contact/widget/qr_contact_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrAddContactPage extends GetView<QrAddContactController> {
  const QrAddContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QrAddContactHeader(),
              SizedBox(height: 32),
              QrContactForm(),
            ],
          ),
        ),
      ),
    );
  }
}
