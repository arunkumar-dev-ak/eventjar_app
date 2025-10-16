import 'package:eventjar_app/controller/home/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var appBarTitle = "EventJar";
  final state = HomeState();
  final formKey = GlobalKey<FormState>();
  final logoPath = 'assets/app_icon/event_app_icon.png';

  bool get isLoading => state.isLoading.value;

  final _searchBarController = TextEditingController().obs;

  TextEditingController get searchBarController => _searchBarController.value;

  void onInint() {
    super.onInit();
  }

  void handleSearchOnChnage(String text) {
    if (text.isEmpty) {
      state.isSearchEmpty.value = true;
    } else {
      state.isSearchEmpty.value = false;
    }
  }
}
