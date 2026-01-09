import 'package:eventjar/logger_service.dart';

class MyRegistrationsResponse {
  final bool success;
  final MyRegistrationsData data;

  MyRegistrationsResponse({required this.success, required this.data});

  factory MyRegistrationsResponse.fromJson(Map<String, dynamic> json) {
    try {
      return MyRegistrationsResponse(
        success: json['success'] ?? false,
        data: MyRegistrationsData.fromJson(json['data']),
      );
    } catch (e) {
      throw Exception('Error in MyRegistrationsResponse: $e');
    }
  }

  Map<String, dynamic> toJson() => {'success': success, 'data': data.toJson()};
}

class MyRegistrationsData {
  final List<MyTicket> registrations;
  final TicketPagination pagination;

  MyRegistrationsData({required this.registrations, required this.pagination});

  factory MyRegistrationsData.fromJson(Map<String, dynamic> json) {
    try {
      return MyRegistrationsData(
        registrations: (json['registrations'] as List)
            .map((e) => MyTicket.fromJson(e))
            .toList(),
        pagination: TicketPagination.fromJson(json['pagination']),
      );
    } catch (e) {
      LoggerService.loggerInstance.e(e);
      throw Exception('Error in MyRegistrationsData: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'registrations': registrations.map((e) => e.toJson()).toList(),
    'pagination': pagination.toJson(),
  };
}

class MyTicket {
  final String id;
  final String eventId;
  final String attendeeId;
  final String? ticketTierId;
  final int quantity;
  final String qrCode;
  final String confirmationCode;
  final String status;
  final String paymentStatus;
  final String? paymentAmount;
  final String? paymentGateway;
  final String? paymentReference;
  final DateTime registeredAt;
  final DateTime? usedAt;
  final String? promoCodeId;
  final String? finalPrice;
  final String? ticketHash;
  final String? transferredTo;
  final DateTime? transferredAt;
  final String? transferHistory;
  final int checkInCount;
  final int maxCheckIns;
  final DateTime? lastCheckInAt;
  final TicketTierDetail? ticketTier;
  final TicketEventDetail event;

  MyTicket({
    required this.id,
    required this.eventId,
    required this.attendeeId,
    this.ticketTierId,
    required this.quantity,
    required this.qrCode,
    required this.confirmationCode,
    required this.status,
    required this.paymentStatus,
    this.paymentAmount,
    this.paymentGateway,
    this.paymentReference,
    required this.registeredAt,
    this.usedAt,
    this.promoCodeId,
    this.finalPrice,
    required this.ticketHash,
    this.transferredTo,
    this.transferredAt,
    this.transferHistory,
    required this.checkInCount,
    required this.maxCheckIns,
    this.lastCheckInAt,
    this.ticketTier,
    required this.event,
  });

  factory MyTicket.fromJson(Map<String, dynamic> json) {
    // LoggerService.loggerInstance.dynamic_d(json);
    try {
      return MyTicket(
        id: json['id'],
        eventId: json['eventId'],
        attendeeId: json['attendeeId'],
        ticketTierId: json['ticketTierId'],
        quantity: json['quantity'],
        qrCode: json['qrCode'],
        confirmationCode: json['confirmationCode'],
        status: json['status'],
        paymentStatus: json['paymentStatus'],
        paymentAmount: json['paymentAmount'],
        paymentGateway: json['paymentGateway'],
        paymentReference: json['paymentReference'],
        registeredAt: DateTime.parse(json['registeredAt']),
        usedAt: json['usedAt'] != null ? DateTime.parse(json['usedAt']) : null,
        promoCodeId: json['promoCodeId'],
        finalPrice: json['finalPrice'],
        ticketHash: json['ticketHash'],
        transferredTo: json['transferredTo'],
        transferredAt: json['transferredAt'] != null
            ? DateTime.parse(json['transferredAt'])
            : null,
        transferHistory: json['transferHistory'],
        checkInCount: json['checkInCount'],
        maxCheckIns: json['maxCheckIns'],
        lastCheckInAt: json['lastCheckInAt'] != null
            ? DateTime.parse(json['lastCheckInAt'])
            : null,
        ticketTier: json['ticketTier'] == null
            ? null
            : TicketTierDetail.fromJson(json['ticketTier']),
        event: TicketEventDetail.fromJson(json['event']),
      );
    } catch (e) {
      throw Exception('Error in MyTicket: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'eventId': eventId,
    'attendeeId': attendeeId,
    'ticketTierId': ticketTierId,
    'quantity': quantity,
    'qrCode': qrCode,
    'confirmationCode': confirmationCode,
    'status': status,
    'paymentStatus': paymentStatus,
    'paymentAmount': paymentAmount,
    'paymentGateway': paymentGateway,
    'paymentReference': paymentReference,
    'registeredAt': registeredAt.toIso8601String(),
    'usedAt': usedAt?.toIso8601String(),
    'promoCodeId': promoCodeId,
    'finalPrice': finalPrice,
    'ticketHash': ticketHash,
    'transferredTo': transferredTo,
    'transferredAt': transferredAt?.toIso8601String(),
    'transferHistory': transferHistory,
    'checkInCount': checkInCount,
    'maxCheckIns': maxCheckIns,
    'lastCheckInAt': lastCheckInAt?.toIso8601String(),
    'ticketTier': ticketTier?.toJson(),
    'event': event.toJson(),
  };
}

class TicketTierDetail {
  final String id;
  final String name;
  final String price;

  TicketTierDetail({required this.id, required this.name, required this.price});

  factory TicketTierDetail.fromJson(Map<String, dynamic> json) {
    try {
      return TicketTierDetail(
        id: json['id'],
        name: json['name'],
        price: json['price'],
      );
    } catch (e) {
      throw Exception('Error in TicketTierDetail: $e');
    }
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'price': price};
}

class TicketEventDetail {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String venue;
  final String address;
  final String status;
  final String? featuredImageUrl;

  TicketEventDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.venue,
    required this.address,
    required this.status,
    this.featuredImageUrl,
  });

  factory TicketEventDetail.fromJson(Map<String, dynamic> json) {
    try {
      return TicketEventDetail(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        venue: json['venue'],
        address: json['address'] ?? '',
        status: json['status'],
        featuredImageUrl: json['featuredImageUrl'],
      );
    } catch (e) {
      throw Exception('Error in TicketEventDetail: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'venue': venue,
    'address': address,
    'status': status,
    'featuredImageUrl': featuredImageUrl,
  };
}

class TicketPagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  TicketPagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  // 👇 These are your helper getters
  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;

  factory TicketPagination.fromJson(Map<String, dynamic> json) {
    try {
      return TicketPagination(
        total: json['total'],
        page: json['page'],
        limit: json['limit'],
        totalPages: json['totalPages'],
      );
    } catch (e) {
      throw Exception('Error in TicketPagination: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'page': page,
    'limit': limit,
    'totalPages': totalPages,
  };
}
