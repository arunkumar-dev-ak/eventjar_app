import 'package:eventjar/model/meta/mobile_meta_model.dart';
import 'package:eventjar/model/my_ticket/my_ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTicketsState {
  final RxList<MyTicket> tickets = <MyTicket>[].obs;
  final Rx<MobileMeta?> pagination = Rx<MobileMeta?>(null);

  final Rxn<DateTimeRange> selectedDateRange = Rxn();

  final RxBool showFilters = false.obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;

  final RxSet<int> expandedTickets = <int>{}.obs;

  final selectedTab = 0.obs;
  final searchQuery = ''.obs;
}
