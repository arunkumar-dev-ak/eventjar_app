import 'package:eventjar/controller/thank_you_message/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThankYouMessageController extends GetxController {
  var appBarTitle = "Send Thank you Message";
  final state = ThankYouMessageState();

  final formKey = GlobalKey<FormState>();

  //tq form
  final contactNameController = TextEditingController();
  final contactEmailController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void onInit() {
    final args = Get.arguments;
    state.contact.value = args;
    super.onInit();
  }

  void initThankYouData(String name, String email) {
    contactNameController.text = name;
    contactEmailController.text = email;
    messageController.text =
        'Hi $name,\n\nThank you for connecting with us! We\'re excited to work together and will be in touch soon to discuss next steps.\n\nBest regards,\nYour Team';
  }

  Future<void> sendThankYouMessage() async {
    // if (thankYouFormKey.currentState!.validate()) {
    //   state.isLoading.value = true;

    //   try {
    //     // TODO: Implement API call
    //     print('Sending thank you message to ${state.contact.value?.name}');
    //     print('Message: ${messageController.text}');
    //     print('Email: ${state.emailChecked.value}');
    //     print('WhatsApp: ${state.whatsappChecked.value}');

    //     Get.back(result: true); // Return success to parent
    //   } finally {
    //     state.isLoading.value = false;
    //   }
    // }
  }

  void resetForm() {
    state.emailChecked.value = true;
    state.whatsappChecked.value = false;
    messageController.clear();

    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    contactNameController.dispose();
    contactEmailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
