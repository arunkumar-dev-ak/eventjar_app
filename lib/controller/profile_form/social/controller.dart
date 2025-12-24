import 'package:eventjar/controller/profile_form/social/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialFormController extends GetxController {
  var appBarTitle = "Add Contact";
  final state = SocialFormState();

  final formKey = GlobalKey<FormState>();
}
