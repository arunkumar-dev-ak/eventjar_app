import 'package:eventjar_app/model/meta/meta_model.dart'; // Update import if needed

class EventInfo {
  final String id;
  final String organizerId;
  final String title;
  final String? description;
  final String? venue;
  final String? address;
  final String? location;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final String? placeId;
  final DateTime startDate;
  final DateTime endDate;
  final String? date; // legacy
  final String? startTime;
  final String? endTime;
  final DateTime? publishDate;
  final bool isVirtual;
  final bool isHybrid;
  final String? virtualLink;
  final String? virtualPlatform;
  final int maxAttendees;
  final int currentAttendees;
  final String? eventCapacityType;
  final bool isPaid;
  final double? ticketPrice;
  final double? earlyBirdPrice;
  final DateTime? earlyBirdEndDate;
  final DateTime? bookingLastDate;
  final bool platformFeeEnabled;
  final double? platformFeePercent;
  final String? status;
  final bool requiresApproval;
  final bool isOneMeetingEnabled;
  final bool badgeRequirementEnabled;
  final List<String> requiredBadgeId;
  final List<dynamic> agenda;
  final List<Media> media;
  final String? featuredImageUrl;
  final List<String> galleryImages;
  final List<String> tags;
  final List<dynamic> amenities;
  final String? eventWebsite;
  final dynamic socialLinks; // Could be Map or null
  final String? registrationInstructions;
  final String? cancellationPolicy;
  final String? refundPolicy;
  final dynamic contactInfo;
  final String? ageRestriction;
  final String? dressCode;
  final String? language;
  final String? parkingInfo;
  final String? accessibilityInfo;
  final String? specialInstructions;
  final String? termsAndConditions;
  final String? organizerContactName;
  final String? organizerContactEmail;
  final String? organizerContactPhone;
  final String? organizerWebsite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? categoryId;
  final Organizer organizer;
  final List<TicketTier> ticketTiers;
  final List<dynamic> agendaItems;
  final Category? category;
  final List<dynamic> tagAssignments;
  final List<dynamic> reviews;
  final EventCount count;
  final dynamic averageRating;
  final RegistrationStats? registrationStats;

  EventInfo({
    required this.id,
    required this.organizerId,
    required this.title,
    this.description,
    this.venue,
    this.address,
    this.location,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.placeId,
    required this.startDate,
    required this.endDate,
    this.date,
    this.startTime,
    this.endTime,
    this.publishDate,
    required this.isVirtual,
    required this.isHybrid,
    this.virtualLink,
    this.virtualPlatform,
    required this.maxAttendees,
    required this.currentAttendees,
    this.eventCapacityType,
    required this.isPaid,
    this.ticketPrice,
    this.earlyBirdPrice,
    this.earlyBirdEndDate,
    this.bookingLastDate,
    required this.platformFeeEnabled,
    this.platformFeePercent,
    this.status,
    required this.requiresApproval,
    required this.isOneMeetingEnabled,
    required this.badgeRequirementEnabled,
    required this.requiredBadgeId,
    required this.agenda,
    required this.media,
    this.featuredImageUrl,
    required this.galleryImages,
    required this.tags,
    required this.amenities,
    this.eventWebsite,
    this.socialLinks,
    this.registrationInstructions,
    this.cancellationPolicy,
    this.refundPolicy,
    this.contactInfo,
    this.ageRestriction,
    this.dressCode,
    this.language,
    this.parkingInfo,
    this.accessibilityInfo,
    this.specialInstructions,
    this.termsAndConditions,
    this.organizerContactName,
    this.organizerContactEmail,
    this.organizerContactPhone,
    this.organizerWebsite,
    required this.createdAt,
    required this.updatedAt,
    this.categoryId,
    required this.organizer,
    required this.ticketTiers,
    required this.agendaItems,
    this.category,
    required this.tagAssignments,
    required this.reviews,
    required this.count,
    this.averageRating,
    required this.registrationStats,
  });

