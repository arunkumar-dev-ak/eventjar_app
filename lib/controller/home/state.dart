import 'package:eventjar_app/model/home/home_model.dart';
import 'package:eventjar_app/model/meta/meta_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeState {
  RxBool isLoading = false.obs;
  RxBool isFetching = false.obs;

  final isSearchEmpty = true.obs;

  RxInt selectedIndex = 0.obs;

  RxList<Color> dominantColors = <Color>[].obs;

  RxList<Event> events = <Event>[].obs;
  Rxn<Meta> meta = Rxn<Meta>();
}
