import 'package:eventjar/controller/profile_form/networking/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkingFormController extends GetxController {
  var appBarTitle = "Add Contact";
  final state = NetworkingFormState();

  final formKey = GlobalKey<FormState>();
}
