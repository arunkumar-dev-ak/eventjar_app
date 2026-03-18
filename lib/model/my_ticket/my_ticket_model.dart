import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/meta/mobile_meta_model.dart';

class MyTicketResponse {
  final List<MyTicket> data;
  final MobileMeta meta;

  MyTicketResponse({required this.data, required this.meta});

  factory MyTicketResponse.fromJson(Map<String, dynamic> json) {
    try {
      return MyTicketResponse(
        data: (json['data'] as List<dynamic>)
            .map((e) => MyTicket.fromJson(e))
            .toList(),
        meta: MobileMeta.fromJson(json['meta']),
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing MobileTicketResponse: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'meta': meta.toJson(),
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
  final TicketTierDetail? ticketTierDetail;
  final TicketEventDetail? ticketEventDetail;

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
    this.ticketTierDetail,
    this.ticketEventDetail,
  });

  factory MyTicket.fromJson(Map<String, dynamic> json) {
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
        ticketTierDetail: json['ticketTier'] != null
            ? TicketTierDetail.fromJson(json['ticketTier'])
            : null,

        ticketEventDetail: json['event'] != null
            ? TicketEventDetail.fromJson(json['event'])
            : null,
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing MobileTicket: $e');
      rethrow;
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
    'ticketTier': ticketTierDetail?.toJson(),
    'event': ticketEventDetail?.toJson(),
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
  final String slug;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final String startTime;
  final String endTime;
  final String venue;
  final String address;
  final String? location;
  final String? city;
  final String? featuredImageUrl;
  final String status;
  final Organizer organizer;

  TicketEventDetail({
    required this.id,
    required this.slug,
    required this.title,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.venue,
    required this.address,
    this.location,
    this.city,
    this.featuredImageUrl,
    required this.status,
    required this.organizer,
  });

  factory TicketEventDetail.fromJson(Map<String, dynamic> json) {
    try {
      return TicketEventDetail(
        id: json['id'],
        slug: json['slug'],
        title: json['title'],
        description: json['description'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        startTime: json['startTime'],
        endTime: json['endTime'],
        venue: json['venue'],
        address: json['address'],
        location: json['location'],
        city: json['city'],
        featuredImageUrl: json['featuredImageUrl'],
        status: json['status'],
        organizer: Organizer.fromJson(json['organizer']),
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing Event: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'title': title,
    'description': description,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'startTime': startTime,
    'endTime': endTime,
    'venue': venue,
    'address': address,
    'location': location,
    'city': city,
    'featuredImageUrl': featuredImageUrl,
    'status': status,
    'organizer': organizer.toJson(),
  };
}

class Organizer {
  final String id;
  final String name;
  final String? avatarUrl;

  Organizer({required this.id, required this.name, this.avatarUrl});

  factory Organizer.fromJson(Map<String, dynamic> json) {
    try {
      return Organizer(
        id: json['id'],
        name: json['name'],
        avatarUrl: json['avatarUrl'],
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing Organizer: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatarUrl': avatarUrl,
  };
}
