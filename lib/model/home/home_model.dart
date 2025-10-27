import 'package:eventjar_app/model/meta/meta_model.dart';

class EventResponse {
  final List<Event> data;
  final Meta meta;

  EventResponse({required this.data, required this.meta});

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    try {
      return EventResponse(
        data: (json['data'] as List).map((e) => Event.fromJson(e)).toList(),
        meta: Meta.fromJson(json['meta']),
      );
    } catch (e) {
      throw Exception('Error in EventResponse: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'meta': meta.toJson(),
  };
}

class Event {
  final String id;
  final String title;
  final String description;
  final String? venue;
  final String? address;
  final String? location;
  final String? city;
  final String? state;
  final String? country;
  final DateTime startDate;
  final DateTime endDate;
  final String startTime;
  final String endTime;
  final bool isVirtual;
  final bool isHybrid;
  final bool isPaid;
  final double? ticketPrice;
  final int maxAttendees;
  final Category? category;
  final int currentAttendees;
  final String? featuredImageUrl;
  final String status;
  final Organizer organizer;
  final List<TicketTier> ticketTiers;

  Event({
    required this.id,
    required this.title,
    required this.description,
    this.venue,
    this.address,
    this.location,
    this.city,
    this.state,
    this.country,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.isVirtual,
    required this.isHybrid,
    required this.isPaid,
    this.category,
    this.ticketPrice,
    required this.maxAttendees,
    required this.currentAttendees,
    this.featuredImageUrl,
    required this.status,
    required this.organizer,
    required this.ticketTiers,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    try {
      return Event(
        id: json['id'],
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        venue: json['venue'],
        address: json['address'],
        location: json['location'],
        city: json['city'],
        state: json['state'],
        country: json['country'],
        category: json['category'] != null
            ? Category.fromJson(json['category'])
            : null,
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        startTime: json['startTime'],
        endTime: json['endTime'],
        isVirtual: json['isVirtual'] ?? false,
        isHybrid: json['isHybrid'] ?? false,
        isPaid: json['isPaid'],
        ticketPrice: json['ticketPrice'] == null
            ? null
            : double.tryParse(json['ticketPrice'].toString()),
        maxAttendees: json['maxAttendees'] ?? 0,
        currentAttendees: json['currentAttendees'] ?? 0,
        featuredImageUrl: json['featuredImageUrl'],
        status: json['status'] ?? '',
        organizer: Organizer.fromJson(json['organizer']),
        ticketTiers: (json['ticketTiers'] as List)
            .map((t) => TicketTier.fromJson(t))
            .toList(),
      );
    } catch (e) {
      throw Exception('Error in Event: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'venue': venue,
    'address': address,
    'location': location,
    'city': city,
    'state': state,
    'country': country,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'startTime': startTime,
    'endTime': endTime,
    'isVirtual': isVirtual,
    'isHybrid': isHybrid,
    'isPaid': isPaid,
    'ticketPrice': ticketPrice,
    'maxAttendees': maxAttendees,
    'currentAttendees': currentAttendees,
    'featuredImageUrl': featuredImageUrl,
    'status': status,
    'category': category?.toJson(),
    'organizer': organizer.toJson(),
    'ticketTiers': ticketTiers.map((t) => t.toJson()).toList(),
  };
}

class Category {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'icon': icon,
    'color': color,
  };
}

class Organizer {
  final String id;
  final String name;

  Organizer({required this.id, required this.name});

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class TicketTier {
  final String id;
  final String name;
  final String price;
  final int quantity;
  final bool isUnlimited;

  TicketTier({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.isUnlimited,
  });

  factory TicketTier.fromJson(Map<String, dynamic> json) {
    return TicketTier(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      isUnlimited: json['isUnlimited'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'quantity': quantity,
    'isUnlimited': isUnlimited,
  };
}

class EventCount {
  final int registrations;

  EventCount({required this.registrations});

  factory EventCount.fromJson(Map<String, dynamic> json) {
    return EventCount(registrations: json['registrations']);
  }

  Map<String, dynamic> toJson() => {'registrations': registrations};
}
