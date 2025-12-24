import 'package:eventjar/controller/profile_form/summary/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryFormController extends GetxController {
  var appBarTitle = "Add Contact";
  final state = SummaryFormState();

  final formKey = GlobalKey<FormState>();
}
