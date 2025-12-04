import 'package:eventjar/controller/qualify_lead/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QualifyLeadController extends GetxController {
  var appBarTitle = "Add Contact";
  final state = QualifyLeadState();

  final formKey = GlobalKey<FormState>();
}
