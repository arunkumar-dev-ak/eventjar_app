import 'package:eventjar/controller/profile_form/business_info/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessInfoFormController extends GetxController {
  var appBarTitle = "Add Contact";
  final state = BusinessInfoFormState();

  final formKey = GlobalKey<FormState>();
}
