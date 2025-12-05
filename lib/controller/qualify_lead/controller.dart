import 'package:eventjar/controller/qualify_lead/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QualifyLeadController extends GetxController {
  var appBarTitle = "Qualify Lead";
  final state = QualifyLeadState();

  final formKey = GlobalKey<FormState>();

  TextEditingController leadScoreController = TextEditingController();
  TextEditingController interestNeedsController = TextEditingController();
  TextEditingController decisionTimelineController = TextEditingController();
  TextEditingController qualificationNotesController = TextEditingController();

  @override
  void onInit() {
    final args = Get.arguments;
    state.contact.value = args;
    super.onInit();
  }

  // Validate lead score
  bool get isLeadScoreValid {
    if (leadScoreController.text.isEmpty) return false;
    final score = int.tryParse(leadScoreController.text);
    return score != null && score >= 0 && score <= 10;
  }

  // Qualify lead
  Future<void> qualifyLead() async {
    // if (qualifyFormKey.currentState!.validate()) {
    //   state.isLoading.value = true;

    //   try {
    //     // TODO: Implement API call
    //     print('Qualifying lead: ${state.contact.value?.name}');
    //     print('Score: ${leadScoreController.text}');
    //     print('Interest/Needs: ${interestNeedsController.text}');
    //     print('Timeline: ${decisionTimelineController.text}');
    //     print('Notes: ${qualificationNotesController.text}');

    //     Get.back(
    //       result: {
    //         'leadScore': leadScoreController.text,
    //         'interestNeeds': interestNeedsController.text,
    //         'decisionTimeline': decisionTimelineController.text,
    //         'qualificationNotes': qualificationNotesController.text,
    //       },
    //     );
    //   } finally {
    //     state.isLoading.value = false;
    //   }
    // }
  }

  void resetForm() {
    leadScoreController.clear();
    interestNeedsController.clear();
    decisionTimelineController.clear();
    qualificationNotesController.clear();

    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    leadScoreController.dispose();
    interestNeedsController.dispose();
    decisionTimelineController.dispose();
    qualificationNotesController.dispose();
    super.onClose();
  }
}
