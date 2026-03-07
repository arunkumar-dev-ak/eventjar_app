import 'package:eventjar/logger_service.dart';
import 'package:eventjar/model/meta/meta_model.dart';

class MobileTicketResponse {
  final List<MobileTicket> data;
  final Meta meta;

  MobileTicketResponse({required this.data, required this.meta});

  factory MobileTicketResponse.fromJson(Map<String, dynamic> json) {
    try {
      return MobileTicketResponse(
        data: (json['data'] as List<dynamic>)
            .map((e) => MobileTicket.fromJson(e))
            .toList(),
        meta: Meta.fromJson(json['meta']),
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

class MobileTicket {
  final String id;
  final String status;
  final DateTime registeredAt;
  final String qrCode;
  final TicketTierDetail ticketTierDetail;
  final TicketEventDetail ticketEventDetail;

  MobileTicket({
    required this.id,
    required this.status,
    required this.registeredAt,
    required this.qrCode,
    required this.ticketTierDetail,
    required this.ticketEventDetail,
  });

  factory MobileTicket.fromJson(Map<String, dynamic> json) {
    try {
      return MobileTicket(
        id: json['id'],
        status: json['status'],
        registeredAt: DateTime.parse(json['registeredAt']),
        qrCode: json['qrCode'],
        ticketTierDetail: TicketTierDetail.fromJson(json['ticketTier']),
        ticketEventDetail: TicketEventDetail.fromJson(json['event']),
      );
    } catch (e) {
      LoggerService.loggerInstance.e('Error parsing MobileTicket: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'registeredAt': registeredAt.toIso8601String(),
    'qrCode': qrCode,
    'ticketTier': ticketTierDetail.toJson(),
    'event': ticketEventDetail.toJson(),
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
