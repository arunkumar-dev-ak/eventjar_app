import 'package:eventjar/model/my_ticket/my_ticket_model.dart';
import 'package:get/get.dart';

class MyTicketsState {
  final RxList<MyTicket> tickets = <MyTicket>[].obs;
  final Rx<TicketPagination?> pagination = Rx<TicketPagination?>(null);

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxInt currentPage = 1.obs;

  final RxSet<int> expandedTickets = <int>{}.obs;

  final RxList<Map<String, dynamic>> dummyTickets = <Map<String, dynamic>>[
    {
      'id': 1,
      'eventTitle': 'Tech Conference 2025',
      'ticketTier': 'VIP Pass',
      'quantity': 2,
      'isFree': false,
      'price': '999',
      'isActive': true,
      'confirmationCode': 'CONF-1762171970012-ABC123',
      'qrCode': 'EVENT123:TICKET456:1762171970030:HASH789',
      'eventDate': '15 Nov 2025',
      'eventTime': '10:00 AM - 05:00 PM',
      'venue': 'Le Méridien Convention Center',
      'location': 'Coimbatore, Tamil Nadu',
      'registeredDate': '01 Nov 2025, 02:30 PM',
      'checkInCount': 0,
      'maxCheckIns': 1,
    },
    {
      'id': 2,
      'eventTitle': 'Monthly Global Business Networking Meetup',
      'ticketTier': 'Free Registration',
      'quantity': 1,
      'isFree': true,
      'price': '0',
      'isActive': true,
      'confirmationCode': 'CONF-1762171970012-XYZ789',
      'qrCode': 'EVENT456:TICKET789:1762171970030:HASH123',
      'eventDate': '16 Jun 2026',
      'eventTime': '09:00 AM - 12:00 PM',
      'venue': 'Gokulam Park',
      'location': 'Online',
      'registeredDate': '03 Nov 2025, 12:12 PM',
      'checkInCount': 0,
      'maxCheckIns': 1,
    },
    {
      'id': 3,
      'eventTitle': 'Flutter Workshop 2025',
      'ticketTier': 'Early Bird',
      'quantity': 1,
      'isFree': false,
      'price': '499',
      'isActive': false,
      'confirmationCode': 'CONF-1762171970012-DEF456',
      'qrCode': 'EVENT789:TICKET123:1762171970030:HASH456',
      'eventDate': '20 Oct 2025',
      'eventTime': '02:00 PM - 06:00 PM',
      'venue': 'Tech Hub',
      'location': 'Bangalore, Karnataka',
      'registeredDate': '15 Oct 2025, 09:45 AM',
      'checkInCount': 1,
      'maxCheckIns': 1,
    },
  ].obs;
}