  factory EventInfo.fromJson(Map<String, dynamic> json) {
    double? parseDoubleSafe(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return EventInfo(
      id: json['id'],
      organizerId: json['organizerId'],
      title: json['title'] ?? '',
      description: json['description'],
      venue: json['venue'],
      address: json['address'],
      location: json['location'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'],
      latitude: parseDoubleSafe(json['latitude']),
      longitude: parseDoubleSafe(json['longitude']),
      placeId: json['placeId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      publishDate: json['publishDate'] != null
          ? DateTime.parse(json['publishDate'])
          : null,
      isVirtual: json['isVirtual'] ?? false,
      isHybrid: json['isHybrid'] ?? false,
      virtualLink: json['virtualLink'],
      virtualPlatform: json['virtualPlatform'],
      maxAttendees: json['maxAttendees'] ?? 0,
      currentAttendees: json['currentAttendees'] ?? 0,
      eventCapacityType: json['eventCapacityType'],
      isPaid: json['isPaid'] ?? false,
      ticketPrice: parseDoubleSafe(json['ticketPrice']),
      earlyBirdPrice: parseDoubleSafe(json['earlyBirdPrice']),
      earlyBirdEndDate: json['earlyBirdEndDate'] != null
          ? DateTime.parse(json['earlyBirdEndDate'])
          : null,
      bookingLastDate: json['bookingLastDate'] != null
          ? DateTime.parse(json['bookingLastDate'])
          : null,
      platformFeeEnabled: json['platformFeeEnabled'] ?? false,
      platformFeePercent: parseDoubleSafe(json['platformFeePercent']),
      status: json['status'],
      requiresApproval: json['requiresApproval'] ?? false,
      isOneMeetingEnabled: json['isOneMeetingEnabled'] ?? false,
      badgeRequirementEnabled: json['badgeRequirementEnabled'] ?? false,
      requiredBadgeId:
          (json['requiredBadgeId'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      agenda: json['agenda'] as List<dynamic>? ?? [],
      media:
          (json['media'] as List<dynamic>?)
              ?.map((e) => Media.fromJson(e))
              .toList() ??
          [],
      featuredImageUrl: json['featuredImageUrl'],
      galleryImages:
          (json['galleryImages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      amenities: json['amenities'] as List<dynamic>? ?? [],
      eventWebsite: json['eventWebsite'],
      socialLinks: json['socialLinks'],
      registrationInstructions: json['registrationInstructions'],
      cancellationPolicy: json['cancellationPolicy'],
      refundPolicy: json['refundPolicy'] ?? '',
      contactInfo: json['contactInfo'],
      ageRestriction: json['ageRestriction'],
      dressCode: json['dressCode'],
      language: json['language'],
      parkingInfo: json['parkingInfo'] ?? '',
      accessibilityInfo: json['accessibilityInfo'] ?? '',
      specialInstructions: json['specialInstructions'] ?? '',
      termsAndConditions: json['termsAndConditions'] ?? '',
      organizerContactName: json['organizerContactName'] ?? '',
      organizerContactEmail: json['organizerContactEmail'] ?? '',
      organizerContactPhone: json['organizerContactPhone'] ?? '',
      organizerWebsite: json['organizerWebsite'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      categoryId: json['categoryId'],
      organizer: Organizer.fromJson(json['organizer']),
      ticketTiers:
          (json['ticketTiers'] as List<dynamic>?)
              ?.map((e) => TicketTier.fromJson(e))
              .toList() ??
          [],
      agendaItems: json['agendaItems'] as List<dynamic>? ?? [],
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
      tagAssignments: json['tagAssignments'] as List<dynamic>? ?? [],
      reviews: json['reviews'] as List<dynamic>? ?? [],
      count: EventCount.fromJson(json['_count']),
      averageRating: json['averageRating'],
      registrationStats: json['registrationStats'] != null
          ? RegistrationStats.fromJson(json['registrationStats'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizerId': organizerId,
      'title': title,
      'description': description,
      'venue': venue,
      'address': address,
      'location': location,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'placeId': placeId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'publishDate': publishDate?.toIso8601String(),
      'isVirtual': isVirtual,
      'isHybrid': isHybrid,
      'virtualLink': virtualLink,
      'virtualPlatform': virtualPlatform,
      'maxAttendees': maxAttendees,
      'currentAttendees': currentAttendees,
      'eventCapacityType': eventCapacityType,
      'isPaid': isPaid,
      'ticketPrice': ticketPrice,
      'earlyBirdPrice': earlyBirdPrice,
      'earlyBirdEndDate': earlyBirdEndDate?.toIso8601String(),
      'bookingLastDate': bookingLastDate?.toIso8601String(),
      'platformFeeEnabled': platformFeeEnabled,
      'platformFeePercent': platformFeePercent,
      'status': status,
      'requiresApproval': requiresApproval,
      'isOneMeetingEnabled': isOneMeetingEnabled,
      'badgeRequirementEnabled': badgeRequirementEnabled,
      'requiredBadgeId': requiredBadgeId,
      'agenda': agenda,
      'media': media.map((e) => e.toJson()).toList(),
      'featuredImageUrl': featuredImageUrl,
      'galleryImages': galleryImages,
      'tags': tags,
      'amenities': amenities,
      'eventWebsite': eventWebsite,
      'socialLinks': socialLinks,
      'registrationInstructions': registrationInstructions,
      'cancellationPolicy': cancellationPolicy,
      'refundPolicy': refundPolicy,
      'contactInfo': contactInfo,
      'ageRestriction': ageRestriction,
      'dressCode': dressCode,
      'language': language,
      'parkingInfo': parkingInfo,
      'accessibilityInfo': accessibilityInfo,
      'specialInstructions': specialInstructions,
      'termsAndConditions': termsAndConditions,
      'organizerContactName': organizerContactName,
      'organizerContactEmail': organizerContactEmail,
      'organizerContactPhone': organizerContactPhone,
      'organizerWebsite': organizerWebsite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'categoryId': categoryId,
      'organizer': organizer.toJson(),
      'ticketTiers': ticketTiers.map((e) => e.toJson()).toList(),
      'agendaItems': agendaItems,
      'category': category?.toJson(),
      'tagAssignments': tagAssignments,
      'reviews': reviews,
      '_count': count.toJson(),
      'averageRating': averageRating,
      'registrationStats': registrationStats?.toJson(),
    };
  }
}

class Organizer {
  final String id;
  final String name;
  final String? email;
  final String? role;
  final String? avatarUrl;
  final String? bio;
  final String? company;
  final String? website;
  final String? linkedin;

  Organizer({
    required this.id,
    required this.name,
    this.email,
    this.role,
    this.avatarUrl,
    this.bio,
    this.company,
    this.website,
    this.linkedin,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'],
      role: json['role'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      company: json['company'],
      website: json['website'],
      linkedin: json['linkedin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'company': company,
      'website': website,
      'linkedin': linkedin,
    };
  }
}

class Media {
  final String id;
  final String url;
  final String name;
  final String? type;
  final String? description;
  final bool? isFeatured;
  final int? orderIndex;

  Media({
    required this.id,
    required this.url,
    required this.name,
    this.type,
    this.description,
    this.isFeatured,
    this.orderIndex,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      url: json['url'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      isFeatured: json['is_featured'],
      orderIndex: json['order_index'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'name': name,
      'type': type,
      'description': description,
      'is_featured': isFeatured,
      'order_index': orderIndex,
    };
  }
}

class TicketTier {
  final String id;
  final String eventId;
  final String name;
  final String? description;
  final String price;
  final double? earlyBirdPrice;
  final int quantity;
  final int sold;
  final String? type;
  final bool isEarlyBird;
  final DateTime? earlyBirdEndDate;
  final DateTime? saleStartDate;
  final DateTime? saleEndDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  TicketTier({
    required this.id,
    required this.eventId,
    required this.name,
    this.description,
    required this.price,
    this.earlyBirdPrice,
    required this.quantity,
    required this.sold,
    this.type,
    required this.isEarlyBird,
    this.earlyBirdEndDate,
    this.saleStartDate,
    this.saleEndDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketTier.fromJson(Map<String, dynamic> json) {
    return TicketTier(
      id: json['id'],
      eventId: json['eventId'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      earlyBirdPrice: json['earlyBirdPrice'] != null
          ? (json['earlyBirdPrice'] as num).toDouble()
          : null,
      quantity: json['quantity'],
      sold: json['sold'],
      type: json['type'],
      isEarlyBird: json['isEarlyBird'] ?? false,
      earlyBirdEndDate: json['earlyBirdEndDate'] != null
          ? DateTime.parse(json['earlyBirdEndDate'])
          : null,
      saleStartDate: json['saleStartDate'] != null
          ? DateTime.parse(json['saleStartDate'])
          : null,
      saleEndDate: json['saleEndDate'] != null
          ? DateTime.parse(json['saleEndDate'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'name': name,
      'description': description,
      'price': price,
      'earlyBirdPrice': earlyBirdPrice,
      'quantity': quantity,
      'sold': sold,
      'type': type,
      'isEarlyBird': isEarlyBird,
      'earlyBirdEndDate': earlyBirdEndDate?.toIso8601String(),
      'saleStartDate': saleStartDate?.toIso8601String(),
      'saleEndDate': saleEndDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Category {
  final String? id;
  final String? name;
  final String? description;
  final String? icon;
  final String? color;

  Category({this.id, this.name, this.description, this.icon, this.color});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
    };
  }
}

class EventCount {
  final int registrations;
  final int reviews;

  EventCount({required this.registrations, required this.reviews});

  factory EventCount.fromJson(Map<String, dynamic> json) {
    return EventCount(
      registrations: json['registrations'] ?? 0,
      reviews: json['reviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'registrations': registrations, 'reviews': reviews};
  }
}

class RegistrationStats {
  final int totalRegistrations;
  final int availableSpots;
  final String? capacityType;
  final bool requiresApproval;

  RegistrationStats({
    required this.totalRegistrations,
    required this.availableSpots,
    this.capacityType,
    required this.requiresApproval,
  });

  factory RegistrationStats.fromJson(Map<String, dynamic> json) {
    return RegistrationStats(
      totalRegistrations: json['totalRegistrations'] ?? 0,
      availableSpots: json['availableSpots'] ?? 0,
      capacityType: json['capacityType'],
      requiresApproval: json['requiresApproval'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRegistrations': totalRegistrations,
      'availableSpots': availableSpots,
      'capacityType': capacityType,
      'requiresApproval': requiresApproval,
    };
  }
}
