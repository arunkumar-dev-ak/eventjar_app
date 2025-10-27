import 'package:eventjar_app/model/meta/meta_model.dart'; // Adjust if needed

class EventInfoResponse {
  final EventInfo data;
  final Meta meta;

  EventInfoResponse({required this.data, required this.meta});

  factory EventInfoResponse.fromJson(Map<String, dynamic> json) {
    try {
      return EventInfoResponse(
        data: EventInfo.fromJson(json['data']),
        meta: Meta.fromJson(json['meta']),
      );
    } catch (e) {
      throw Exception('Error in EventInfoResponse: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'data': data.toJson(),
    'meta': meta.toJson(),
  };
}

class EventInfo {
  final String id;
  final String organizerId;
  final String title;
  final String description;
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
  final DateTime date;
  final String startTime;
  final String endTime;
  final DateTime publishDate;
  final bool isVirtual;
  final bool isHybrid;
  final String? virtualLink;
  final String? virtualPlatform;
  final int maxAttendees;
  final int currentAttendees;
  final String eventCapacityType;
  final bool isPaid;
  final double? ticketPrice;
  final double? earlyBirdPrice;
  final DateTime? earlyBirdEndDate;
  final DateTime bookingLastDate;
  final bool platformFeeEnabled;
  final String platformFeePercent;
  final String status;
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
  final String? socialLinks;
  final String? registrationInstructions;
  final String? cancellationPolicy;
  final String refundPolicy;
  final String? contactInfo;
  final String? ageRestriction;
  final String? dressCode;
  final String? language;
  final String parkingInfo;
  final String accessibilityInfo;
  final String specialInstructions;
  final String termsAndConditions;
  final String organizerContactName;
  final String organizerContactEmail;
  final String organizerContactPhone;
  final String organizerWebsite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String categoryId;
  final Organizer organizer;
  final List<TicketTier> ticketTiers;
  final List<dynamic> agendaItems;
  final Category category;
  final List<dynamic> tagAssignments;
  final List<dynamic> reviews;
  final EventCount count;
  final dynamic averageRating;
  final RegistrationStats registrationStats;

  EventInfo({
    required this.id,
    required this.organizerId,
    required this.title,
    required this.description,
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
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.publishDate,
    required this.isVirtual,
    required this.isHybrid,
    this.virtualLink,
    this.virtualPlatform,
    required this.maxAttendees,
    required this.currentAttendees,
    required this.eventCapacityType,
    required this.isPaid,
    this.ticketPrice,
    this.earlyBirdPrice,
    this.earlyBirdEndDate,
    required this.bookingLastDate,
    required this.platformFeeEnabled,
    required this.platformFeePercent,
    required this.status,
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
    required this.refundPolicy,
    this.contactInfo,
    this.ageRestriction,
    this.dressCode,
    this.language,
    required this.parkingInfo,
    required this.accessibilityInfo,
    required this.specialInstructions,
    required this.termsAndConditions,
    required this.organizerContactName,
    required this.organizerContactEmail,
    required this.organizerContactPhone,
    required this.organizerWebsite,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
    required this.organizer,
    required this.ticketTiers,
    required this.agendaItems,
    required this.category,
    required this.tagAssignments,
    required this.reviews,
    required this.count,
    this.averageRating,
    required this.registrationStats,
  });

  factory EventInfo.fromJson(Map<String, dynamic> json) {
    try {
      return EventInfo(
        id: json['id'],
        organizerId: json['organizerId'],
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        venue: json['venue'],
        address: json['address'],
        location: json['location'],
        city: json['city'],
        state: json['state'],
        country: json['country'],
        postalCode: json['postalCode'],
        latitude: json['latitude'] != null
            ? (json['latitude'] as num).toDouble()
            : null,
        longitude: json['longitude'] != null
            ? (json['longitude'] as num).toDouble()
            : null,
        placeId: json['placeId'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        date: DateTime.parse(json['date']),
        startTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '',
        publishDate: DateTime.parse(json['publishDate']),
        isVirtual: json['isVirtual'] ?? false,
        isHybrid: json['isHybrid'] ?? false,
        virtualLink: json['virtualLink'],
        virtualPlatform: json['virtualPlatform'],
        maxAttendees: json['maxAttendees'] ?? 0,
        currentAttendees: json['currentAttendees'] ?? 0,
        eventCapacityType: json['eventCapacityType'] ?? '',
        isPaid: json['isPaid'] ?? false,
        ticketPrice: json['ticketPrice'] != null
            ? (json['ticketPrice'] as num).toDouble()
            : null,
        earlyBirdPrice: json['earlyBirdPrice'] != null
            ? (json['earlyBirdPrice'] as num).toDouble()
            : null,
        earlyBirdEndDate: json['earlyBirdEndDate'] != null
            ? DateTime.parse(json['earlyBirdEndDate'])
            : null,
        bookingLastDate: DateTime.parse(json['bookingLastDate']),
        platformFeeEnabled: json['platformFeeEnabled'] ?? false,
        platformFeePercent: json['platformFeePercent'] ?? '',
        status: json['status'] ?? '',
        requiresApproval: json['requiresApproval'] ?? false,
        isOneMeetingEnabled: json['isOneMeetingEnabled'] ?? false,
        badgeRequirementEnabled: json['badgeRequirementEnabled'] ?? false,
        requiredBadgeId: List<String>.from(
          json['requiredBadgeId'].map((e) => e.toString()),
        ),
        agenda: List<dynamic>.from(json['agenda']),
        media: List<Media>.from(json['media'].map((e) => Media.fromJson(e))),
        featuredImageUrl: json['featuredImageUrl'],
        galleryImages: List<String>.from(json['galleryImages']),
        tags: List<String>.from(json['tags']),
        amenities: List<dynamic>.from(json['amenities']),
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
        categoryId: json['categoryId'] ?? '',
        organizer: Organizer.fromJson(json['organizer']),
        ticketTiers: List<TicketTier>.from(
          json['ticketTiers'].map((e) => TicketTier.fromJson(e)),
        ),
        agendaItems: List<dynamic>.from(json['agendaItems']),
        category: Category.fromJson(json['category']),
        tagAssignments: List<dynamic>.from(json['tagAssignments']),
        reviews: List<dynamic>.from(json['reviews']),
        count: EventCount.fromJson(json['_count']),
        averageRating: json['averageRating'],
        registrationStats: RegistrationStats.fromJson(
          json['registrationStats'],
        ),
      );
    } catch (e) {
      throw Exception('Error in EventInfo: $e');
    }
  }

  Map<String, dynamic> toJson() => {
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
    'date': date.toIso8601String(),
    'startTime': startTime,
    'endTime': endTime,
    'publishDate': publishDate.toIso8601String(),
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
    'bookingLastDate': bookingLastDate.toIso8601String(),
    'platformFeeEnabled': platformFeeEnabled,
    'platformFeePercent': platformFeePercent,
    'status': status,
    'requiresApproval': requiresApproval,
    'isOneMeetingEnabled': isOneMeetingEnabled,
    'badgeRequirementEnabled': badgeRequirementEnabled,
    'requiredBadgeId': List<dynamic>.from(requiredBadgeId),
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
    'category': category.toJson(),
    'tagAssignments': tagAssignments,
    'reviews': reviews,
    '_count': count.toJson(),
    'averageRating': averageRating,
    'registrationStats': registrationStats.toJson(),
  };
}

class Organizer {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final String? bio;
  final String? company;
  final String? website;
  final String? linkedin;

  Organizer({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.bio,
    this.company,
    this.website,
    this.linkedin,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      company: json['company'],
      website: json['website'],
      linkedin: json['linkedin'],
    );
  }

  Map<String, dynamic> toJson() => {
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

class Media {
  final String id;
  final String url;
  final String name;
  final String type;
  final String description;
  final bool isFeatured;
  final int orderIndex;

  Media({
    required this.id,
    required this.url,
    required this.name,
    required this.type,
    required this.description,
    required this.isFeatured,
    required this.orderIndex,
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'name': name,
    'type': type,
    'description': description,
    'is_featured': isFeatured,
    'order_index': orderIndex,
  };
}

class TicketTier {
  final String id;
  final String eventId;
  final String name;
  final String description;
  final String price;
  final double? earlyBirdPrice;
  final int quantity;
  final int sold;
  final String type;
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
    required this.description,
    required this.price,
    this.earlyBirdPrice,
    required this.quantity,
    required this.sold,
    required this.type,
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
      isEarlyBird: json['isEarlyBird'],
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

  Map<String, dynamic> toJson() => {
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

class EventCount {
  final int registrations;
  final int reviews;

  EventCount({required this.registrations, required this.reviews});

  factory EventCount.fromJson(Map<String, dynamic> json) {
    return EventCount(
      registrations: json['registrations'],
      reviews: json['reviews'],
    );
  }

  Map<String, dynamic> toJson() => {
    'registrations': registrations,
    'reviews': reviews,
  };
}

class RegistrationStats {
  final int totalRegistrations;
  final int availableSpots;
  final String capacityType;
  final bool requiresApproval;

  RegistrationStats({
    required this.totalRegistrations,
    required this.availableSpots,
    required this.capacityType,
    required this.requiresApproval,
  });

  factory RegistrationStats.fromJson(Map<String, dynamic> json) {
    return RegistrationStats(
      totalRegistrations: json['totalRegistrations'],
      availableSpots: json['availableSpots'],
      capacityType: json['capacityType'],
      requiresApproval: json['requiresApproval'],
    );
  }

  Map<String, dynamic> toJson() => {
    'totalRegistrations': totalRegistrations,
    'availableSpots': availableSpots,
    'capacityType': capacityType,
    'requiresApproval': requiresApproval,
  };
}
