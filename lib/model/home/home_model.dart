import 'dart:ui';

import 'package:eventjar/model/meta/meta_model.dart';

import '../contact/mobile_contact_model.dart';

class EventResponse {
  final List<Event> data;
  final Meta meta;
  String? message;
  int? statusCode;

  EventResponse({
    required this.data,
    required this.meta,
    this.message,
    this.statusCode,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    try {
      return EventResponse(
        data: (json['data'] as List).map((e) => Event.fromJson(e)).toList(),
        meta: Meta.fromJson(json['meta']),
        message: json["message"],
        statusCode: json["statusCode"],
      );
    } catch (e) {
      throw Exception('Error in EventResponse: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'meta': meta.toJson(),
    "message": message,
    "statusCode": statusCode,
  };
}

class Event {
  final String id;
  final String title;
  final String slug;
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
    required this.slug,
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
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        slug: json['slug'] ?? '',
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
        startDate: json['startDate'] != null
            ? DateTime.parse(json['startDate'])
            : DateTime.now(),
        endDate: json['endDate'] != null
            ? DateTime.parse(json['endDate'])
            : DateTime.now(),
        startTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '',
        isVirtual: json['isVirtual'] ?? false,
        isHybrid: json['isHybrid'] ?? false,
        isPaid: json['isPaid'] ?? false,
        ticketPrice: json['ticketPrice'] == null
            ? null
            : double.tryParse(json['ticketPrice'].toString()),
        maxAttendees: json['maxAttendees'] ?? 0,
        currentAttendees: json['currentAttendees'] ?? 0,
        featuredImageUrl: json['featuredImageUrl'],
        status: json['status'] ?? '',
        organizer: json['organizer'] != null
            ? Organizer.fromJson(json['organizer'])
            : Organizer(id: '', name: ''),
        ticketTiers:
            (json['ticketTiers'] as List?)
                ?.map((t) => TicketTier.fromJson(t))
                .toList() ??
            [],
      );
    } catch (e) {
      throw Exception('Error in Event: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '',
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
    return Organizer(id: json['id'] ?? '', name: json['name'] ?? '');
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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price']?.toString() ?? '0',
      quantity: json['quantity'] ?? 0,
      isUnlimited: json['isUnlimited'] ?? false,
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

class CategoryList {
  List<EventCategory>? eventCategories;

  CategoryList({this.eventCategories});

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
    eventCategories: json["eventCategories"] == null
        ? []
        : List<EventCategory>.from(
            json["eventCategories"]!.map((x) => EventCategory.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "eventCategories": eventCategories == null
        ? []
        : List<dynamic>.from(eventCategories!.map((x) => x.toJson())),
  };
}

class EventCategory {
  String? id;
  String? name;
  String? icon;
  String? color;
  Count? count;

  EventCategory({this.id, this.name, this.icon, this.color, this.count});

  factory EventCategory.fromJson(Map<String, dynamic> json) => EventCategory(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    color: json["color"],
    count: json["_count"] == null ? null : Count.fromJson(json["_count"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "color": color,
    "_count": count?.toJson(),
  };
}

class Count {
  int? events;

  Count({this.events});

  factory Count.fromJson(Map<String, dynamic> json) =>
      Count(events: json["events"]);

  Map<String, dynamic> toJson() => {"events": events};
}

class Medal {
  final Color baseColor;
  final Color highlightColor;
  final Color shadowColor;
  final bool enabled;
  final String name;

  const Medal({
    required this.baseColor,
    required this.highlightColor,
    required this.shadowColor,
    required this.enabled,
    required this.name,
  });
}

class ProfileInfo {
  int? contactCount;
  String? id;
  String? email;
  String? name;
  String? phone;
  String? role;
  bool? isVerified;
  bool? phoneVerified;
  String? avatarUrl;
  dynamic extendedProfile;
  PhoneParsed? phoneParsed;
  int? notificationCount;

  ProfileInfo({
    this.contactCount,
    this.id,
    this.email,
    this.name,
    this.phone,
    this.role,
    this.isVerified,
    this.phoneVerified,
    this.avatarUrl,
    this.extendedProfile,
    this.phoneParsed,
    this.notificationCount,
  });

  factory ProfileInfo.fromJson(Map<String, dynamic> json) => ProfileInfo(
    contactCount: json["contactCount"],
    id: json["id"],
    email: json["email"],
    name: json["name"],
    phone: json["phone"],
    role: json["role"],
    isVerified: json["isVerified"],
    phoneVerified: json["phoneVerified"],
    avatarUrl: json["avatarUrl"],
    extendedProfile: json["extendedProfile"],
    phoneParsed: json["phoneParsed"] == null
        ? null
        : PhoneParsed.fromJson(json["phoneParsed"]),
    notificationCount: json["notificationCount"],
  );

  Map<String, dynamic> toJson() => {
    "contactCount": contactCount,
    "id": id,
    "email": email,
    "name": name,
    "phone": phone,
    "role": role,
    "isVerified": isVerified,
    "phoneVerified": phoneVerified,
    "avatarUrl": avatarUrl,
    "extendedProfile": extendedProfile,
    "phoneParsed": phoneParsed?.toJson(),
    "notificationCount": notificationCount,
  };
}
