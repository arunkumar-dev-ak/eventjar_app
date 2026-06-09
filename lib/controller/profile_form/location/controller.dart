import 'package:eventjar/controller/profile_form/location/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationFormController extends GetxController {
  var appBarTitle = "add_contact".tr;
  final state = LocationFormState();

  final formKey = GlobalKey<FormState>();
}
