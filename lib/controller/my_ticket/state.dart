import 'package:eventjar/model/my_ticket/my_ticket_model.dart';
import 'package:get/get.dart';

class MyTicketsState {
  final RxList<MyTicket> tickets = <MyTicket>[].obs;
  final Rx<TicketPagination?> pagination = Rx<TicketPagination?>(null);

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxInt currentPage = 1.obs;

  final RxSet<int> expandedTickets = <int>{}.obs;

  final selectedTab = 0.obs;
  final searchQuery = ''.obs;
  final selectedDate = Rxn<DateTime>();
}
