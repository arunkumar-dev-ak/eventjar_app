import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeState {
  RxBool isLoading = false.obs;

  final isSearchEmpty = true.obs;

  RxInt selectedIndex = 0.obs;

  RxList<Color> dominantColors = <Color>[].obs;
}
